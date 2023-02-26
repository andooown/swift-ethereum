# swift-ethereum

The Ethereum Swift library to connect Ethereum JSON-RPC API and interact with Ethereum data structures.

## Features

- 🚧 Basic Ethereum entity definitions
- 🚧 Interact with Smart Contracts by Swifty interface
  - Currenty, supports only ERC20
- ✅ ABI encoding & decoding with Codable-like interface

## Usage
### Interacts with Smart Contracts
#### Initialize contract interface

```swift
let address = Address(hexString: "0x<contract address>")
let provider = JSONRPCProvider(
    rpcURL: URL(string: "https://<your JSON RPC URL>"),
    session: .shared
)
let contract = ERC20(contract: address, provider: provider)
```

#### Call view functions

The example to call `ERC20.balanceOf(address)`:

```swift
let owner = Address(hexString: "0x<owner address>")
let balance = try await contract.balanceOf(owner: owner)
print(balance) // => 123
```

#### Send transaction to execute function

This is the example to send transaction to execute `ERC20.transfer(address,uint256)`.

First, you need to prepare `PrivateKey` and `Signer` objects. 

`Signer` represents the signing methods of the blockchain. Currently, swift-ethereum only has `LondonSigner` which supports to sign for past London update of Ethereum.

```swift
let privateKey = try PrivateKey(hexString: "0x<your private key>")
let signer = LondonSigner(chainID: 1)
```

Then you need to build `TransactionOptions` object which contains some values to build transaction. `PrivateKey` and `Signer` objects you created are needed to pass to `TransactionOptions` object.

```swift
let gWei = BigUInt(10).power(9)
let options = TransactionOptions(
    nonce: 10,
    maxPriorityFeePerGas: 1,
    maxFeePerGas: 30 * gWei,
    gas: 100000,
    signer: signer,
    privateKey: privateKey
)
```

Finally, you can send transaction through contract interface object. Note that functions which is not marked as `view` or `pure` in Solidity will return the hash of tx as a result.

```swift
let to = Address(hexString: "0x<to address>")
let value = BigUInt(123)
let txHash = try await contract.transfer(
    to: to,
    value: 123,
    options: options
)
print(txHash) // => Hash of sent transaction
```

### ABI Encoding

You can use `ABIDataEncoder/Decoder`. 

```swift
// The parameter of ERC20 balanceOf(address) function.
let parameter = Tuple1(Address(hexString: "0xB9084d9c8A70b8Ecd2b6878ceF735F11b060DE32"))
// Encoding
let encoded = try ABIDataEncoder().encode(parameter)
// Decoding
let decoded = try ABIDataDecoder().decode(Tuple1<Address>.self, from: encoded)
```

`ABIDataEncoder/Decoder` accepts the type which conforms `ABIEncodable/Decodable`. The most of basic entities already conforms to `ABIEncodable/Decodable`, but you can make custom type conformed to `ABIEncodable/Decodable` by yourself. 

```swift
struct Params: ABICodable {
    let address: Address
    let integer: BigInt

    init(from decoder: ABIDecoder) throws {
        var container = decoder.container()
        self.address = try container.decode(Address.self)
        self.integer = try container.decode(BigInt.self)
    }

    func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()
        try container.encode(address)
        try container.encode(integer)
    }
}
```

## Author

@andooown

## License

Apache License Version 2.0

This product includes software developed by the "Marcin Krzyzanowski" (http://krzyzanowskim.com/).
