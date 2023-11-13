import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public struct Resource<ResourceType: Equatable> {
    let request: URLRequest
    let parse: (Response) -> ResourceType?

    public init(request: URLRequest, parseResponse: @escaping (Data) -> ResourceType?) {
        self.request = request
        self.parse = { response in
            guard let data: Data = response.data else { return nil }
            return parseResponse(data)
        }
    }
}

extension Resource: Equatable {
    public static func == (lhs: Resource<ResourceType>, rhs: Resource<ResourceType>) -> Bool {
        lhs.request == rhs.request
    }
}
