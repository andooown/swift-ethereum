import secp256k1

public struct PrivateKey: Equatable {
    private let key: secp256k1.Signing.PrivateKey

    public init(hexString: String) throws {
        key = try secp256k1.Signing.PrivateKey(
            rawRepresentation: hexString.trimmingHexPrefix().bytes)
    }
}
