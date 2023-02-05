import BigInt
import Foundation

public protocol RLPEncodable {
    func encodeToRLP() throws -> Data
}

public enum RLPEncodingError: Swift.Error {
    case incompatibleToEncode
}

extension UInt8: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        if self <= 0x7f {
            return Data([self])
        }

        return try Data([self]).encodeToRLP()
    }
}

extension Data: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        let bytes = bytes
        if bytes.count == 1 && bytes[0] <= 0x7f {
            return self
        }
        if bytes.count <= 55 {
            return [0x80 + UInt8(count)] + self
        }

        let countBytes = BigUInt(count).serialize().bytes
        return [0xb7 + UInt8(countBytes.count)] + countBytes + self
    }
}

extension String: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        guard let data = data(using: .utf8) else {
            throw RLPEncodingError.incompatibleToEncode
        }

        return try data.encodeToRLP()
    }
}

extension Array: RLPEncodable where Element: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        let bytes = try reduce(into: Data()) {
            $0.append(try $1.encodeToRLP())
        }
        if bytes.count <= 55 {
            return [0xc0 + UInt8(bytes.count)] + bytes
        }

        let countBytes = BigUInt(bytes.count).serialize().bytes
        return [0xf7 + UInt8(countBytes.count)] + countBytes + bytes
    }
}

extension Int: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        try BigInt(self).encodeToRLP()
    }
}

extension BigInt: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        let data: Data
        if isZero {
            data = Data([0x00])
        } else {
            let b = serialize().bytes
            let headZeros = b.firstIndex(where: { $0 != 0x00 }) ?? 0
            data = Data(b.dropFirst(headZeros))
        }

        return try data.encodeToRLP()
    }
}

extension BigUInt: RLPEncodable {
    public func encodeToRLP() throws -> Data {
        try BigInt(sign: .plus, magnitude: self).encodeToRLP()
    }
}
