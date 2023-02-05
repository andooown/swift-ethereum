import BigInt

public protocol RLPEncodable {
    func encodeToRLP() throws -> [UInt8]
}

public enum RLPEncodingError: Swift.Error {
    case incompatibleToEncode
}

extension UInt8: RLPEncodable {
    public func encodeToRLP() throws -> [UInt8] {
        if self <= 0x7f {
            return [self]
        }

        return try [self].encodeToRLP()
    }
}

extension String: RLPEncodable {
    public func encodeToRLP() throws -> [UInt8] {
        guard let bytes = data(using: .utf8)?.bytes else {
            throw RLPEncodingError.incompatibleToEncode
        }

        return try bytes.encodeToRLP()
    }
}

extension Array: RLPEncodable where Element: RLPEncodable {
    public func encodeToRLP() throws -> [UInt8] {
        let bytes = try reduce(into: []) {
            $0.append(contentsOf: try $1.encodeToRLP())
        }
        if bytes.count <= 55 {
            return [0xc0 + UInt8(bytes.count)] + bytes
        }

        let countBytes = BigUInt(bytes.count).serialize().bytes
        return [0xf7 + UInt8(countBytes.count)] + countBytes + bytes
    }

    public func encodeToRLP() throws -> [UInt8] where Element == UInt8 {
        if count == 1 && self[0] <= 0x7f {
            return self
        }
        if count <= 55 {
            return [0x80 + UInt8(count)] + self
        }

        let countBytes = BigUInt(count).serialize().bytes
        return [0xb7 + UInt8(countBytes.count)] + countBytes + self
    }
}

extension Int: RLPEncodable {
    public func encodeToRLP() throws -> [UInt8] {
        try BigInt(self).encodeToRLP()
    }
}

extension BigInt: RLPEncodable {
    public func encodeToRLP() throws -> [UInt8] {
        let bytes: [UInt8]
        if isZero {
            bytes = [0x00]
        } else {
            let b = serialize().bytes
            let headZeros = b.firstIndex(where: { $0 != 0x00 }) ?? 0
            bytes = Array(b.dropFirst(headZeros))
        }

        return try bytes.encodeToRLP()
    }
}
