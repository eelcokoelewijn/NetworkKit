import Foundation

public struct Resource<ResourceType> {
    let request: Request
    let parse: (Response) -> ResourceType?

    public init(request: Request, parseResponse: @escaping (Data) -> ResourceType?) {
        self.request = request
        self.parse = { response in
            guard let data: Data = response.data else { return nil }
            return parseResponse(data)
        }
    }
}

extension Resource: Equatable {
    public static func == <ResourceType>(lhs: Resource<ResourceType>, rhs: Resource<ResourceType>) -> Bool {
            return lhs.request == rhs.request
    }
}
