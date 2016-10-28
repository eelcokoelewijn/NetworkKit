import Foundation

public typealias JSONDictionary = [String: AnyObject]

public protocol JSONDecodable {
    init(json: JSONDictionary) throws
}

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

    public func load<Object: JSONDecodable>(resource: Resource, completion: @escaping ((Object?, NetworkError?) -> Void))  {
        send(request: resource.request) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            do {
                let result = try self.parseResponse(data: response)
                let newObject = try Object.init(json: result)
                completion(newObject, nil)
            } catch {
                completion(nil, .parseError)
            }
        }
    }
    
    private func send(request: Request, completion: (@escaping (Data?, NetworkError?) -> Void)) {
        var urlRequest = URLRequest(url: request.url)
        addHeaders(headers: request.headers, toRequest: &urlRequest)
        urlRequest.httpMethod = request.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
    
    private func addHeaders(headers: RequestHeader?, toRequest: inout URLRequest) {
        guard let headers = headers else { return }
        for key in headers.keys {
            if let value = headers[key] {
                toRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    private func parseResponse(data: Data) throws -> JSONDictionary {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            return json as! JSONDictionary
        }
        throw NetworkError.parseError
    }
    
}
