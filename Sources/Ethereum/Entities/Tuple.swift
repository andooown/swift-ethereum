import BigInt

// Tuple1

public struct Tuple1<T0> {

    public let value0: T0

    public init(
        _ value0: T0
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
        _ value0: T0,
        _ value1: T1
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

// Tuple3

public struct Tuple3<T0, T1, T2> {

    public let value0: T0
    public let value1: T1
    public let value2: T2

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
    }

    public func toTuple() -> (T0, T1, T2) {
        (
            value0,
            value1,
            value2
        )
    }
}

extension Tuple3: ABIEncodable where T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
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

extension Tuple3: ABIEncodableStaticType
where T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType {
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
    }
}

extension Tuple3: ABIDecodable where T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable {
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

    }
}

extension Tuple3: Equatable where T0: Equatable, T1: Equatable, T2: Equatable {}
extension Tuple3: Hashable where T0: Hashable, T1: Hashable, T2: Hashable {}

// Tuple4

public struct Tuple4<T0, T1, T2, T3> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
    }

    public func toTuple() -> (T0, T1, T2, T3) {
        (
            value0,
            value1,
            value2,
            value3
        )
    }
}

extension Tuple4: ABIEncodable
where T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
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

extension Tuple4: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
    }
}

extension Tuple4: ABIDecodable
where T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable {
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

    }
}

extension Tuple4: Equatable where T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable {}
extension Tuple4: Hashable where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable {}

// Tuple5

public struct Tuple5<T0, T1, T2, T3, T4> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
    }

    public func toTuple() -> (T0, T1, T2, T3, T4) {
        (
            value0,
            value1,
            value2,
            value3,
            value4
        )
    }
}

extension Tuple5: ABIEncodable
where T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable {
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
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

extension Tuple5: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
    }
}

extension Tuple5: ABIDecodable
where T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable {
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

    }
}

extension Tuple5: Equatable
where T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable {}
extension Tuple5: Hashable
where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable {}

// Tuple6

public struct Tuple6<T0, T1, T2, T3, T4, T5> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4
    public let value5: T5

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4,
        _ value5: T5
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
    }

    public func toTuple() -> (T0, T1, T2, T3, T4, T5) {
        (
            value0,
            value1,
            value2,
            value3,
            value4,
            value5
        )
    }
}

extension Tuple6: ABIEncodable
where
    T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable,
    T5: ABIEncodable
{
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
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

extension Tuple6: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType, T5: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
            + value5.typeSize
    }
}

extension Tuple6: ABIDecodable
where
    T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable,
    T5: ABIDecodable
{
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

        if T5.self is ABIDecodableStaticType.Type {
            value5 = try container.decode(T5.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value5 = try tailContainer.decode(T5.self)
        }

    }
}

extension Tuple6: Equatable
where T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable {}
extension Tuple6: Hashable
where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable {}

// Tuple7

public struct Tuple7<T0, T1, T2, T3, T4, T5, T6> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4
    public let value5: T5
    public let value6: T6

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4,
        _ value5: T5,
        _ value6: T6
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
    }

    public func toTuple() -> (T0, T1, T2, T3, T4, T5, T6) {
        (
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6
        )
    }
}

extension Tuple7: ABIEncodable
where
    T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable,
    T5: ABIEncodable, T6: ABIEncodable
{
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
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

extension Tuple7: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType, T5: ABIEncodableStaticType,
    T6: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
            + value5.typeSize
            + value6.typeSize
    }
}

extension Tuple7: ABIDecodable
where
    T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable,
    T5: ABIDecodable, T6: ABIDecodable
{
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

        if T5.self is ABIDecodableStaticType.Type {
            value5 = try container.decode(T5.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value5 = try tailContainer.decode(T5.self)
        }

        if T6.self is ABIDecodableStaticType.Type {
            value6 = try container.decode(T6.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value6 = try tailContainer.decode(T6.self)
        }

    }
}

extension Tuple7: Equatable
where
    T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable,
    T6: Equatable
{}
extension Tuple7: Hashable
where
    T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable, T6: Hashable
{}

// Tuple8

public struct Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4
    public let value5: T5
    public let value6: T6
    public let value7: T7

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4,
        _ value5: T5,
        _ value6: T6,
        _ value7: T7
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
    }

    public func toTuple() -> (T0, T1, T2, T3, T4, T5, T6, T7) {
        (
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7
        )
    }
}

extension Tuple8: ABIEncodable
where
    T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable,
    T5: ABIEncodable, T6: ABIEncodable, T7: ABIEncodable
{
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7,
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

extension Tuple8: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType, T5: ABIEncodableStaticType,
    T6: ABIEncodableStaticType, T7: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
            + value5.typeSize
            + value6.typeSize
            + value7.typeSize
    }
}

extension Tuple8: ABIDecodable
where
    T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable,
    T5: ABIDecodable, T6: ABIDecodable, T7: ABIDecodable
{
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

        if T5.self is ABIDecodableStaticType.Type {
            value5 = try container.decode(T5.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value5 = try tailContainer.decode(T5.self)
        }

        if T6.self is ABIDecodableStaticType.Type {
            value6 = try container.decode(T6.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value6 = try tailContainer.decode(T6.self)
        }

        if T7.self is ABIDecodableStaticType.Type {
            value7 = try container.decode(T7.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value7 = try tailContainer.decode(T7.self)
        }

    }
}

extension Tuple8: Equatable
where
    T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable,
    T6: Equatable, T7: Equatable
{}
extension Tuple8: Hashable
where
    T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable,
    T6: Hashable, T7: Hashable
{}

// Tuple9

public struct Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4
    public let value5: T5
    public let value6: T6
    public let value7: T7
    public let value8: T8

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4,
        _ value5: T5,
        _ value6: T6,
        _ value7: T7,
        _ value8: T8
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = value8
    }

    public func toTuple() -> (T0, T1, T2, T3, T4, T5, T6, T7, T8) {
        (
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7,
            value8
        )
    }
}

extension Tuple9: ABIEncodable
where
    T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable,
    T5: ABIEncodable, T6: ABIEncodable, T7: ABIEncodable, T8: ABIEncodable
{
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7,
            value8,
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

extension Tuple9: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType, T5: ABIEncodableStaticType,
    T6: ABIEncodableStaticType, T7: ABIEncodableStaticType, T8: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
            + value5.typeSize
            + value6.typeSize
            + value7.typeSize
            + value8.typeSize
    }
}

extension Tuple9: ABIDecodable
where
    T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable,
    T5: ABIDecodable, T6: ABIDecodable, T7: ABIDecodable, T8: ABIDecodable
{
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

        if T5.self is ABIDecodableStaticType.Type {
            value5 = try container.decode(T5.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value5 = try tailContainer.decode(T5.self)
        }

        if T6.self is ABIDecodableStaticType.Type {
            value6 = try container.decode(T6.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value6 = try tailContainer.decode(T6.self)
        }

        if T7.self is ABIDecodableStaticType.Type {
            value7 = try container.decode(T7.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value7 = try tailContainer.decode(T7.self)
        }

        if T8.self is ABIDecodableStaticType.Type {
            value8 = try container.decode(T8.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value8 = try tailContainer.decode(T8.self)
        }

    }
}

extension Tuple9: Equatable
where
    T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable,
    T6: Equatable, T7: Equatable, T8: Equatable
{}
extension Tuple9: Hashable
where
    T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable,
    T6: Hashable, T7: Hashable, T8: Hashable
{}

// Tuple10

public struct Tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {

    public let value0: T0
    public let value1: T1
    public let value2: T2
    public let value3: T3
    public let value4: T4
    public let value5: T5
    public let value6: T6
    public let value7: T7
    public let value8: T8
    public let value9: T9

    public init(
        _ value0: T0,
        _ value1: T1,
        _ value2: T2,
        _ value3: T3,
        _ value4: T4,
        _ value5: T5,
        _ value6: T6,
        _ value7: T7,
        _ value8: T8,
        _ value9: T9
    ) {
        self.value0 = value0
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.value5 = value5
        self.value6 = value6
        self.value7 = value7
        self.value8 = value8
        self.value9 = value9
    }

    public func toTuple() -> (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9) {
        (
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7,
            value8,
            value9
        )
    }
}

extension Tuple10: ABIEncodable
where
    T0: ABIEncodable, T1: ABIEncodable, T2: ABIEncodable, T3: ABIEncodable, T4: ABIEncodable,
    T5: ABIEncodable, T6: ABIEncodable, T7: ABIEncodable, T8: ABIEncodable, T9: ABIEncodable
{
    public func encode(to encoder: ABIEncoder) throws {
        var container = encoder.container()

        let values: [ABIEncodable] = [
            value0,
            value1,
            value2,
            value3,
            value4,
            value5,
            value6,
            value7,
            value8,
            value9,
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

extension Tuple10: ABIEncodableStaticType
where
    T0: ABIEncodableStaticType, T1: ABIEncodableStaticType, T2: ABIEncodableStaticType,
    T3: ABIEncodableStaticType, T4: ABIEncodableStaticType, T5: ABIEncodableStaticType,
    T6: ABIEncodableStaticType, T7: ABIEncodableStaticType, T8: ABIEncodableStaticType,
    T9: ABIEncodableStaticType
{
    public var typeSize: Int {
        value0.typeSize
            + value1.typeSize
            + value2.typeSize
            + value3.typeSize
            + value4.typeSize
            + value5.typeSize
            + value6.typeSize
            + value7.typeSize
            + value8.typeSize
            + value9.typeSize
    }
}

extension Tuple10: ABIDecodable
where
    T0: ABIDecodable, T1: ABIDecodable, T2: ABIDecodable, T3: ABIDecodable, T4: ABIDecodable,
    T5: ABIDecodable, T6: ABIDecodable, T7: ABIDecodable, T8: ABIDecodable, T9: ABIDecodable
{
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

        if T2.self is ABIDecodableStaticType.Type {
            value2 = try container.decode(T2.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value2 = try tailContainer.decode(T2.self)
        }

        if T3.self is ABIDecodableStaticType.Type {
            value3 = try container.decode(T3.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value3 = try tailContainer.decode(T3.self)
        }

        if T4.self is ABIDecodableStaticType.Type {
            value4 = try container.decode(T4.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value4 = try tailContainer.decode(T4.self)
        }

        if T5.self is ABIDecodableStaticType.Type {
            value5 = try container.decode(T5.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value5 = try tailContainer.decode(T5.self)
        }

        if T6.self is ABIDecodableStaticType.Type {
            value6 = try container.decode(T6.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value6 = try tailContainer.decode(T6.self)
        }

        if T7.self is ABIDecodableStaticType.Type {
            value7 = try container.decode(T7.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value7 = try tailContainer.decode(T7.self)
        }

        if T8.self is ABIDecodableStaticType.Type {
            value8 = try container.decode(T8.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value8 = try tailContainer.decode(T8.self)
        }

        if T9.self is ABIDecodableStaticType.Type {
            value9 = try container.decode(T9.self)
        } else {
            let offset = try container.decode(BigUInt.self)
            var tailContainer = baseContainer.advanced(by: Int(offset / 32))
            value9 = try tailContainer.decode(T9.self)
        }

    }
}

extension Tuple10: Equatable
where
    T0: Equatable, T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable, T5: Equatable,
    T6: Equatable, T7: Equatable, T8: Equatable, T9: Equatable
{}
extension Tuple10: Hashable
where
    T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable, T5: Hashable,
    T6: Hashable, T7: Hashable, T8: Hashable, T9: Hashable
{}
