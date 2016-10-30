import Foundation

public typealias RequestHeader = [String: String]
public typealias RequestParams = [String: Any]

public struct Request {
    let method: RequestMethod
    let url: URL
    let headers: RequestHeader?
    let params: RequestParams?
    
    public init(url: URL,
         method: RequestMethod = .get,
         headers: RequestHeader? = nil,
         params: RequestParams? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.params = params
    }
}

extension Request {
    public func buildURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        setHttpMethodFor(request: &urlRequest)
        addHeadersTo(request: &urlRequest)
        addParametersTo(request: &urlRequest)
        return urlRequest
    }
    
    private func setHttpMethodFor(request: inout URLRequest) {
        request.httpMethod = method.rawValue
    }
    
    private func addParametersTo(request: inout URLRequest) {
        switch method {
        case .get:
            let queryItems = createURLQueryItems()
            request.url = append(urlQueryItems: queryItems, toURL: request.url)
            return
        case .put: fallthrough
        case .delete: fallthrough
        case .post:
            request.httpBody = getDataFromParams()
            return
        case .options: fallthrough
        case .head: fallthrough
        case .connect: fallthrough
        case .trace:
            return
        }
    }
    
    private func addHeadersTo(request: inout URLRequest) {
        guard let headers = headers else { return }
        for key in headers.keys {
            if let value = headers[key] {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    private func append(urlQueryItems: [URLQueryItem]?, toURL: URL?) -> URL? {
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = createURLQueryItems()
        return urlComponent?.url
    }
    
    private func createURLQueryItems() -> [URLQueryItem]? {
        guard let params = params else { return nil }
        return params.flatMap { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
    
    private func getDataFromParams() -> Data? {
        guard let params = params else { return nil }
        switch headers?["Content-Type"] {
        case .some("application/json"):
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        case .some("application/x-www-form-urlencoded"): fallthrough
        default:
            return createStringFromParams(params: params)?.data(using: .utf8)
        }
    }
    
    private func createStringFromParams(params: RequestParams) -> String? {
        let keyValue = params.flatMap { key, value in
            return "\(key)=\(String(describing: value))"
        }
        return keyValue.joined(separator: "&")
    }
}


//MARK: Equatable

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
    
    if (lhs.params == nil && rhs.params != nil) ||
        (lhs.params != nil && rhs.params == nil) {
        return false
    }
    
    return lhs.method == rhs.method &&
        lhs.url == rhs.url
}
