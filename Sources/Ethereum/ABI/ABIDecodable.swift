import BigInt
import Foundation

public protocol ABIDecodable {
    init(from decoder: ABIDecoder) throws
}

public protocol ABIDecodableStaticType: ABIDecodable {
}

extension BigUInt: ABIDecodableStaticType {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let bytes = try container.decodeBytes(slots: 1)
        self.init(Data(bytes))
    }
}

extension BigInt: ABIDecodableStaticType {
    private static let maxUInt256 = (BigUInt(1) << 256) - 1

    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let bytes = try container.decodeBytes(slots: 1)

        let sign: Sign = (bytes[0] & 0b10000000) == 0 ? .plus : .minus
        switch sign {
        case .plus:
            self.init(Data(bytes))

        case .minus:
            let magnitude = Self.maxUInt256 - BigUInt(Data(bytes)) + 1
            self.init(sign: .minus, magnitude: magnitude)
        }
    }
}

extension String: ABIDecodable {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let length = try container.decode(BigUInt.self)
        let bytes = try container.decodeExactBytes(length: Int(length))
        guard let value = String(data: Data(bytes), encoding: .utf8) else {
            throw ABIDecodingError.dataCorrupted(
                .init(debugDescription: "Can't initialize String from bytes.")
            )
        }

        self = value
    }
}
