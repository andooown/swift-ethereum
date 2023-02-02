import BigInt

public struct Tuple1<A> {
    public let value0: A

    public init(value0: A) {
        self.value0 = value0
    }

    public func toTuple() -> (A) {
        (value0)
    }
}

extension Tuple1: ABIEncodable where A: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [value0]
        var tailOffset = values.reduce(into: 0) {
            guard let staticValue = $1 as? ABIEncodableStaticType else {
                $0 += 32
                return
            }
            $0 += staticValue.typeSize
        }

        var tailBytes = [UInt8]()
        for value in values {
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

extension Tuple1: ABIEncodableStaticType where A: ABIEncodableStaticType {
    public var typeSize: Int {
        value0.typeSize
    }
}

extension Tuple1: ABIDecodable where A: ABIDecodable {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let baseContainer = container.nestedContainer(maxSlots: nil, bindsIndex: false)

        if A.self is ABIDecodableStaticType.Type {
            value0 = try container.decode(A.self)
        } else {
            let offset0 = try container.decode(BigUInt.self)
            var container0 = baseContainer.advanced(by: Int(offset0 / 32))
            value0 = try container0.decode(A.self)
        }
    }
}

extension Tuple1: Equatable where A: Equatable {}
extension Tuple1: Hashable where A: Hashable {}
