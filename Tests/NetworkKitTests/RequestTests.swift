import XCTest
@testable import NetworkKit

class RequestTests: XCTestCase {
    var sampleURL: URL!
    var sampleHeaders: RequestHeader!
    var sampleRequest: Request!
    var sampleURLRequest: URLRequest!
    var sampleRequestParams: RequestParams!
    var sampleRequestParamsStringEncoded: String!
    var sampleRequestParamsString: String!

    override func setUp() {
        sampleURL = URL(string: "http://nu.nl")!
        sampleHeaders = ["X-Auth": "oAuth",
                         "Bearer": "xxxxxxxxxxxxx"]
        sampleRequest = Request(url: sampleURL, method: .put, headers: sampleHeaders)
        sampleRequestParams = ["extend": "$User^Profile", "page": 3, "search": "swift url"]
        sampleRequestParamsStringEncoded = "extend=$User%5EProfile&page=3&search=swift%20url"
        sampleRequestParamsString = "extend=$User^Profile&page=3&search=swift url"
        sampleURLRequest = URLRequest(url: sampleURL)
        sampleURLRequest.addValue(ContentType.applicationJSON.rawValue, forHTTPHeaderField: Header.contentType)
    }

    func testBuildingOfURLRequest() {
        let subject: Request = Request(url: sampleURL,
                                       headers: [Header.contentType: ContentType.applicationJSON.rawValue])
        let result: URLRequest = subject.build()
        XCTAssertEqual(result.url, sampleURLRequest.url)
        XCTAssertEqual(result.httpBody, sampleURLRequest.httpBody)
        XCTAssertEqual(result.httpMethod, sampleURLRequest.httpMethod)
        XCTAssertEqual(result.allHTTPHeaderFields!, sampleURLRequest.allHTTPHeaderFields!)
    }

    func testBuildingOfURLRequestWithHeaders() {
        let subject = Request(url: sampleURL, headers: sampleHeaders)
        let result = subject.build()
        XCTAssertEqual(result.allHTTPHeaderFields!, sampleHeaders)
    }

    func testBuildingOfGetURLRequestWithParams() {
        let subject = Request(url: sampleURL, params: sampleRequestParams)
        let result = subject.build()
        XCTAssertEqual(result.url?.query, sampleRequestParamsStringEncoded)
    }

    func testBuildingOfPostURLRequestWithParams() {
        let subject = Request(url: sampleURL,
                              method: .post,
                              headers: [Header.contentType: ContentType.applicationXWWWFormURLEncoded.rawValue],
                              params: sampleRequestParams)
        let result = subject.build()

        let httpBodyString = String(data: result.httpBody!, encoding: .utf8)
        XCTAssertEqual(httpBodyString, sampleRequestParamsString)
    }

    func testBuildingOfPutURLRequestWithJSONContentTypeAndParams() {
        let subject = Request(url: sampleURL,
                              method: .put,
                              headers: [Header.contentType: ContentType.applicationJSON.rawValue],
                              params: sampleRequestParams)
        let result = subject.build()
        let httpBodyString = String(data: result.httpBody!, encoding: .utf8)
        XCTAssertNotNil(httpBodyString)
    }

    func testRequestMethodStringRepresentation() {
        let subject = RequestMethod.get
        XCTAssertEqual(subject.rawValue, "GET")
    }

    func testRequestWithUrl() {
        let subject = Request(url: sampleURL)
        XCTAssertEqual(subject.url, sampleURL)
    }

    func testRequestWithPostMethod() {
        let subject = Request(url: sampleURL, method: .post)
        XCTAssertEqual(subject.method, .post)
    }

    func testRequestWithAuthHeaders() {
        let subject = Request(url: sampleURL, headers: sampleHeaders)
        XCTAssertEqual(subject.headers, sampleHeaders)
    }

    func testResourceWithRequest() {
        let subject = Resource<String>(request: sampleRequest) { _ in return nil }

        XCTAssertEqual(subject.request, sampleRequest)
    }

    func testRequestForNotEquatability() {
        let subjectA = Request(url: sampleURL, headers: ["A": "B"])
        let subjectB = Request(url: sampleURL)

        XCTAssertNotEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithHeaders() {
        let subjectA = Request(url: sampleURL, headers: ["A": "B"])
        let subjectB = Request(url: sampleURL, headers: ["A": "B"])

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithoutHeaders() {
        let subjectA = Request(url: sampleURL, params: ["A": "B"])
        let subjectB = Request(url: sampleURL, params: ["A": "B"])

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithParams() {
        let subjectA = Request(url: sampleURL, params: ["A": "B"])
        let subjectB = Request(url: sampleURL, params: ["A": "B"])

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithoutParams() {
        let subjectA = Request(url: sampleURL, headers: ["A": "B"])
        let subjectB = Request(url: sampleURL, headers: ["A": "B"])

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithParamsAndHeaders() {
        let subjectA = Request(url: sampleURL, headers: ["A": "B"], params: ["S": "D"])
        let subjectB = Request(url: sampleURL, headers: ["A": "B"], params: ["S": "D"])

        XCTAssertEqual(subjectA, subjectB)
    }

    func testResourceForEquatability() {
        let resourceA = Resource<String>(request: sampleRequest) { _ in nil }
        let resourceB = Resource<String>(request: Request(url: URL(string: "http://google.com")!)) { _ in nil }
        XCTAssertNotEqual(resourceA, resourceB)
    }

    static var allTests: [(String, (RequestTests) -> () throws -> Void)] {
        return [
            ("testRequestWithUrl", testRequestWithUrl),
            ("testRequestMethodStringRepresentation", testRequestMethodStringRepresentation),
            ("testRequestWithPostMethod", testRequestWithPostMethod),
            ("testRequestWithAuthHeaders", testRequestWithAuthHeaders),
            ("testResourceWithRequest", testResourceWithRequest),
            ("testRequestForEquatability", testRequestForNotEquatability),
            ("testRequestForEquatability", testRequestForEquatabilityWithHeaders),
            ("testRequestForEquatabilityWithoutHeaders", testRequestForEquatabilityWithoutHeaders),
            ("testResourceForEquatability", testResourceForEquatability)
        ]
    }

}
