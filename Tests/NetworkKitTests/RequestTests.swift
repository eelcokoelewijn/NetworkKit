import XCTest
@testable import NetworkKit

class RequestTests: XCTestCase {
    var sampleURL: URL!
    var sampleHeaders: RequestHeader!
    var sampleRequest: Request!
    
    override func setUp() {
        sampleURL = URL(string: "http://nu.nl")
        sampleHeaders = ["X-Auth": "oAuth",
                         "Bearer": "xxxxxxxxxxxxx"]
        sampleRequest = Request(url: sampleURL, method: .Put, headers: sampleHeaders)
    }
    
    func testRequestMethodStringRepresentation() {
        let subject = RequestMethod.Get
        
        XCTAssertEqual(subject.rawValue, "GET")
    }
    
    func testRequestWithUrl() {
        let subject = Request(url: sampleURL)
        XCTAssertEqual(subject.url, sampleURL)
    }
    
    func testRequestWithPostMethod() {
        let subject = Request(url: sampleURL, method: .Post)
        XCTAssertEqual(subject.method, .Post)
    }
    
    func testRequestWithAuthHeaders() {
        let subject = Request(url: sampleURL, headers: sampleHeaders)
        XCTAssertEqual(subject.headers!, sampleHeaders)
    }
    
    func testResourceWithRequest() {
        let subject = Resource(request: sampleRequest)
        
        XCTAssertEqual(subject.request, sampleRequest)
    }
    
    func testRequestForNotEquatability() {
        let subjectA = Request(url: sampleURL, headers: ["A":"B"])
        let subjectB = Request(url: sampleURL)
        
        XCTAssertNotEqual(subjectA, subjectB)
    }
    
    func testRequestForEquatabilityWithHeaders() {
        let subjectA = Request(url: sampleURL, headers: ["A":"B"])
        let subjectB = Request(url: sampleURL, headers: ["A":"B"])
        
        XCTAssertEqual(subjectA, subjectB)
    }
    
    func testRequestForEquatabilityWithoutHeaders() {
        let subjectA = Request(url: sampleURL)
        let subjectB = Request(url: sampleURL)
        
        XCTAssertEqual(subjectA, subjectB)
    }
    
    func testResourceForEquatability() {
        let resourceA = Resource(request: sampleRequest)
        let resourceB = Resource(request: Request(url: URL(string:"http://google.com")!))
        XCTAssertNotEqual(resourceA, resourceB)
    }

    static var allTests : [(String, (RequestTests) -> () throws -> Void)] {
        return [
            ("testRequestWithUrl", testRequestWithUrl),
            ("testRequestMethodStringRepresentation", testRequestMethodStringRepresentation),
            ("testRequestWithPostMethod", testRequestWithPostMethod),
            ("testRequestWithAuthHeaders", testRequestWithAuthHeaders),
            ("testResourceWithRequest", testResourceWithRequest),
            ("testRequestForEquatability",testRequestForNotEquatability),
            ("testRequestForEquatability", testRequestForEquatabilityWithHeaders),
            ("testRequestForEquatabilityWithoutHeaders", testRequestForEquatabilityWithoutHeaders),
            ("testResourceForEquatability", testResourceForEquatability),
        ]
    }
    
}
