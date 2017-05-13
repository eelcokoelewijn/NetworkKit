import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case options = "OPTIONS"
    case head = "HEAD"
    case trace = "TRACE"
    case connect = "CONNECT"
}

extension RequestMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        case .options:
            return "OPTIONS"
        case .head:
            return "HEAD"
        case .trace:
            return "TRACE"
        case .connect:
            return "CONNECT"
        }
    }
}
