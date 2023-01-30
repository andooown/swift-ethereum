import XCTest

@testable import Ethereum

final class ABIDataEncoderTests: XCTestCase {
    func testEncodeAddress() throws {
        XCTAssertEqual(
            try ABIDataEncoder().encode(Address()).bytes,
            bytes(from: [
                "0x0000000000000000000000000000000000000000000000000000000000000000"
            ])
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(
                Address(hexString: "0xB9084d9c8A70b8Ecd2b6878ceF735F11b060DE32")
            ).bytes,
            bytes(from: [
                "0x000000000000000000000000B9084d9c8A70b8Ecd2b6878ceF735F11b060DE32"
            ])
        )
    }
}

private extension ABIDataEncoderTests {
    func bytes(from hexStrings: [String]) -> [UInt8] {
        hexStrings.reduce([]) {
            $0 + [UInt8](hex: $1)
        }
    }
}
