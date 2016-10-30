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
        send(request: resource.request) { (data, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(resource.parse(data), nil)            
        }
    }
    
    private func send(request: Request, completion: (@escaping (Data?, NetworkError?) -> Void)) {
        URLSession.shared.dataTask(with: request.buildURLRequest()) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(nil, .sendingFailed(error.localizedDescription))
                } else {
                    completion(nil, .unknown)
                }
                return
            }
            completion(data, nil)
        }.resume()
    }    
}
