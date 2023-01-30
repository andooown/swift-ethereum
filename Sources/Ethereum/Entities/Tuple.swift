import BigInt

public struct Tuple1<A>: ABIDecodable where A: ABIDecodable {
    public let value0: A

    public init(value0: A) {
        self.value0 = value0
    }

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

    public func toTuple() -> (A) {
        (value0)
    }
}

extension Tuple1: Equatable where A: Equatable {}
extension Tuple1: Hashable where A: Hashable {}
