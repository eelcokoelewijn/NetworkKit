import Foundation

public typealias RequestHeader = [String: String]

public struct Request {
    let method: RequestMethod
    let url: URL
    let headers: RequestHeader?
    
    init(url: URL,
         method: RequestMethod = .Get,
         headers: RequestHeader? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}

extension Request: Equatable { }

public func ==(lhs: Request, rhs: Request) -> Bool {
    if let lheaders = lhs.headers,
        let rheaders = rhs.headers {
            return lheaders == rheaders &&
                lhs.method == rhs.method &&
                lhs.url == rhs.url
    }
    
    if (lhs.headers == nil && rhs.headers != nil) ||
        (lhs.headers != nil && rhs.headers == nil) {
        return false
    }
    
    return lhs.method == rhs.method &&
        lhs.url == rhs.url
}
