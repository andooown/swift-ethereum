import BigInt
import CryptoSwift
import Foundation

public enum TransactionType {
    case legacy
    case dynamicFee
}

public protocol RawTransaction {
    var type: TransactionType { get }

    func digest(chainID: BigInt) throws -> [UInt8]
    func encodeToData(
        withChainID chainID: BigInt,
        signatureV v: BigInt,
        r: BigInt,
        s: BigInt
    ) throws -> Data
}

public extension RawTransaction {
    func signed(signer: Signer, key: PrivateKey) throws -> SignedTransaction {
        let digest = try digest(chainID: signer.chainID)
        let signature = try key.sign(digest: digest)
        let (r, s, v) = try signer.signatureValues(from: signature, for: type)
        return withSignature(r: r, s: s, v: v)
    }

    func withSignature(r: BigInt, s: BigInt, v: BigInt) -> SignedTransaction {
        SignedTransaction(tx: self, v: v, r: r, s: s)
    }
}

public struct LegacyTransaction: RawTransaction {
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

    public var type: TransactionType {
        .legacy
    }

    public func digest(chainID: BigInt) throws -> [UInt8] {
        let encoded = try [
            AnyRLPEncodable(nonce),
            AnyRLPEncodable(gasPrice),
            AnyRLPEncodable(gas),
            AnyRLPEncodable(to),
            AnyRLPEncodable(value),
            AnyRLPEncodable(data),
            AnyRLPEncodable(chainID),
            AnyRLPEncodable(0),
            AnyRLPEncodable(0),
        ].encodeToRLP()
        let digest = SHA3(variant: .keccak256).calculate(for: encoded.bytes)

        return digest
    }

    public func encodeToData(
        withChainID chainID: BigInt,
        signatureV v: BigInt,
        r: BigInt,
        s: BigInt
    ) throws -> Data {
        try [
            AnyRLPEncodable(nonce),
            AnyRLPEncodable(gasPrice),
            AnyRLPEncodable(gas),
            AnyRLPEncodable(to),
            AnyRLPEncodable(value),
            AnyRLPEncodable(data),
            AnyRLPEncodable(v),
            AnyRLPEncodable(r),
            AnyRLPEncodable(s),
        ].encodeToRLP()
    }
}

public struct DynamicFeeTransaction: RawTransaction {
    public let nonce: BigUInt
    public let maxPriorityFeePerGas: BigUInt
    public let maxFeePerGas: BigUInt
    public let gas: BigUInt
    public let to: Address?
    public let value: BigUInt
    public let data: Data
    public let accessList: AccessList

    public init(
        nonce: BigUInt,
        maxPriorityFeePerGas: BigUInt,
        maxFeePerGas: BigUInt,
        gas: BigUInt,
        to: Address? = nil,
        value: BigUInt,
        data: Data = Data(),
        accessList: AccessList = AccessList()
    ) {
        self.nonce = nonce
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
        self.maxFeePerGas = maxFeePerGas
        self.gas = gas
        self.to = to
        self.value = value
        self.data = data
        self.accessList = accessList
    }

    public var type: TransactionType {
        .dynamicFee
    }

    public func digest(chainID: BigInt) throws -> [UInt8] {
        let encoded = try [
            AnyRLPEncodable(chainID),
            AnyRLPEncodable(nonce),
            AnyRLPEncodable(maxPriorityFeePerGas),
            AnyRLPEncodable(maxFeePerGas),
            AnyRLPEncodable(gas),
            AnyRLPEncodable(to),
            AnyRLPEncodable(value),
            AnyRLPEncodable(data),
            AnyRLPEncodable(accessList),
        ].encodeToRLP()
        let digest = SHA3(variant: .keccak256).calculate(for: [0x2] + encoded.bytes)

        return digest
    }

    public func encodeToData(
        withChainID chainID: BigInt,
        signatureV v: BigInt,
        r: BigInt,
        s: BigInt
    ) throws -> Data {
        try [0x2]
            + [
                AnyRLPEncodable(chainID),
                AnyRLPEncodable(nonce),
                AnyRLPEncodable(maxPriorityFeePerGas),
                AnyRLPEncodable(maxFeePerGas),
                AnyRLPEncodable(gas),
                AnyRLPEncodable(to),
                AnyRLPEncodable(value),
                AnyRLPEncodable(data),
                AnyRLPEncodable(accessList),
                AnyRLPEncodable(v),
                AnyRLPEncodable(r),
                AnyRLPEncodable(s),
            ].encodeToRLP()
    }
}

public struct SignedTransaction {
    public let tx: RawTransaction
    public let v: BigInt
    public let r: BigInt
    public let s: BigInt

    public init(
        tx: RawTransaction,
        v: BigInt,
        r: BigInt,
        s: BigInt
    ) {
        self.tx = tx
        self.v = v
        self.r = r
        self.s = s
    }

    public func encodeToData(chainID: BigInt) throws -> Data {
        try tx.encodeToData(withChainID: chainID, signatureV: v, r: r, s: s)
    }
}
