import BigInt
import Foundation

public struct Transaction {
    public let nonce: BigUInt
    public let gasPrice: BigUInt
    public let gas: BigUInt
    public let to: Address?
    public let value: BigUInt
    public let data: Data

    public init(
        nonce: BigUInt,
        gasPrice: BigUInt,
        gas: BigUInt,
        to: Address? = nil,
        value: BigUInt,
        data: Data = Data()
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gas = gas
        self.to = to
        self.value = value
        self.data = data
    }

    public func withSignature(r: BigInt, s: BigInt, v: BigInt) -> SignedTransaction {
        SignedTransaction(tx: self, v: v, r: r, s: s)
    }

    public func signed(signer: Signer, key: PrivateKey) throws -> SignedTransaction {
        let hash = try signer.hash(tx: self)
        let signature = try key.sign(digest: hash)
        let (r, s, v) = try signer.signatureValues(from: signature)
        return withSignature(r: r, s: s, v: v)
    }
}

public struct SignedTransaction {
    public let tx: Transaction
    public let v: BigInt
    public let r: BigInt
    public let s: BigInt

    public init(
        tx: Transaction,
        v: BigInt,
        r: BigInt,
        s: BigInt
    ) {
        self.tx = tx
        self.v = v
        self.r = r
        self.s = s
    }
}

extension SignedTransaction: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        try [
            AnyRLPEncodable(tx.nonce),
            AnyRLPEncodable(tx.gasPrice),
            AnyRLPEncodable(tx.gas),
            AnyRLPEncodable(tx.to),
            AnyRLPEncodable(tx.value),
            AnyRLPEncodable(tx.data),
            AnyRLPEncodable(v),
            AnyRLPEncodable(r),
            AnyRLPEncodable(s),
        ].encodeToRLP()
    }
}
