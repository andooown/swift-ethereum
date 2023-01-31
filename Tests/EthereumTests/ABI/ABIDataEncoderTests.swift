import BigInt
import XCTest

@testable import Ethereum

final class ABIDataEncoderTests: XCTestCase {
    func testEncodeBigUInt() throws {
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigUInt(0)).toHexString(),
            "0000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigUInt(123456)).toHexString(),
            "000000000000000000000000000000000000000000000000000000000001e240"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(
                BigUInt(
                    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!
            ).toHexString(),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        )
    }

    func testEncodeBigInt() throws {
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigInt(0)).toHexString(),
            "0000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigInt(1)).toHexString(),
            "0000000000000000000000000000000000000000000000000000000000000001"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigInt(-1)).toHexString(),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        )

        XCTAssertEqual(
            try ABIDataEncoder().encode(BigInt(123456)).toHexString(),
            "000000000000000000000000000000000000000000000000000000000001e240"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(BigInt(-123456)).toHexString(),
            "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1dc0"
        )

        XCTAssertEqual(
            try ABIDataEncoder().encode(
                BigInt(
                    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16)!
            ).toHexString(),
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        )
    }

    func testEncodeAddress() throws {
        XCTAssertEqual(
            try ABIDataEncoder().encode(Address()).toHexString(),
            "0000000000000000000000000000000000000000000000000000000000000000"
        )
        XCTAssertEqual(
            try ABIDataEncoder().encode(
                Address(hexString: "0xB9084d9c8A70b8Ecd2b6878ceF735F11b060DE32")
            ).toHexString(),
            "000000000000000000000000b9084d9c8a70b8ecd2b6878cef735f11b060de32"
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
