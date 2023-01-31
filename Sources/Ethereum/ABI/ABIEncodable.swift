import BigInt

public protocol ABIEncodable {
    func encode(to encoder: ABIEncoder) throws
}

public protocol ABIEncodableStaticType: ABIEncodable {
}

extension BigUInt: ABIEncodableStaticType {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let bytes = serialize().bytes.paddedLeft(to: 32, with: 0).suffix(32)
        try container.encode(bytes: bytes)
    }
}

extension BigInt: ABIEncodableStaticType {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        switch sign {
        case .plus:
            let bytes = serialize().bytes.paddedLeft(to: 32, with: 0).suffix(32)
            try container.encode(bytes: bytes)

        case .minus:
            let complement = ~magnitude + 1
            let bytes = complement.serialize().bytes.paddedLeft(to: 32, with: 0xFF).suffix(32)
            try container.encode(bytes: bytes)
        }
    }
}
