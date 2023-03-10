import CryptoSwift
import Foundation

public struct Address: Hashable {
    enum TryParseError: Error {
        case malformedInput
    }

    public static let length = 20

    public let rawValue: [UInt8]

    public init() {
        self.init(bytes: [])
    }

    public init(bytes: [UInt8]) {
        self.rawValue = Array(bytes.suffix(Self.length)).paddedLeft(to: Self.length, with: 0)
    }

    public init(hexString: String) {
        self = (try? Address.tryParse(hexString: hexString)) ?? Address()
    }
}

public extension Address {
    static func tryParse(hexString: String) throws -> Address {
        let bytes = Array(hex: hexString)
        if hexString.count > 0 && bytes.count < 1 {
            throw TryParseError.malformedInput
        }

        return Address(bytes: bytes)
    }

    var hexString: String {
        var hex = rawHexString
        hex.removeFirst(2)

        let hash = SHA3(variant: .keccak256).calculate(for: hex.bytes).toHexString()

        var result = "0x"
        for (nibble, h) in zip(hex, hash) {
            if ("0"..."7").contains(h) {
                result.append(nibble)
            } else {
                result.append(nibble.uppercased())
            }
        }

        return result
    }
}

extension Address: ABIEncodableStaticType {
    public var typeSize: Int {
        32
    }

    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()
        try container.encode(bytes: rawValue.paddedLeft(to: 32, with: 0))
    }
}

extension Address: ABIDecodableStaticType {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let bytes = try container.decodeBytes(slots: 1)
        self.init(bytes: bytes)
    }
}

extension Address: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        try Data(rawValue).encodeToRLP()
    }
}

private extension Address {
    var rawHexString: String {
        "0x" + rawValue.toHexString()
    }
}
