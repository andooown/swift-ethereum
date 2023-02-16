import Foundation

public protocol JSONRPCRequest {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable

    var method: String { get }
    var parameters: Parameters { get }
}
