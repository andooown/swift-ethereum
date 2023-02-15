import BigInt

// Tuple1

public struct Tuple1<T0> {

    public let value0: T0

    public init(
        value0: T0
    ) {
        self.value0 = value0
    }

    public func toTuple() -> (T0) {
        (value0)
    }
}

extension Tuple1: ABIEncodable where T0: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0
        ]
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

extension Tuple1: ABIEncodableStaticType where T0: ABIEncodableStaticType {
    public var typeSize: Int {
        value0.typeSize
    }
}

extension Tuple1: ABIDecodable where T0: ABIDecodable {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let baseContainer = container.nestedContainer(maxSlots: nil, bindsIndex: false)

        if T0.self is ABIDecodableStaticType.Type {
            value0 = try container.decode(T0.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value0 = try tailContainer.decode(T0.self)
        }

    }
}

extension Tuple1: Equatable where T0: Equatable {}
extension Tuple1: Hashable where T0: Hashable {}

// Tuple2

public struct Tuple2<T0, T1> {

    public let value0: T0
    public let value1: T1

    public init(
        value0: T0,
        value1: T1
    ) {
        self.value0 = value0
        self.value1 = value1
    }

    public func toTuple() -> (T0, T1) {
        (
            value0,
            value1
        )
    }
}

extension Tuple2: ABIEncodable where T0: ABIEncodable, T1: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
        ]
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

extension Tuple2: ABIEncodableStaticType
where T0: ABIEncodableStaticType, T1: ABIEncodableStaticType {
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
    }
}

extension Tuple2: ABIDecodable where T0: ABIDecodable, T1: ABIDecodable {
    public init(from decoder: ABIDecoder) throws {
        var container = decoder.container(maxSlots: nil)
        let baseContainer = container.nestedContainer(maxSlots: nil, bindsIndex: false)

        if T0.self is ABIDecodableStaticType.Type {
            value0 = try container.decode(T0.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value0 = try tailContainer.decode(T0.self)
        }

        if T1.self is ABIDecodableStaticType.Type {
            value1 = try container.decode(T1.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value1 = try tailContainer.decode(T1.self)
        }

    }
}

extension Tuple2: Equatable where T0: Equatable, T1: Equatable {}
extension Tuple2: Hashable where T0: Hashable, T1: Hashable {}
