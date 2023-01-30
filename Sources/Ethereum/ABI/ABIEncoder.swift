public protocol ABIEncoder {
    func container() -> ABIEncodingContainer
}

public enum ABIEncodingError: Error {
    public struct Context {
        public let debugDescription: String

        public init(debugDescription: String) {
            self.debugDescription = debugDescription
        }
    }
}

public protocol ABIEncodingContainer {
    mutating func encode<T>(_ value: T) throws where T: ABIEncodable
    mutating func encode<S>(bytes: S) throws where S: Sequence, S.Element == UInt8
}
