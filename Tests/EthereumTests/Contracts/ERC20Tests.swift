import XCTest

@testable import Ethereum

final class ERC20Tests: XCTestCase {
    private let address = Address()
    private var provider: JSONRPCProviderMock!
    private var contract: ERC20!

    override func setUp() async throws {
        provider = JSONRPCProviderMock()
        contract = ERC20(contract: address, provider: provider)
    }

    func testName() async throws {
        let response = [
            "0000000000000000000000000000000000000000000000000000000000000020",
            "0000000000000000000000000000000000000000000000000000000000000003",
            "4142430000000000000000000000000000000000000000000000000000000000",
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let actual = try await contract.name()
        XCTAssertEqual(actual, "ABC")

        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "06fdde03")
                    )
                )
            ]
        )
    }

    func testSymbol() async throws {
        let response = [
            "0000000000000000000000000000000000000000000000000000000000000020",
            "0000000000000000000000000000000000000000000000000000000000000003",
            "4142430000000000000000000000000000000000000000000000000000000000",
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let actual = try await contract.symbol()
        XCTAssertEqual(actual, "ABC")

        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "95d89b41")
                    )
                )
            ]
        )
    }

    func testDecimals() async throws {
        let response = [
            "000000000000000000000000000000000000000000000000000000000000007B"
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let actual = try await contract.decimals()
        XCTAssertEqual(actual, 123)

        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "313ce567")
                    )
                )
            ]
        )
    }

    func testTotalSupply() async throws {
        let response = [
            "000000000000000000000000000000000000000000000000000000000000007B"
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let actual = try await contract.totalSupply()
        XCTAssertEqual(actual, 123)

        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "18160ddd")
                    )
                )
            ]
        )
    }

    func testBalanceOf() async throws {
        let response = [
            "000000000000000000000000000000000000000000000000000000000000007B"
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let owner = Address(hexString: "0x0000000000000000000000000000000000000001")
        let actual = try await contract.balanceOf(owner: owner)
        XCTAssertEqual(actual, 123)

        let paramsData = try ABIDataEncoder().encode(Tuple1(owner))
        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "70a08231") + paramsData
                    )
                )
            ]
        )
    }

    func testAllowance() async throws {
        let response = [
            "000000000000000000000000000000000000000000000000000000000000007B"
        ].joined()
        provider.register(for: Eth.Call.self, responses: .success("0x" + response))

        let owner = Address(hexString: "0x0000000000000000000000000000000000000001")
        let spender = Address(hexString: "0x0000000000000000000000000000000000000002")
        let actual = try await contract.allowance(owner: owner, spender: spender)
        XCTAssertEqual(actual, 123)

        let paramsData = try ABIDataEncoder().encode(Tuple2(owner, spender))
        XCTAssertEqual(
            provider.requests(for: Eth.Call.self),
            [
                Eth.Call(
                    params: .init(
                        to: address,
                        data: .init(hex: "dd62ed3e") + paramsData
                    )
                )
            ]
        )
    }
}
