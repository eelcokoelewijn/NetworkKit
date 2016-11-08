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
                     completion: @escaping ((ResourceType?, NetworkError?) -> Void))  {
        send(request: resource.request) { (response) in
            guard response.data != nil else {
                if let error = response.error {
                    completion(nil, .sendingFailed(error.localizedDescription))
                } else {
                    completion(nil, .unknown)
                }
                return
            }
            completion(resource.parse(response), nil)
        }
    }
    
    private func send(request: Request, completion: (@escaping (Response) -> Void)) {
        URLSession.shared.dataTask(with: request.buildURLRequest()) { (data, response, error) in
            let r = Response(data: data, httpResponse: response as? HTTPURLResponse, error: error)
            completion(r)
        }.resume()
    }
}
