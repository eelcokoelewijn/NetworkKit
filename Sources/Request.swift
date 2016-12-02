import Foundation

public typealias RequestHeader = [String: String]
public typealias RequestParams = [String: Any]

public struct Request {
    let method: RequestMethod
    let url: URL
    let headers: RequestHeader
    let params: RequestParams
    
    public init(url: URL,
         method: RequestMethod = .get,
         headers: RequestHeader = [Header.contentType: ContentType.applicationJSON.rawValue],
         params: RequestParams = Dictionary()) {
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
        case .post:
            request.httpBody = convertParamsToData()
            return
        case .delete: fallthrough    
        case .options: fallthrough
        case .head: fallthrough
        case .connect: fallthrough
        case .trace:
            return
        }
    }
    
    private func addHeadersTo(request: inout URLRequest) {
        guard headers.keys.count > 0 else { return }
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func append(urlQueryItems: [URLQueryItem]?, toURL: URL?) -> URL? {
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = createURLQueryItems()
        return urlComponent?.url
    }
    
    private func createURLQueryItems() -> [URLQueryItem]? {
        guard params.keys.count > 0 else { return nil }
        return params.flatMap { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
    
    private func convertParamsToData() -> Data? {
        guard params.keys.count > 0,
            let contentTypeValue = headers[Header.contentType],
            let contentType = ContentType(rawValue: contentTypeValue)
            else { return nil }
        
        switch contentType {
        case .applicationJSON:
            return try? JSONSerialization.data(withJSONObject: params, options: [])
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
    return lhs.method == rhs.method &&
        lhs.url == rhs.url &&
        lhs.headers == rhs.headers
}
