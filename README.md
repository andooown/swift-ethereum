# swift-ethereum

The Ethereum Swift library to connect Ethereum JSON-RPC API and interact with Ethereum data structures.

## Features

- 🚧 Basic Ethereum entity definitions
- ✅ ABI encoding & decoding with Codable-like interface

## Usage
### ABI Encoding

You can use `ABIDataEncoder/Decoder`. 

```swift
// The parameter of ERC20 balanceOf(address) function.
let parameter = Tuple1(value0: Address(hexString: "0xB9084d9c8A70b8Ecd2b6878ceF735F11b060DE32"))
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

## License

This product includes software developed by the "Marcin Krzyzanowski" (http://krzyzanowskim.com/).
