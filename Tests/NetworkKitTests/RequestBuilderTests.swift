import XCTest
#if os(Linux)
import FoundationNetworking
#endif

@testable import NetworkKit

class RequestBuilderTests: XCTestCase {
    var sampleURL: URL!
    var sampleHeaders: RequestHeader!
    var sampleURLRequest: URLRequest!
    var sampleRequestParams: RequestParams!
    var sampleRequestParamsStringEncoded: String!
    var sampleRequestParamsString: String!

    override func setUp() {
        sampleURL = URL(string: "http://nu.nl")!
        sampleHeaders = ["X-Auth": "oAuth",
                         "Bearer": "xxxxxxxxxxxxx"]
        sampleRequestParams = ["extend": "$User^Profile", "page": 3, "search": "swift url"]
        sampleRequestParamsStringEncoded = "search=swift%20url"
        sampleRequestParamsString = "extend=$User^Profile"
        sampleURLRequest = URLRequest(url: sampleURL)
        sampleURLRequest.addValue(ContentType.applicationJSON.rawValue, forHTTPHeaderField: Header.contentType)
    }

    func testBuildingOfURLRequest() {
        let subject = RequestBuilder(url: sampleURL)
            .headers([Header.contentType: ContentType.applicationJSON.rawValue])

        let result: URLRequest = subject.build()
        XCTAssertEqual(result.url, sampleURLRequest.url)
        XCTAssertEqual(result.httpBody, sampleURLRequest.httpBody)
        XCTAssertEqual(result.httpMethod, sampleURLRequest.httpMethod)
        XCTAssertEqual(result.allHTTPHeaderFields!, sampleURLRequest.allHTTPHeaderFields!)
    }

    func testBuildingOfURLRequestWithHeaders() {
        let subject = RequestBuilder(url: sampleURL)
            .headers(sampleHeaders)
        let result = subject.build()
        XCTAssertEqual(result.allHTTPHeaderFields!, sampleHeaders)
    }

    func testBuildingOfGetURLRequestWithParams() {
        let subject = RequestBuilder(url: sampleURL)
            .parameters(sampleRequestParams)
        let result = subject.build()
        guard let query = result.url?.query else {
            XCTFail("Failed to create url request")
            return
        }
        XCTAssertTrue(query.contains(sampleRequestParamsStringEncoded), "Query parameters are not correct encoded")
    }

    func testBuildingOfPostURLRequestWithParams() {
        let subject = RequestBuilder(url: sampleURL)
            .method(.post)
            .headers([Header.contentType: ContentType.applicationXWWWFormURLEncoded.rawValue])
            .body(sampleRequestParams, withContentType: .applicationXWWWFormURLEncoded)

        let result = subject.build()
        guard let httpBodyString = String(data: result.httpBody!, encoding: .utf8) else {
            XCTFail("Failed to decode http body")
            return
        }
        XCTAssertTrue(httpBodyString.contains(sampleRequestParamsString), "Http body parameters are not correct encoded")
    }

    func testBuildingOfPutURLRequestWithJSONContentTypeAndParams() {
        let subject = RequestBuilder(url: sampleURL)
            .method(.put)
            .headers([Header.contentType: ContentType.applicationJSON.rawValue])
            .parameters(sampleRequestParams)

        let result = subject.build()
        XCTAssertNil(result.httpBody)
    }

    func testRequestMethodStringRepresentation() {
        let subject = RequestMethod.get
        XCTAssertEqual(subject.rawValue, "GET")
    }

    func testRequestWithUrl() {
        let subject = RequestBuilder(url: sampleURL).build()
        XCTAssertEqual(subject.url, sampleURL)
    }

    func testRequestWithPostMethod() {
        let subject = RequestBuilder(url: sampleURL)
            .method(.post)
            .build()
        XCTAssertEqual(subject.httpMethod, RequestMethod.post.rawValue)
    }

    func testRequestWithAuthHeaders() {
        let subject = RequestBuilder(url: sampleURL)
            .headers(sampleHeaders)
            .build()
        XCTAssertEqual(subject.allHTTPHeaderFields, sampleHeaders)
    }

    func testResourceWithRequest() {
        let subject = Resource<String>(request: sampleURLRequest) { _ in return nil }

        XCTAssertEqual(subject.request, sampleURLRequest)
    }

    func testRequestForNotEquatability() {
        let subjectA = RequestBuilder(url: sampleURL).headers(["A": "B"]).build()
        let subjectB = RequestBuilder(url: sampleURL).build()

        XCTAssertNotEqual(subjectA.allHTTPHeaderFields, subjectB.allHTTPHeaderFields)
    }

    func testRequestForEquatabilityWithHeaders() {
        let subjectA = RequestBuilder(url: sampleURL).headers(["A": "B"]).build()
        let subjectB = RequestBuilder(url: sampleURL).headers(["A": "B"]).build()

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithoutHeaders() {
        let subjectA = RequestBuilder(url: sampleURL).parameters(["A": "B"]).build()
        let subjectB = RequestBuilder(url: sampleURL).parameters(["A": "B"]).build()

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithParams() {
        let subjectA = RequestBuilder(url: sampleURL).parameters(["A": "B"]).build()
        let subjectB = RequestBuilder(url: sampleURL).parameters(["A": "B"]).build()

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithoutParams() {
        let subjectA = RequestBuilder(url: sampleURL).headers(["A": "B"]).build()
        let subjectB = RequestBuilder(url: sampleURL).headers(["A": "B"]).build()

        XCTAssertEqual(subjectA, subjectB)
    }

    func testRequestForEquatabilityWithParamsAndHeaders() {
        let subjectA = RequestBuilder(url: sampleURL).headers(["A": "B"]).parameters(["S": "D"]).build()
        let subjectB = RequestBuilder(url: sampleURL).headers(["A": "B"]).parameters(["S": "D"]).build()

        XCTAssertEqual(subjectA, subjectB)
    }

    func testResourceForEquatability() {
        let resourceA = Resource<String>(request: sampleURLRequest) { _ in nil }
        let resourceB = Resource<String>(request: URLRequest(url: URL(string: "http://google.com")!)) { _ in nil }
        XCTAssertNotEqual(resourceA, resourceB)
    }

    static var allTests: [(String, (RequestBuilderTests) -> () throws -> Void)] {
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
