import Foundation

public enum ContentType: String, Equatable {
    case empty
    case applicationJSON = "application/json"
    case applicationXWWWFormURLEncoded = "application/x-www-form-urlencoded"
    case applicationPDF = "application/pdf"
    case multipartFormData = "multipart/form-data"
    case textHtml = "text/html"
    case imagePNG = "image/png"
    case imageJPG = "image/jpg"
    case imageBMP = "image/bmp"
    case imageGIF = "image/gif"

    public init(withType type: String?) {
        switch type?.components(separatedBy: ";").first {
        case .some("application/json"):
            self = .applicationJSON
        case .some("application/x-www-form-urlencoded"):
            self = .applicationXWWWFormURLEncoded
        case .some("multipart/form-data"):
            self = .multipartFormData
        case .some("application/pdf"):
            self = .applicationPDF
        case .some("text/html"):
            self = .textHtml
        case .some("image/png"):
            self = .imagePNG
        case .some("image/jpg"):
            self = .imageJPG
        case .some("image/bmp"):
            self = .imageBMP
        case .some("image/gif"):
            self = .imageGIF
        default:
            self = .empty
        }
    }
}
