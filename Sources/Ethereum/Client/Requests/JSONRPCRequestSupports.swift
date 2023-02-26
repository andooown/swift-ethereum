import BigInt
import Foundation

public enum RequestBlock: Encodable, Equatable {
    case block(BigUInt)
    case earliest
    case latest
    case pending

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .block(let number):
            try container.encode(number.toRequestValue())

        case .earliest:
            try container.encode("earliest")

        case .latest:
            try container.encode("latest")

        case .pending:
            try container.encode("pending")
        }
    }
}

public extension BigUInt {
    func toRequestValue() -> String {
        if isZero {
            return "0x0"
        } else {
            return "0x" + serialize().toHexString()
        }
    }
}
