//
//  HashTests.swift
//
//
//  Created by Yoshikazu Ando on 2023/02/15.
//

import XCTest

@testable import Ethereum

final class HashTests: XCTestCase {
    func testInit() throws {
        XCTAssertEqual(Hash().rawValue, Array(repeating: 0, count: Hash.length))
    }

    func testInitWithBytes() throws {
        XCTAssertEqual(Hash(bytes: []).rawValue, Array(repeating: 0, count: Hash.length))
        XCTAssertEqual(
            Hash(bytes: [1, 2, 3]).rawValue,
            Array(repeating: 0, count: Hash.length - 3) + [1, 2, 3]
        )
        XCTAssertEqual(
            Hash(bytes: (0..<60).map(UInt8.init)).rawValue,
            (28..<60).map(UInt8.init)
        )
    }

    func testInitWithHexString() throws {
        XCTAssertEqual(Hash(hexString: ""), Hash())
        XCTAssertEqual(Hash(hexString: "0x"), Hash())
        XCTAssertEqual(Hash(hexString: "1"), Hash(bytes: [0x1]))
        XCTAssertEqual(Hash(hexString: "0x1"), Hash(bytes: [0x1]))
        XCTAssertEqual(Hash(hexString: "12"), Hash(bytes: [0x12]))
        XCTAssertEqual(Hash(hexString: "0x12"), Hash(bytes: [0x12]))
        XCTAssertEqual(Hash(hexString: "1234"), Hash(bytes: [0x12, 0x34]))
        XCTAssertEqual(
            Hash(hexString: "0xdee2a9b0881fbcaa48414ae89fb18c4efea3579ecf80750fc94c7a444a190abf"),
            Hash(bytes: [
                0xde, 0xe2, 0xa9, 0xb0, 0x88, 0x1f, 0xbc, 0xaa, 0x48, 0x41, 0x4a, 0xe8, 0x9f, 0xb1,
                0x8c, 0x4e, 0xfe, 0xa3, 0x57, 0x9e, 0xcf, 0x80, 0x75, 0x0f, 0xc9, 0x4c, 0x7a, 0x44,
                0x4a, 0x19, 0x0a, 0xbf,
            ])
        )
        XCTAssertEqual(
            Hash(
                hexString: (0..<60).reduce(into: "") { $0.append(String(format: "%02x", $1)) }
            ),
            Hash(bytes: (28..<60).map(UInt8.init))
        )
        XCTAssertEqual(Hash(hexString: "invalid string"), Hash())
    }

    func testTryParse() throws {
        XCTAssertEqual(try Hash.tryParse(hexString: "0x1"), Hash(hexString: "0x1"))
        XCTAssertThrowsError(try Hash.tryParse(hexString: "invalid string")) {
            XCTAssertEqual($0 as? Hash.TryParseError, .malformedInput)
        }
    }
}
