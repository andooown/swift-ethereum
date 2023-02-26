import CryptoSwift
import Foundation

public enum ContactHelper {
    public static func functionSignature(selector: String) -> [UInt8] {
        Array(SHA3(variant: .keccak256).calculate(for: selector.bytes).prefix(4))
    }

    public static func makeTransaction<Parameter: ABIEncodable>(
        contract: Address,
        selector: String,
        parameter: Parameter,
        options: TransactionOptions
    ) throws -> RawTransaction {
        let signature = functionSignature(selector: selector)
        let encoded = try ABIDataEncoder().encode(parameter)
        let data = Data(signature) + encoded

        let rawTx: RawTransaction
        if let gasPrice = options.gasPrice {
            rawTx = LegacyTransaction(
                nonce: options.nonce,
                gasPrice: gasPrice,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else if let maxPriorityFeePerGas = options.maxPriorityFeePerGas,
            let maxFeePerGas = options.maxFeePerGas
        {
            rawTx = DynamicFeeTransaction(
                nonce: options.nonce,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                gas: options.gas,
                to: contract,
                value: options.value,
                data: data
            )
        } else {
            throw ContractError.invalidTransactionOptions(
                message: "Not found valid gas price option."
            )
        }

        return rawTx
    }
}
