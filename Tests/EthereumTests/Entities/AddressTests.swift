import XCTest

@testable import Ethereum

final class AddressTests: XCTestCase {
    func testInit() throws {
        XCTContext.runActivity(named: "init()") { _ in
            XCTAssertEqual(Address().rawValue, Array(repeating: 0, count: Address.length))
        }

        XCTContext.runActivity(named: "init(bytes:)") { _ in
            XCTAssertEqual(Address(bytes: []).rawValue, Array(repeating: 0, count: Address.length))
            XCTAssertEqual(
                Address(bytes: [1, 2, 3]).rawValue,
                Array(repeating: 0, count: Address.length - 3) + [1, 2, 3]
            )
            XCTAssertEqual(
                Address(bytes: (0..<30).map(UInt8.init)).rawValue,
                (10..<30).map(UInt8.init)
            )
        }

        XCTContext.runActivity(named: "init(hexString:)") { _ in
            XCTAssertEqual(Address(hexString: ""), Address())
            XCTAssertEqual(Address(hexString: "0x"), Address())
            XCTAssertEqual(Address(hexString: "1"), Address(bytes: [0x1]))
            XCTAssertEqual(Address(hexString: "0x1"), Address(bytes: [0x1]))
            XCTAssertEqual(Address(hexString: "12"), Address(bytes: [0x12]))
            XCTAssertEqual(Address(hexString: "0x12"), Address(bytes: [0x12]))
            XCTAssertEqual(Address(hexString: "1234"), Address(bytes: [0x12, 0x34]))
            XCTAssertEqual(
                Address(hexString: "0xB9084d9c8A70b8Ecd2b6878ceF735F11b060DE32"),
                Address(bytes: [
                    0xB9, 0x08, 0x4d, 0x9c, 0x8A, 0x70, 0xb8, 0xEc, 0xd2, 0xb6, 0x87, 0x8c, 0xeF,
                    0x73, 0x5F, 0x11, 0xb0, 0x60, 0xDE, 0x32,
                ])
            )
            XCTAssertEqual(
                Address(
                    hexString: (0..<30).reduce(into: "") { $0.append(String(format: "%02x", $1)) }
                ),
                Address(bytes: (10..<30).map(UInt8.init))
            )
            XCTAssertEqual(Address(hexString: "invalid string"), Address())
        }
    }

    func testTryParse() throws {
        XCTAssertEqual(try Address.tryParse(hexString: "0x1"), Address(hexString: "0x1"))
        XCTAssertThrowsError(try Address.tryParse(hexString: "invalid string")) {
            XCTAssertEqual($0 as? Address.TryParseError, .malformedInput)
        }
    }

    func testHexString() throws {
        // EIP55
        // https://eips.ethereum.org/EIPS/eip-55#test-cases
        let cases = [
            // All caps
            ("0x52908400098527886E0F7030069857D2E4169EE7", #line),
            ("0x8617E340B3D01FA5F11F306F4090FD50E238070D", #line),
            // All Lower
            ("0xde709f2102306220921060314715629080e2fb77", #line),
            ("0x27b1fdb04752bbc536007a920d24acb045561c26", #line),
            // Normal
            ("0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed", #line),
            ("0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359", #line),
            ("0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB", #line),
            ("0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb", #line),
        ]
        for (c, line) in cases {
            let a = Address(hexString: c)
            XCTAssertEqual(a.hexString, c, line: UInt(line))
        }
    }
}
