import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public typealias RequestHeader = [String: String]
public typealias RequestParams = [String: Any]

public final class RequestBuilder {
    private var request: URLRequest

    public init(url: URL) {
        self.request = URLRequest(url: url)
    }

    public func method(_ method: RequestMethod) -> Self {
        request.httpMethod = method.rawValue
        return self
    }

    public func headers(_ headers: RequestHeader) -> Self {
        request.allHTTPHeaderFields = headers
        return self
    }

    public func parameters(_ params: RequestParams) -> Self {
        request.url = createURLWithQueryString(withParameter: params)
        return self
    }

    public func body(
        _ body: RequestParams,
        withContentType contentType: ContentType = .applicationJSON,
        encoding: String.Encoding = .utf8
    ) -> Self {
        request.httpBody = createHttpBodyData(
            withParams: body,
            forContentType: contentType,
            encoding: encoding
        )
        return self
    }

    public func build() -> URLRequest {
        request
    }

    // MARK: Query string construction

    private func createURLWithQueryString(withParameter params: RequestParams) -> URL? {
        let queryString = createURLQueryItems(fromParams: params)
        guard
            let url = request.url,
            var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        urlComponent.queryItems = queryString
        guard let urlWitParameters = urlComponent.url else {
            return nil
        }
        return urlWitParameters
    }

    private func createURLQueryItems(fromParams params: RequestParams) -> [URLQueryItem]? {
        guard !params.keys.isEmpty else { return nil }
        return params
            .compactMap { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            .filter { qitem in
                guard let v: String = qitem.value else { return false }
                return !v.isEmpty
            }
    }

    // MARK: Body data construction

    private func createHttpBodyData(
        withParams params: RequestParams,
        forContentType contentType: ContentType,
        encoding: String.Encoding
    ) -> Data? {
        guard !params.keys.isEmpty else { return nil }

        switch contentType {
        case .applicationJSON:
            return try? JSONSerialization.data(withJSONObject: params, options: [])
        default:
            return createStringFromParams(params: params)?.data(using: encoding)
        }
    }

    private func createStringFromParams(params: RequestParams) -> String? {
        let keyValue: [String] = params.compactMap { key, value in
            "\(key)=\(String(describing: value))"
        }
        return keyValue.joined(separator: "&")
    }
}
