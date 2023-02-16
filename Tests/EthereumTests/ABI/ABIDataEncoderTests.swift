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

    func testEncodeString() throws {
        XCTAssertEqual(
            try ABIDataEncoder().encode("dave").toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000004",
                "6461766500000000000000000000000000000000000000000000000000000000",
            ].joined()
        )
    }

    func testEncodeTuple() throws {
        // Tuple1 - Static
        XCTAssertEqual(
            try ABIDataEncoder().encode(Tuple1(BigUInt(1))).toHexString(),
            "0000000000000000000000000000000000000000000000000000000000000001"
        )
        // Tuple1 - Dynamic
        XCTAssertEqual(
            try ABIDataEncoder().encode(Tuple1("dave")).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000020",
                "0000000000000000000000000000000000000000000000000000000000000004",
                "6461766500000000000000000000000000000000000000000000000000000000",
            ].joined()
        )

        // Tuple2 - Static
        XCTAssertEqual(
            try ABIDataEncoder().encode(Tuple2(BigUInt(1), BigUInt(2))).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000001",
                "0000000000000000000000000000000000000000000000000000000000000002",
            ].joined()
        )
        // Tuple2 - Dynamic & Static
        XCTAssertEqual(
            try ABIDataEncoder().encode(Tuple2("dave", BigUInt(1))).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000040",
                "0000000000000000000000000000000000000000000000000000000000000001",
                "0000000000000000000000000000000000000000000000000000000000000004",
                "6461766500000000000000000000000000000000000000000000000000000000",
            ].joined()
        )
        // Tuple2 - Dynamic
        XCTAssertEqual(
            try ABIDataEncoder().encode(Tuple2("dave", "apple")).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000040",
                "0000000000000000000000000000000000000000000000000000000000000080",
                "0000000000000000000000000000000000000000000000000000000000000004",
                "6461766500000000000000000000000000000000000000000000000000000000",
                "0000000000000000000000000000000000000000000000000000000000000005",
                "6170706c65000000000000000000000000000000000000000000000000000000",
            ].joined()
        )
    }

    func testEncodeArray() throws {
        // Static
        XCTAssertEqual(
            try ABIDataEncoder().encode([BigUInt(1), BigUInt(2), BigUInt(3)]).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000003",
                "0000000000000000000000000000000000000000000000000000000000000001",
                "0000000000000000000000000000000000000000000000000000000000000002",
                "0000000000000000000000000000000000000000000000000000000000000003",
            ].joined()
        )
        // Dynamic
        XCTAssertEqual(
            try ABIDataEncoder().encode(["apple", "book", "cat"]).toHexString(),
            [
                "0000000000000000000000000000000000000000000000000000000000000003",
                "0000000000000000000000000000000000000000000000000000000000000060",
                "00000000000000000000000000000000000000000000000000000000000000a0",
                "00000000000000000000000000000000000000000000000000000000000000e0",
                "0000000000000000000000000000000000000000000000000000000000000005",
                "6170706c65000000000000000000000000000000000000000000000000000000",
                "0000000000000000000000000000000000000000000000000000000000000004",
                "626f6f6b00000000000000000000000000000000000000000000000000000000",
                "0000000000000000000000000000000000000000000000000000000000000003",
                "6361740000000000000000000000000000000000000000000000000000000000",
            ].joined()
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
