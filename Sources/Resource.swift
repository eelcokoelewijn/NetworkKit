import Foundation

public struct Resource<ResourceType> {
    let request: Request
    let parse: (Data) -> ResourceType?
    
    public init(request: Request, parseJSON: @escaping (Any) -> ResourceType?) {
        self.request = request
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

extension Resource: Equatable { }

public func ==<ResourceType>(lhs: Resource<ResourceType>, rhs: Resource<ResourceType>) -> Bool {
    return lhs.request == rhs.request
}
