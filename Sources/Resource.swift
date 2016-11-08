import Foundation

public struct Resource<ResourceType> {
    let request: Request
    let parse: (Response) -> ResourceType?
    
    public init(request: Request, parseResponse: @escaping (Any) -> ResourceType?) {
        self.request = request
        self.parse = { response in
            guard let data = response.data else { return nil }
            switch response.contentType {
            case .applicationJSON:
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                return json.flatMap(parseResponse)
            default:
                let response = String(data: data, encoding: .utf8)
                return response.flatMap(parseResponse)
            }
        }
    }
}

extension Resource: Equatable { }

public func ==<ResourceType>(lhs: Resource<ResourceType>, rhs: Resource<ResourceType>) -> Bool {
    return lhs.request == rhs.request
}
