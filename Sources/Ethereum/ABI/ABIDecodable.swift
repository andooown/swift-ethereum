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
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let bytes = try container.decodeBytes(slots: 1)
        self.init(Data(bytes))
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
