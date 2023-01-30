public protocol ABIDecoder {
    func container(maxSlots: Int?) -> ABIDecodingContainer
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

internal extension ABIDecodingError {
    static func notEnoughSlotsAvailable(required: Int, received: Int) -> Self {
        return .dataCorrupted(
            .init(
                debugDescription:
                    "Not enough slots available to decode. Requested \(required), but received \(received)."
            )
        )
    }
}

public protocol ABIDecodingContainer {
    var isAtEnd: Bool { get }

    mutating func decode<T>(_ type: T.Type) throws -> T where T: ABIDecodable
    mutating func decodeSlots(count: Int) throws -> [[UInt8]]

    func nestedContainer(maxSlots: Int?, bindsIndex: Bool) -> ABIDecodingContainer

    func advanced(by slots: Int) -> ABIDecodingContainer
}

public extension ABIDecodingContainer {
    mutating func decodeBytes(slots: Int) throws -> [UInt8] {
        Array(try decodeSlots(count: slots).joined())
    }

    mutating func decodeExactBytes(length: Int) throws -> [UInt8] {
        let slots = length / 32 + (length % 32 == 0 ? 0 : 1)
        let bytes = try decodeBytes(slots: slots)
        return Array(bytes.prefix(length))
    }

    func nestedContainer(maxBytes: Int?, bindsIndex: Bool) -> ABIDecodingContainer {
        nestedContainer(
            maxSlots: maxBytes.map { $0 / 32 + ($0 % 32 == 0 ? 0 : 1) },
            bindsIndex: bindsIndex
        )
    }
}
