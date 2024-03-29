import Foundation
#if os(Linux)
import FoundationNetworking
#endif

struct Response {
    let data: Data?
    let httpResponse: HTTPURLResponse?
    let error: Error?
    var contentType: ContentType {
        ContentType(withType: header(withName: Header.contentType))
    }

    private func header(withName name: String) -> String? {
        guard let header = httpResponse?.allHeaderFields[name] as? String else {
            return nil
        }
        return header
    }
}
