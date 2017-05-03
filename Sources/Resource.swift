import Foundation

public struct Resource<ResourceType> {
    let request: Request
    let parse: (Response) -> ResourceType?

    public init(request: Request, parseResponse: @escaping (Any) -> ResourceType?) {
        self.request = request
        self.parse = { response in
            guard let data: Data = response.data else { return nil }
            switch response.contentType {
            case .applicationJSON:
                let json: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
                return json.flatMap(parseResponse)
            default:
                let response: String? = String(data: data, encoding: .utf8)
                return response.flatMap(parseResponse)
            }
        }
    }
}

extension Resource: Equatable {
    public static func == <ResourceType>(lhs: Resource<ResourceType>, rhs: Resource<ResourceType>) -> Bool {
            return lhs.request == rhs.request
    }
}
