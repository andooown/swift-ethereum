import BigInt
import CryptoSwift
import Foundation

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
        let signature = ContactHelper.functionSignature(selector: "name()")
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
        let signature = ContactHelper.functionSignature(selector: "symbol()")
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
        let signature = ContactHelper.functionSignature(selector: "decimals()")
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
        let signature = ContactHelper.functionSignature(selector: "totalSupply()")
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
        let signature = ContactHelper.functionSignature(selector: "balanceOf(address)")
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
        let rawTx = try ContactHelper.makeTransaction(
            contract: contract,
            selector: "transfer(address,uint256)",
            parameter: Tuple2(to, value),
            options: options
        )
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
    }

    /// function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    public func transferFrom(
        from: Address,
        to: Address,
        value: BigUInt,
        options: TransactionOptions
    ) async throws -> Ethereum.Hash {
        let rawTx = try ContactHelper.makeTransaction(
            contract: contract,
            selector: "transferFrom(address,address,uint256)",
            parameter: Tuple3(from, to, value),
            options: options
        )
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
    }

    /// function approve(address _spender, uint256 _value) public returns (bool success)
    public func approve(
        spender: Address,
        value: BigUInt,
        options: TransactionOptions
    ) async throws -> Ethereum.Hash {
        let rawTx = try ContactHelper.makeTransaction(
            contract: contract,
            selector: "approve(address,uint256)",
            parameter: Tuple2(spender, value),
            options: options
        )
        let signedTx = try rawTx.signed(signer: options.signer, key: options.privateKey)
        let txData = try signedTx.encodeToData(chainID: options.signer.chainID)

        let request = Eth.SendRawTransaction(data: txData)
        let response = try await provider.send(request)

        let hash = Hash(hexString: response)
        return hash
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
