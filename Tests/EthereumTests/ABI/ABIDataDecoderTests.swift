import BigInt
import XCTest

@testable import Ethereum

final class ABIDataDecoderTests: XCTestCase {
    func testDecodeBigUInt() throws {
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigUInt.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000000"
                ])
            ),
            BigUInt(0)
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigUInt.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000123456"
                ])
            ),
            BigUInt(1_193_046)
        )
    }

    func testDecodeBigInt() throws {
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigInt.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000000"
                ])
            ),
            BigInt(0)
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigInt.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000001"
                ])
            ),
            BigInt(1)
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigInt.self,
                from: inputBytes(from: [
                    "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                ])
            ),
            BigInt(-1)
        )

        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigInt.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000123456"
                ])
            ),
            BigInt(1_193_046)
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                BigInt.self,
                from: inputBytes(from: [
                    "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff85"
                ])
            ),
            BigInt(-123)
        )
    }

    func testDecodeString() throws {
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                String.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000000"
                ])
            ),
            ""
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                String.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000004",
                    "0x6461766500000000000000000000000000000000000000000000000000000000",
                ])
            ),
            "dave"
        )
    }

    func testDecodeTuple() throws {
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                Tuple1<BigInt>.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000123456"
                ])
            ),
            Tuple1(1_193_046)
        )
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                Tuple1<String>.self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000020",
                    "0x0000000000000000000000000000000000000000000000000000000000000004",
                    "0x6461766500000000000000000000000000000000000000000000000000000000",
                ])
            ),
            Tuple1("dave")
        )
    }

    func testDecodeArray() throws {
        // Static
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                [BigUInt].self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000003",
                    "0x0000000000000000000000000000000000000000000000000000000000000001",
                    "0x0000000000000000000000000000000000000000000000000000000000000002",
                    "0x0000000000000000000000000000000000000000000000000000000000000003",
                ])
            ),
            [BigUInt(1), BigUInt(2), BigUInt(3)]
        )
        // Dynamic
        XCTAssertEqual(
            try ABIDataDecoder().decode(
                [String].self,
                from: inputBytes(from: [
                    "0x0000000000000000000000000000000000000000000000000000000000000003",
                    "0x0000000000000000000000000000000000000000000000000000000000000060",
                    "0x00000000000000000000000000000000000000000000000000000000000000a0",
                    "0x00000000000000000000000000000000000000000000000000000000000000e0",
                    "0x0000000000000000000000000000000000000000000000000000000000000005",
                    "0x6170706c65000000000000000000000000000000000000000000000000000000",
                    "0x0000000000000000000000000000000000000000000000000000000000000004",
                    "0x626f6f6b00000000000000000000000000000000000000000000000000000000",
                    "0x0000000000000000000000000000000000000000000000000000000000000003",
                    "0x6361740000000000000000000000000000000000000000000000000000000000",
                ])
            ),
            ["apple", "book", "cat"]
        )
    }
}

private extension ABIDataDecoderTests {
    func inputBytes(from hexStrings: [String]) -> [UInt8] {
        hexStrings.reduce([]) {
            $0 + [UInt8](hex: $1)
        }
    }
}
