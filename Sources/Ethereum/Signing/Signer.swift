import BigInt
import CryptoSwift
import Foundation

public protocol Signer {
    var chainID: BigInt { get }

    func signatureValues(
        from signature: [UInt8],
        for txType: TransactionType
    ) throws -> (r: BigInt, s: BigInt, v: BigInt)
}

public struct LondonSigner: Signer {
    public let chainID: BigInt

    public init(chainID: BigInt) {
        self.chainID = chainID
    }

    public func signatureValues(
        from signature: [UInt8],
        for txType: TransactionType
    ) throws -> (r: BigInt, s: BigInt, v: BigInt) {
        let r = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[0..<32])))
        let s = BigInt(sign: .plus, magnitude: BigUInt(Data(signature[32..<64])))
        let v = BigInt(sign: .plus, magnitude: BigUInt(Data([signature[64]])))

        switch txType {
        case .legacy:
            return (r, s, 2 * chainID + 35 + v)

        case .dynamicFee:
            return (r, s, v)
        }
    }
}
