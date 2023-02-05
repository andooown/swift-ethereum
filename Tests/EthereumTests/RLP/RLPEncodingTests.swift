import BigInt
import XCTest

@testable import Ethereum

final class RLPEncodingTests: XCTestCase {
    func testRLPEncoding() throws {
        // https://ethereum.org/ja/developers/docs/data-structures-and-encoding/rlp/#examples

        // the string "dog" = [ 0x83, 'd', 'o', 'g' ]
        XCTAssertEqual(
            try "dog".encodeToRLP().toHexString(),
            "83646f67"
        )
        // the list [ "cat", "dog" ] = [ 0xc8, 0x83, 'c', 'a', 't', 0x83, 'd', 'o', 'g' ]
        XCTAssertEqual(
            try ["cat", "dog"].encodeToRLP().toHexString(),
            "c88363617483646f67"
        )
        // the empty string ('null') = [ 0x80 ]
        XCTAssertEqual(
            try "".encodeToRLP().toHexString(),
            "80"
        )
        // the empty list = [ 0xc0 ]
        XCTAssertEqual(
            try [String]().encodeToRLP().toHexString(),
            "c0"
        )
        // the integer 0 = [ 0x80 ]
        XCTAssertEqual(
            try 0.encodeToRLP().toHexString(),
            "00"
        )
        // the encoded integer 0 ('\x00') = [ 0x00 ]
        XCTAssertEqual(
            try Data(hex: "0x00").encodeToRLP().toHexString(),
            "00"
        )
        // the encoded integer 15 ('\x0f') = [ 0x0f ]
        XCTAssertEqual(
            try 15.encodeToRLP().toHexString(),
            "0f"
        )
        XCTAssertEqual(
            try Data(hex: "0x0f").encodeToRLP().toHexString(),
            "0f"
        )
        // the encoded integer 1024 ('\x04\x00') = [ 0x82, 0x04, 0x00 ]
        XCTAssertEqual(
            try 1024.encodeToRLP().toHexString(),
            "820400"
        )
        XCTAssertEqual(
            try Data(hex: "0x0400").encodeToRLP().toHexString(),
            "820400"
        )
        // the set theoretical representation of three, [ [], [[]], [ [], [[]] ] ] = [ 0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0 ]
        XCTAssertEqual(
            try RLPNestedList.nested([
                .item([String]()),
                .nested([
                    .item([String]())
                ]),
                .nested([
                    .item([String]()),
                    .nested([
                        .item([String]())
                    ]),
                ]),
            ]).encodeToRLP().toHexString(),
            "c7c0c1c0c3c0c1c0"
        )
        // the string "Lorem ipsum dolor sit amet, consectetur adipisicing elit" = [ 0xb8, 0x38, 'L', 'o', 'r', 'e', 'm', ' ', ... , 'e', 'l', 'i', 't' ]
        XCTAssertEqual(
            try "Lorem ipsum dolor sit amet, consectetur adipisicing elit".encodeToRLP()
                .toHexString(),
            "b8384c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e7365637465747572206164697069736963696e6720656c6974"
        )
    }
}

private extension RLPEncodingTests {
    enum RLPNestedList: RLPEncodable {
        case nested([RLPNestedList])
        case item(RLPEncodable)

        func encodeToRLP() throws -> Data {
            switch self {
            case .nested(let nested):
                return try nested.encodeToRLP()

            case .item(let item):
                return try item.encodeToRLP()
            }
        }
    }
}
