import Foundation

public struct Hash: Hashable {
    enum TryParseError: Error {
        case malformedInput
    }

    public static let length = 32

    public let rawValue: [UInt8]

    public init() {
        self.init(bytes: [])
    }

    public init(bytes: [UInt8]) {
        self.rawValue = Array(bytes.suffix(Self.length)).paddedLeft(to: Self.length, with: 0)
    }

    public init(hexString: String) {
        self = (try? Hash.tryParse(hexString: hexString)) ?? Hash()
    }
}

public extension Hash {
    static func tryParse(hexString: String) throws -> Hash {
        let bytes = Array(hex: hexString)
        if hexString.count > 0 && bytes.count < 1 {
            throw TryParseError.malformedInput
        }

        return Hash(bytes: bytes)
    }

    var hexString: String {
        "0x" + rawValue.toHexString()
    }
}

extension Hash: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        try Data(rawValue).encodeToRLP()
    }
}
