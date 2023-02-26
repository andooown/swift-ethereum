public class JSONRPCProviderMock: JSONRPCProviderProtocol {
    public enum MockError: Error {
        case noResponses
        case unableToCast
    }

    // apple/swift-format doesn't support `any` keyword at the moment.
    // public private(set) var requests = [any JSONRPCRequest]()
    public private(set) var requests = [Any]()
    public private(set) var responses = [ObjectIdentifier: [Result<Any, Error>]]()

    public init() {}

    public func send<R>(_ request: R) async throws -> R.Response where R: JSONRPCRequest {
        self.requests.append(request)

        let key = ObjectIdentifier(R.self)
        guard let responses = self.responses[key],
            let response = responses.first
        else {
            throw MockError.noResponses
        }

        self.responses[key]?.removeFirst()

        switch response {
        case .success(let value):
            if let rpcResponse = value as? R.Response {
                return rpcResponse
            } else {
                throw MockError.unableToCast
            }

        case .failure(let error):
            throw error
        }
    }

    public func register<R>(
        for requestType: R.Type,
        responses: Result<R.Response, Error>...
    ) where R: JSONRPCRequest {
        let key = ObjectIdentifier(R.self)
        if !self.responses.keys.contains(key) {
            self.responses[key] = []
        }

        self.responses[key]?.append(contentsOf: responses.map { $0.map { $0 as Any } })
    }

    public func requests<R>(for requestType: R.Type) -> [R] {
        requests.compactMap { $0 as? R }
    }
}
