import Foundation

public struct AnyRLPEncodable: RLPEncodable {
    private let value: RLPEncodable

    public init(_ value: RLPEncodable) {
        self.value = value
    }

    public func encodeToRLP() throws -> Data {
        try value.encodeToRLP()
    }
}
