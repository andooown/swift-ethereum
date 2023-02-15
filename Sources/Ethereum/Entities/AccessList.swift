import Foundation

public struct AccessList: RLPEncodable {
    public struct Element: RLPEncodable {
        public let address: Address
        public let storageKeys: [[UInt8]]

        public init(
            address: Address,
            storageKeys: [[UInt8]]
        ) {
            self.address = address
            self.storageKeys = storageKeys
        }

        public func encodeToRLP() throws -> Data {
            try [
                AnyRLPEncodable(address),
                AnyRLPEncodable(storageKeys.map { Data($0) }),
            ].encodeToRLP()
        }
    }

    public let list: [Element]

    public init(_ list: [Element] = []) {
        self.list = list
    }

    public func encodeToRLP() throws -> Data {
        try list.encodeToRLP()
    }
}
