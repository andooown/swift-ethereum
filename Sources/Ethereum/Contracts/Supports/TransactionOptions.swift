import BigInt

public struct TransactionOptions {
    public let nonce: BigUInt
    public let gasPrice: BigUInt?
    public let maxPriorityFeePerGas: BigUInt?
    public let maxFeePerGas: BigUInt?
    public let gas: BigUInt
    public let value: BigUInt
    public let signer: Signer
    public let privateKey: PrivateKey

    public init(
        nonce: BigUInt,
        gasPrice: BigUInt? = nil,
        maxPriorityFeePerGas: BigUInt? = nil,
        maxFeePerGas: BigUInt? = nil,
        gas: BigUInt,
        value: BigUInt = 0,
        signer: Signer,
        privateKey: PrivateKey
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
        self.maxFeePerGas = maxFeePerGas
        self.gas = gas
        self.value = value
        self.signer = signer
        self.privateKey = privateKey
    }
}
