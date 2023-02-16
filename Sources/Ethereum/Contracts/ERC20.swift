import BigInt
import CryptoSwift
import Foundation

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

public enum ContractError: Error {
    case invalidTransactionOptions(message: String)
}

public struct ERC20 {
    private let contract: Address
    private let provider: JSONRPCProviderProtocol

    public init(
        contract: Address,
        provider: JSONRPCProviderProtocol
    ) {
        self.contract = contract
        self.provider = provider
    }

    /// function name() public view returns (string)
    public func name() async throws -> String {
        let signature = Array(SHA3(variant: .keccak256).calculate(for: "name()".bytes).prefix(4))
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<String>.self, from: data)

        return decoded.value0
    }

    /// function symbol() public view returns (string)
    public func symbol() async throws -> String {
        let signature = Array(SHA3(variant: .keccak256).calculate(for: "symbol()".bytes).prefix(4))
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<String>.self, from: data)

        return decoded.value0
    }

    /// function decimals() public view returns (uint8)
    public func decimals() async throws -> BigUInt {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "decimals()".bytes).prefix(4))
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<BigUInt>.self, from: data)

        return decoded.value0
    }

    /// function totalSupply() public view returns (uint256)
    public func totalSupply() async throws -> BigUInt {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "totalSupply()".bytes).prefix(4))
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<BigUInt>.self, from: data)

        return decoded.value0
    }

    /// function balanceOf(address _owner) public view returns (uint256 balance)
    public func balanceOf(owner: Address) async throws -> BigUInt {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "balanceOf(address)".bytes).prefix(4))
        let parameters = Tuple1(owner)
        let encoded = try ABIDataEncoder().encode(parameters)
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature + encoded
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<BigUInt>.self, from: data)

        return decoded.value0
    }

    /// function transfer(address _to, uint256 _value) public returns (bool success)
    public func transfer(
        to: Address,
        value: BigUInt,
        options: TransactionOptions
    ) async throws -> Ethereum.Hash {
        let rawTx = try makeTransferTransaction(to: to, value: value, options: options)
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
    }

    public func makeTransferTransaction(
        to: Address,
        value: BigUInt,
        options: TransactionOptions
    ) throws -> RawTransaction {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "transfer(address,uint256)".bytes).prefix(4))
        let parameters = Tuple2(to, value)
        let encoded = try ABIDataEncoder().encode(parameters)
        let data = Data(signature) + encoded

        let rawTx: RawTransaction
        if let gasPrice = options.gasPrice {
            rawTx = LegacyTransaction(
                nonce: options.nonce,
                gasPrice: gasPrice,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else if let maxPriorityFeePerGas = options.maxPriorityFeePerGas,
            let maxFeePerGas = options.maxFeePerGas
        {
            rawTx = DynamicFeeTransaction(
                nonce: options.nonce,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else {
            throw ContractError.invalidTransactionOptions(
                message: "Not found valid gas price option."
            )
        }

        return rawTx
    }

    /// function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    public func transferFrom(
        from: Address,
        to: Address,
        value: BigUInt,
        options: TransactionOptions
    ) async throws -> Ethereum.Hash {
        let rawTx = try makeTransferFromTransaction(
            from: from, to: to, value: value, options: options)
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
    }

    public func makeTransferFromTransaction(
        from: Address,
        to: Address,
        value: BigUInt,
        options: TransactionOptions
    ) throws -> RawTransaction {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "transferFrom(address,address,uint256)".bytes)
                .prefix(4))
        let parameters = Tuple3(from, to, value)
        let encoded = try ABIDataEncoder().encode(parameters)
        let data = Data(signature) + encoded

        let rawTx: RawTransaction
        if let gasPrice = options.gasPrice {
            rawTx = LegacyTransaction(
                nonce: options.nonce,
                gasPrice: gasPrice,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else if let maxPriorityFeePerGas = options.maxPriorityFeePerGas,
            let maxFeePerGas = options.maxFeePerGas
        {
            rawTx = DynamicFeeTransaction(
                nonce: options.nonce,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else {
            throw ContractError.invalidTransactionOptions(
                message: "Not found valid gas price option."
            )
        }

        return rawTx
    }

    /// function approve(address _spender, uint256 _value) public returns (bool success)
    public func approve(
        spender: Address,
        value: BigUInt,
        options: TransactionOptions
    ) async throws -> Ethereum.Hash {
        let rawTx = try makeApproveTransaction(spender: spender, value: value, options: options)
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
    }

    public func makeApproveTransaction(
        spender: Address,
        value: BigUInt,
        options: TransactionOptions
    ) throws -> RawTransaction {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "approve(address,uint256)".bytes).prefix(4))
        let parameters = Tuple2(spender, value)
        let encoded = try ABIDataEncoder().encode(parameters)
        let data = Data(signature) + encoded

        let rawTx: RawTransaction
        if let gasPrice = options.gasPrice {
            rawTx = LegacyTransaction(
                nonce: options.nonce,
                gasPrice: gasPrice,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else if let maxPriorityFeePerGas = options.maxPriorityFeePerGas,
            let maxFeePerGas = options.maxFeePerGas
        {
            rawTx = DynamicFeeTransaction(
                nonce: options.nonce,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else {
            throw ContractError.invalidTransactionOptions(
                message: "Not found valid gas price option."
            )
        }

        return rawTx
    }

    /// function allowance(address _owner, address _spender) public view returns (uint256 remaining)
    public func allowance(owner: Address, spender: Address) async throws -> BigUInt {
        let signature = Array(
            SHA3(variant: .keccak256).calculate(for: "allowance(address,address)".bytes).prefix(4))
        let parameters = Tuple2(owner, spender)
        let encoded = try ABIDataEncoder().encode(parameters)
        let request = Eth.Call(
            params: .init(
                to: contract,
                data: signature + encoded
            )
        )
        let response = try await provider.send(request)

        let data = Data(hex: response)
        let decoded = try ABIDataDecoder().decode(Tuple1<BigUInt>.self, from: data)

        return decoded.value0
    }
}
