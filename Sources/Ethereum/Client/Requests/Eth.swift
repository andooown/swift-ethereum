import BigInt
import Foundation

public enum Eth {
    public struct GetBalance: JSONRPCRequest {
        public typealias Response = String

        public struct Parameters: Encodable {
            let address: Address
            let block: RequestBlock

            public func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(address.hexString)
                try container.encode(block)
            }
        }

        public let method = "eth_getBalance"
        public let parameters: Parameters

        public init(
            address: Address,
            block: RequestBlock = .latest
        ) {
            self.parameters = Parameters(
                address: address,
                block: block
            )
        }
    }

    public struct Call: JSONRPCRequest, Equatable {
        public typealias Response = String

        public struct Parameters: Encodable, Equatable {
            let callParams: CallParams
            let block: RequestBlock

            public func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(callParams)
                try container.encode(block)
            }
        }

        public struct CallParams: Encodable, Equatable {
            public let from: Address?
            public let to: Address
            public let gas: BigUInt?
            public let gasPrice: BigUInt?
            public let value: BigUInt?
            public let data: [UInt8]?

            public init(
                from: Address? = nil,
                to: Address,
                gas: BigUInt? = nil,
                gasPrice: BigUInt? = nil,
                value: BigUInt? = nil,
                data: [UInt8]? = nil
            ) {
                self.from = from
                self.to = to
                self.gas = gas
                self.gasPrice = gasPrice
                self.value = value
                self.data = data
            }

            private enum CodingKeys: String, CodingKey {
                case from
                case to
                case gas
                case gasPrice
                case value
                case data
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                if let from = from {
                    try container.encode(from.hexString, forKey: .from)
                }

                try container.encode(to.hexString, forKey: .to)

                if let gas = gas {
                    try container.encode(gas.toRequestValue(), forKey: .gas)
                }

                if let gasPrice = gasPrice {
                    try container.encode(gasPrice.toRequestValue(), forKey: .gasPrice)
                }

                if let value = value {
                    try container.encode(value.toRequestValue(), forKey: .value)
                }

                if let data = data {
                    try container.encode("0x" + data.toHexString(), forKey: .data)
                }
            }
        }

        public let method = "eth_call"
        public let parameters: Parameters

        public init(
            params: CallParams,
            block: RequestBlock = .latest
        ) {
            self.parameters = Parameters(callParams: params, block: block)
        }
    }

    public struct SendRawTransaction: JSONRPCRequest, Equatable {
        public typealias Response = String

        public struct Parameters: Encodable, Equatable {
            let data: Data

            public func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode("0x" + data.toHexString())
            }
        }

        public let method = "eth_sendRawTransaction"
        public let parameters: Parameters

        public init(
            data: Data
        ) {
            self.parameters = Parameters(data: data)
        }
    }
}
