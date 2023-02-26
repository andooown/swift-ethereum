import BigInt
import XCTest

@testable import Ethereum

final class ERC20Tests: XCTestCase {
    private let address = Address()
    private var provider: JSONRPCProviderMock!
    private var contract: ERC20!

    private let testKey = "0x6cca12f7750e2c75eea903765a0ac8a127e2ae15e1059bb7a693bc4f007cd422"

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

    func testTransfer() async throws {
        let response = [
            "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF"
        ].joined()
        provider.register(for: Eth.SendRawTransaction.self, responses: .success("0x" + response))

        let to = Address(hexString: "0x0000000000000000000000000000000000000001")
        let value = BigUInt(123)
        let options = try makeTransactionOpts()
        let actual = try await contract.transfer(to: to, value: value, options: options)
        XCTAssertEqual(
            actual,
            .init(hexString: "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF")
        )

        XCTAssertEqual(
            provider.requests(for: Eth.SendRawTransaction.self),
            [
                Eth.SendRawTransaction(
                    data: .init(
                        hex: [
                            "f8a280010294000000000000000000000000000000000000000080b844a9059c",
                            "bb00000000000000000000000000000000000000000000000000000000000000",
                            "0100000000000000000000000000000000000000000000000000000000000000",
                            "7b25a04d861285b3ba8a3be6b7628249375b02087dc2caf45985c0d45e307fbe",
                            "7185cea017e6c012c061f2d21bd58f55cafcdae791945e49123e0e8fce142f69",
                            "26e7f6a1",
                        ].joined()
                    )
                )
            ]
        )
    }

    func testTransferFrom() async throws {
        let response = [
            "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF"
        ].joined()
        provider.register(for: Eth.SendRawTransaction.self, responses: .success("0x" + response))

        let from = Address(hexString: "0x0000000000000000000000000000000000000001")
        let to = Address(hexString: "0x0000000000000000000000000000000000000002")
        let value = BigUInt(123)
        let options = try makeTransactionOpts()
        let actual = try await contract.transferFrom(
            from: from, to: to, value: value, options: options)
        XCTAssertEqual(
            actual,
            .init(hexString: "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF")
        )

        XCTAssertEqual(
            provider.requests(for: Eth.SendRawTransaction.self),
            [
                Eth.SendRawTransaction(
                    data: .init(
                        hex: [
                            "f8c280010294000000000000000000000000000000000000000080b86423b872",
                            "dd00000000000000000000000000000000000000000000000000000000000000",
                            "0100000000000000000000000000000000000000000000000000000000000000",
                            "0200000000000000000000000000000000000000000000000000000000000000",
                            "7b25a0152032276fb00cc45df0bbe7b988aa2716b638651966f3477b0d10f0c5",
                            "c24796a01b3d2bbb4aff06bfa0c475752269e0b2d5a6b40e75aa6b031a004c78",
                            "739362bd",
                        ].joined()
                    )
                )
            ]
        )
    }

    func testApprove() async throws {
        let response = [
            "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF"
        ].joined()
        provider.register(for: Eth.SendRawTransaction.self, responses: .success("0x" + response))

        let spender = Address(hexString: "0x0000000000000000000000000000000000000001")
        let value = BigUInt(123)
        let options = try makeTransactionOpts()
        let actual = try await contract.approve(spender: spender, value: value, options: options)
        XCTAssertEqual(
            actual,
            .init(hexString: "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF")
        )

        XCTAssertEqual(
            provider.requests(for: Eth.SendRawTransaction.self),
            [
                Eth.SendRawTransaction(
                    data: .init(
                        hex: [
                            "f8a280010294000000000000000000000000000000000000000080b844095ea7",
                            "b300000000000000000000000000000000000000000000000000000000000000",
                            "0100000000000000000000000000000000000000000000000000000000000000",
                            "7b26a092e106596ec4662662ffce8d3d86fed37244da46c2ba8d9f6b9f835fdd",
                            "d965aaa06f8abf6dd763abed64695ce28102b759a3f270da273d0e81cb79db91",
                            "42fef175",
                        ].joined()
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

private extension ERC20Tests {
    func makeTransactionOpts() throws -> TransactionOptions {
        .init(
            nonce: 0,
            gasPrice: 1,
            gas: 2,
            signer: LondonSigner(chainID: 1),
            privateKey: try PrivateKey(hexString: testKey)
        )
    }
}
