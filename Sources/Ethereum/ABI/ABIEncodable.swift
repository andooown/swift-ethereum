import BigInt

public protocol ABIEncodable {
    func encode(to encoder: ABIEncoder) throws
}

extension BigUInt: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let bytes = serialize().bytes.paddedLeft(to: 32, with: 0)
        try container.encode(bytes: bytes)
    }
}
