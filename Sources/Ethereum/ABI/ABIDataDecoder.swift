import Foundation

public struct ABIDataDecoder {
    public init() {}

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: ABIDecodable {
        return try decode(type, from: data.bytes)
    }

    public func decode<T>(_ type: T.Type, from bytes: [UInt8]) throws -> T where T: ABIDecodable {
        let slots = bytes.chunked(by: 32)
        let decoder = ABIDataDecoderImpl(slots: slots)
        return try T(from: decoder)
    }
}

private extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

public enum ABIDecodingError: Error {
    public struct Context {
        public let debugDescription: String

        public init(debugDescription: String) {
            self.debugDescription = debugDescription
        }
    }

    case dataCorrupted(Context)
}

private extension ABIDecodingError {
    static func notEnoughSlotsAvailable(required: Int, received: Int) -> Self {
        return .dataCorrupted(
            .init(
                debugDescription:
                    "Not enough slots available to decode. Requested \(required), but received \(received)."
            )
        )
    }
}

private struct ABIDataDecoderImpl: ABIDecoder {
    private var slots: [[UInt8]]
    private let container: ABIDataDecodingContainer?

    init(
        slots: [[UInt8]],
        container: ABIDataDecodingContainer? = nil
    ) {
        self.slots = slots
        self.container = container
    }

    func container(maxSlots: Int?) -> ABIDecodingContainer {
        guard let container else {
            return ABIDataDecodingContainer(slots: slots, index: .constant(0), maxSlots: maxSlots)
        }

        if let maxSlots {
            return ABIDataDecodingContainer(
                slots: slots,
                index: container.boundIndex(),
                maxSlots: min(maxSlots, container.remainingSlots)
            )
        } else {
            return ABIDataDecodingContainer(
                slots: slots,
                index: container.boundIndex(),
                maxSlots: container.remainingSlots
            )
        }
    }
}

private class ABIDataDecodingContainer: ABIDecodingContainer {
    enum IndexType {
        case constant(Int)
        case binding(get: () -> Int, set: (Int) -> Void)

        var value: Int {
            switch self {
            case .constant(let value):
                return value

            case .binding(let get, _):
                return get()
            }
        }

        mutating func update(_ newValue: Int) {
            switch self {
            case .constant:
                self = .constant(newValue)

            case .binding(_, let set):
                set(newValue)
            }
        }

        mutating func increment(by amount: Int) {
            update(value + amount)
        }
    }

    var slots: [[UInt8]]
    var index: IndexType
    let endIndex: Int

    init(slots: [[UInt8]], index: IndexType, maxSlots: Int? = nil) {
        self.slots = slots
        self.index = index
        self.endIndex = maxSlots.map { min(index.value + $0, slots.count) } ?? slots.count
    }

    var remainingSlots: Int {
        guard index.value < endIndex else {
            return 0
        }
        return endIndex - index.value
    }

    var isAtEnd: Bool {
        remainingSlots <= 0
    }

    func boundIndex() -> IndexType {
        .binding(
            get: {
                self.index.value
            },
            set: {
                self.index.update($0)
            }
        )
    }

    func decode<T>(_ type: T.Type) throws -> T where T: ABIDecodable {
        try T(from: ABIDataDecoderImpl(slots: slots, container: self))
    }

    func decodeSlots(count: Int) throws -> [[UInt8]] {
        let data = try pullSlots(count: count)
        guard data.count == count else {
            throw ABIDecodingError.notEnoughSlotsAvailable(required: count, received: data.count)
        }

        return data
    }

    private func pullSlots(count: Int) throws -> [[UInt8]] {
        let maxSlots = index.value + min(remainingSlots, count)
        let range = (index.value..<maxSlots).clamped(to: slots.indices)
        let slots = Array(slots[range])
        defer {
            index.increment(by: slots.count)
        }

        return slots
    }

    func nestedContainer(maxSlots: Int?, bindsIndex: Bool) -> ABIDecodingContainer {
        ABIDataDecodingContainer(
            slots: slots, index: bindsIndex ? boundIndex() : .constant(index.value),
            maxSlots: maxSlots)
    }

    func advanced(by slotCount: Int) -> ABIDecodingContainer {
        ABIDataDecodingContainer(
            slots: slots,
            index: .constant(index.value.advanced(by: slotCount)),
            maxSlots: remainingSlots
        )
    }
}
