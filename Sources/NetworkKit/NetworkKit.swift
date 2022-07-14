import Foundation
#if os(Linux)
/// Ref: https://docs.swift.org/swift-book/ReferenceManual/Statements.html#ID538
import FoundationNetworking
#endif

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public typealias JSONDictionary = [String: AnyObject]

public enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

public enum NetworkError: Error {
    case sendingFailed(String)
    case unknown
    case parseError
}

public struct NetworkKit {

    public init() { }

    public func load<ResourceType>(resource: Resource<ResourceType>) async throws -> ResourceType {
        let response = try await send(request: resource.request)
        guard let result: ResourceType = resource.parse(response) else {
            throw NetworkError.parseError
        }
        return result
    }

    @available(*, renamed: "load()")
    public func load<ResourceType>(resource: Resource<ResourceType>, completion: @escaping (Result<ResourceType, NetworkError>) -> Void) {
        Task {
            do {
                let result:ResourceType = try await load(resource: resource)
                completion(.success(result))
            } catch let error {
                completion(.failure(NetworkError.sendingFailed(error.localizedDescription)))
            }
        }
    }

    private func send(request: URLRequest) async throws -> Response {
        let (data, urlResponse) = try await URLSession.shared.asyncData(for: request);
        let response: Response = Response(data: data, httpResponse: urlResponse as? HTTPURLResponse,error: nil)
        return response
    }
}
