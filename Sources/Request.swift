import Foundation

public typealias RequestHeader = [String: String]
public typealias RequestParams = [String: Any]

// MARK: Request

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
    public func build() -> URLRequest {
        return URLRequest(url: url)
            .set(method: method)
            .set(headers: headers)
            .set(params: params, forMethod: method)
    }
}

// MARK: Request Equatable

extension Request: Equatable {
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.method == rhs.method &&
            lhs.url == rhs.url &&
            lhs.headers == rhs.headers
    }
}

// MARK: URLRequest extension

extension URLRequest {
    public func set(method: RequestMethod) -> URLRequest {
        var urq = self
        urq.httpMethod = method.rawValue
        return urq
    }

    public func set(headers: RequestHeader) -> URLRequest {
        var urq = self
        urq.allHTTPHeaderFields = headers
        return urq
    }

    public func set(params: RequestParams,
                    forMethod method: RequestMethod) -> URLRequest {
        switch method {
        case .get:
            return self.set(queryString: params)
        case .put: fallthrough
        case .post:
            return self.set(body: params)
        case .delete: fallthrough
        case .options: fallthrough
        case .head: fallthrough
        case .connect: fallthrough
        case .trace:
            return self
        }
    }

    private func set(queryString query: RequestParams) -> URLRequest {
        var urq = self
        urq.url = append(urlQueryItems: createURLQueryItems(fromParams: query),
                         toURL: urq.url)
        return urq
    }

    private func set(body: RequestParams) -> URLRequest {
        var urq = self
        urq.httpBody = getData(fromParams: body, withHeaders: urq.allHTTPHeaderFields)
        return urq
    }

    private func append(urlQueryItems: [URLQueryItem]?, toURL: URL?) -> URL? {
        guard let url = toURL else { return nil }
        var urlComponent: URLComponents? = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = urlQueryItems
        return urlComponent?.url
    }

    private func createURLQueryItems(fromParams params: RequestParams) -> [URLQueryItem]? {
        guard params.keys.count > 0 else { return nil }
        return params
            .flatMap { key, value in
                return URLQueryItem(name: key, value: String(describing: value))
            }
            .filter { qitem in
                guard let v: String = qitem.value else { return false }
                return !v.isEmpty
        }
    }

    private func getData(fromParams params: RequestParams, withHeaders headers: RequestHeader?) -> Data? {
        guard params.keys.count > 0,
            let headers = headers,
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
        let keyValue: [String] = params.flatMap { key, value in
            return "\(key)=\(String(describing: value))"
        }
        return keyValue.joined(separator: "&")
    }
}
