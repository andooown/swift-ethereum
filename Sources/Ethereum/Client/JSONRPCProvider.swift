import BigInt
import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

/// @mockable
public protocol JSONRPCProviderProtocol {
    func send<R: JSONRPCRequest>(_ request: R) async throws -> R.Response
}

public struct JSONRPCProvider: JSONRPCProviderProtocol {
    private let rpcURL: URL
    private let session: URLSession

    public init(
        rpcURL: URL,
        session: URLSession
    ) {
        self.rpcURL = rpcURL
        self.session = session
    }

    public enum Error: Swift.Error, LocalizedError {
        case errorResponse(code: Int, message: String)
        case invalidResponse(Data)

        public var errorDescription: String? {
            switch self {
            case .invalidResponse(let data):
                return ".invalidResponse(\(String(data: data, encoding: .utf8) ?? "<malformed>")"

            default:
                return "\(self)"
            }
        }
    }

    private struct Request<Parameters: Encodable>: Encodable {
        let jsonrpc: String
        let method: String
        let params: Parameters
        let id: Int
    }

    private struct Response<Result: Decodable>: Decodable {
        let id: Int
        let result: Result?
    }

    private struct ErrorResponse: Decodable {
        let id: Int
        let error: Details

        struct Details: Decodable {
            let code: Int
            let message: String
        }
    }

    public func send<R: JSONRPCRequest>(_ request: R) async throws -> R.Response {
        let rpcRequest = Request(
            jsonrpc: "2.0", method: request.method, params: request.parameters, id: 1)
        let body = try JSONEncoder().encode(rpcRequest)

        var urlRequest = URLRequest(url: rpcURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body

        let (data, _) = try await session.data(for: urlRequest)
        let rpcResponse = try JSONDecoder().decode(Response<R.Response>.self, from: data)
        guard let response = rpcResponse.result else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw Error.errorResponse(
                    code: errorResponse.error.code, message: errorResponse.error.message)
            } else {
                throw Error.invalidResponse(data)
            }
        }

        return response
    }
}
