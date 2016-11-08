import Foundation

struct Response {
    let data: Data?
    let httpResponse: HTTPURLResponse?
    let error: Error?
    var contentType: ContentType {
        return ContentType(withType: self.header(withName: Header.contentType))
    }
    
    private func header(withName name: String) -> String? {
        guard let header = httpResponse?.allHeaderFields[name] as? String else {
            return nil
        }
        return header
    }
}
