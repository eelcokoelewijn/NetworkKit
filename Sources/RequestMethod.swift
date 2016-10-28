import Foundation

public enum RequestMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Delete = "DELETE"
    case Options = "OPTIONS"
}

extension RequestMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Get:
            return "GET"
        case .Post:
            return "POST"
        case .Delete:
            return "DELETE"
        case .Put:
            return "PUT"
        case .Options:
            return "OPTIONS"
        }
    }
}
