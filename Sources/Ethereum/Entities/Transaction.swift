import BigInt

public struct Transaction {
    public let nonce: BigUInt
    public let gasPrice: BigUInt
    public let gas: BigUInt
    public let to: Address?
    public let value: BigUInt
    public let data: [UInt8]

    public init(
        nonce: BigUInt,
        gasPrice: BigUInt,
        gas: BigUInt,
        to: Address? = nil,
        value: BigUInt,
        data: [UInt8]
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gas = gas
        self.to = to
        self.value = value
        self.data = data
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
    public func encodeToRLP() throws -> [UInt8] {
        []
    }
}
