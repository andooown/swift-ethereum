import BigInt
import Foundation
import secp256k1

import class CryptoSwift.SHA3

public struct PrivateKey: Equatable {
    private let key: secp256k1.Signing.PrivateKey

    public init(hexString: String) throws {
        key = try secp256k1.Signing.PrivateKey(
            rawRepresentation: Data(hex: hexString),
            format: .uncompressed
        )
    }

    public func sign(digest: [UInt8]) throws -> [UInt8] {
        let signature = try key.ecdsa.recoverableSignature(for: HashDigest(digest))
            .compactRepresentation
        let sigBytes = signature.signature.bytes
        return sigBytes.bytes + [UInt8(signature.recoveryId)]
    }

    public var publicKey: PublicKey {
        PublicKey(key: key.publicKey)
    }
}

public struct PublicKey {
    private let key: secp256k1.Signing.PublicKey

    public init(hexString: String) throws {
        key = try secp256k1.Signing.PublicKey(
            rawRepresentation: hexString.trimmingHexPrefix().bytes,
            format: .uncompressed
        )
    }

    fileprivate init(key: secp256k1.Signing.PublicKey) {
        self.key = key
    }

    public func toAddress() -> Address {
        Address(
            bytes: SHA3(variant: .keccak256).calculate(for: key.rawRepresentation.bytes.suffix(64)))
    }

    public static func recovery(digest: [UInt8], r: BigInt, s: BigInt, v: BigInt) throws -> Self {
        let rBytes = r.serialize().bytes.fixedLength(32)
        let sBytes = s.serialize().bytes.fixedLength(32)
        let pub = try secp256k1.Recovery.PublicKey(
            digest,
            signature: .init(compactRepresentation: rBytes + sBytes, recoveryId: Int32(v)),
            format: .compressed
        )

        return PublicKey(
            key: try secp256k1.Signing.PublicKey(
                rawRepresentation: pub.rawRepresentation, format: .compressed))
    }
}

private extension Array where Element == UInt8 {
    func fixedLength(_ length: Int) -> [UInt8] {
        (Array(repeating: 0, count: Swift.max(0, length - count)) + self).suffix(length)
    }
}
