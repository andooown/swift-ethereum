import BigInt

public protocol ABIEncodable {
    func encode(to encoder: ABIEncoder) throws
}

public protocol ABIEncodableStaticType: ABIEncodable {
    /// in bytes length
    var typeSize: Int { get }
}

extension BigUInt: ABIEncodableStaticType {
    public var typeSize: Int {
        32
    }

    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let bytes = serialize().bytes.paddedLeft(to: 32, with: 0).suffix(32)
        try container.encode(bytes: bytes)
    }
}

extension BigInt: ABIEncodableStaticType {
    public var typeSize: Int {
        32
    }

    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        switch sign {
        case .plus:
            let bytes = serialize().bytes.paddedLeft(to: 32, with: 0).suffix(32)
            try container.encode(bytes: bytes)

        case .minus:
            let complement = ~magnitude + 1
            let bytes = complement.serialize().bytes.paddedLeft(to: 32, with: 0xFF).suffix(32)
            try container.encode(bytes: bytes)
        }
    }
}

extension Bool: ABIEncodableStaticType {
    public var typeSize: Int {
        32
    }

    public func encode(to encoder: ABIEncoder) throws {
        try BigUInt(self ? 1 : 0).encode(to: encoder)
    }
}

extension String: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        guard let bytes = data(using: .utf8)?.bytes else {
            throw ABIEncodingError.incompatibleToEncode(
                .init(debugDescription: "Can't get UTF8 bytes from String."))
        }

        try container.encode(BigUInt(bytes.count))

        let padded =
            bytes.count % 32 == 0
            ? bytes : bytes + Array(repeating: 0, count: 32 - bytes.count % 32)
        try container.encode(bytes: padded)
    }
}

extension Array: ABIEncodable where Element: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()
        try container.encode(BigUInt(count))

        var tailOffset = reduce(into: 0) {
            guard let staticValue = $1 as? ABIEncodableStaticType else {
                $0 += 32
                return
            }
            $0 += staticValue.typeSize
        }

        var tailBytes = [UInt8]()
        for value in self {
            if value is ABIEncodableStaticType {
                try container.encode(value)
            } else {
                try container.encode(BigUInt(tailOffset))

                let encoded = try encoder.encodeImmediately(value)
                tailOffset += encoded.count
                tailBytes.append(contentsOf: encoded)
            }
        }

        if !tailBytes.isEmpty {
            try container.encode(bytes: tailBytes)
        }
    }
}
