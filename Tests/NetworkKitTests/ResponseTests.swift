import XCTest
#if os(Linux)
import FoundationNetworking
#endif

@testable import NetworkKit

class ResponseTests: XCTestCase {
    var sampleHTTPResponse: HTTPURLResponse!
    var sampleURL: URL!
    var sampleSuccessStatusCode = 200
    var sampleContentTypeJSONHeader = [Header.contentType: ContentType.applicationJSON.rawValue]
    override func setUp() {
        super.setUp()
        sampleURL = URL(string: "http://nu.nl")!
        sampleHTTPResponse = HTTPURLResponse(url: sampleURL,
                                             statusCode: sampleSuccessStatusCode,
                                             httpVersion: nil,
                                             headerFields: sampleContentTypeJSONHeader)
    }

    func testIfResponseHasContentType() {
        let subject = Response(data: nil, httpResponse: sampleHTTPResponse, error: nil)
        XCTAssertEqual(subject.contentType, ContentType.applicationJSON)
    }

    static var allTests: [(String, (ResponseTests) -> () throws -> Void)] {
        return [
            ("testIfResponseHasCorrectContentType", testIfResponseHasContentType)
        ]
    }
}
