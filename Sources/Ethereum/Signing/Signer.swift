import BigInt
import CryptoSwift
import Foundation

public protocol Signer {
    var chainID: BigInt { get }

    func hash(tx: Transaction) throws -> [UInt8]
    func signatureValues(from signature: [UInt8]) throws -> (r: BigInt, s: BigInt, v: BigInt)
}

public struct LegacyTxSigner: Signer {
    public let chainID: BigInt

    public init(chainID: BigInt) {
        self.chainID = chainID
    }

    public func hash(tx: Transaction) throws -> [UInt8] {
        let encoded = try [
            AnyRLPEncodable(tx.nonce),
            AnyRLPEncodable(tx.gasPrice),
            AnyRLPEncodable(tx.gas),
            AnyRLPEncodable(tx.to),
            AnyRLPEncodable(tx.value),
            AnyRLPEncodable(tx.data),
            AnyRLPEncodable(chainID),
            AnyRLPEncodable(0),
            AnyRLPEncodable(0),
        ].encodeToRLP()
        let digest = SHA3(variant: .keccak256).calculate(for: encoded.bytes)

        return digest
    }

    public func signatureValues(from signature: [UInt8]) throws -> (r: BigInt, s: BigInt, v: BigInt)
    {
        let r = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[0..<32])))
        let s = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[32..<64])))
        let v = BigInt(sign: .plus, magnitude: BigUInt(Data([signature[64]])))
        return (r, s, 2 * chainID + 35 + v)
    }
}
