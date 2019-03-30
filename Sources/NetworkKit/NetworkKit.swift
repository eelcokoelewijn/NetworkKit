import Foundation

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

    public func load<ResourceType>(resource: Resource<ResourceType>,
                                   completion: @escaping (Result<ResourceType, NetworkError>) -> Void) {
        send(request: resource.request) { (response) in
            guard response.data != nil else {
                if let error: Error = response.error {
                    completion(.failure(NetworkError.sendingFailed(error.localizedDescription)))
                } else {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            guard let result: ResourceType = resource.parse(response) else {
                completion(.failure(NetworkError.parseError))
                return
            }
            completion(.success(result))
        }
    }

    private func send(request: Request, completion: @escaping (Response) -> Void) {
        URLSession.shared.dataTask(with: request.build()) { (data, response, error) in
            let r: Response = Response(data: data, httpResponse: response as? HTTPURLResponse, error: error)
            completion(r)
        }.resume()
    }
}
