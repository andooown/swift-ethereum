import Foundation

public struct ABIDataEncoder {
    public init() {}

    public func encode<T>(_ value: T) throws -> Data where T: ABIEncodable {
        let encoder = ABIDataEncoderImpl()
        try value.encode(to: encoder)
        return encoder.storage.data
    }
}

private final class ABIDataEncoderStorage {
    var data = Data()
}

private struct ABIDataEncoderImpl: ABIEncoder {
    var storage = ABIDataEncoderStorage()

    func container() -> ABIEncodingContainer {
        return ABIDataEncodingContainer(encoder: self)
    }
}

private struct ABIDataEncodingContainer: ABIEncodingContainer {
    let encoder: ABIDataEncoderImpl

    func encode<T>(_ value: T) throws where T: ABIEncodable {
        try value.encode(to: encoder)
    }

    func encode<S>(bytes: S) throws where S: Sequence, S.Element == UInt8 {
        encoder.storage.data.append(contentsOf: bytes)
    }
}
