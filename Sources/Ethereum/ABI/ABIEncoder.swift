public protocol ABIEncoder {
    func container() -> ABIEncodingContainer

    func encodeImmediately<T>(_ value: T) throws -> [UInt8] where T: ABIEncodable
}

public enum ABIEncodingError: Error {
    public struct Context {
        public let debugDescription: String

        public init(debugDescription: String) {
            self.debugDescription = debugDescription
        }
    }

    case incompatibleToEncode(Context)
}

public protocol ABIEncodingContainer {
    mutating func encode<T>(_ value: T) throws where T: ABIEncodable
    mutating func encode<S>(bytes: S) throws where S: Sequence, S.Element == UInt8
}
