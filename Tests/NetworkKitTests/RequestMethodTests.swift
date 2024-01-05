@testable import NetworkKit
import XCTest

class RequestMethodTests: XCTestCase {
    func testRawValues() {
        XCTAssertEqual(RequestMethod.get.rawValue, "GET")
        XCTAssertEqual(RequestMethod.post.rawValue, "POST")
        XCTAssertEqual(RequestMethod.put.rawValue, "PUT")
        XCTAssertEqual(RequestMethod.delete.rawValue, "DELETE")
        XCTAssertEqual(RequestMethod.options.rawValue, "OPTIONS")
        XCTAssertEqual(RequestMethod.head.rawValue, "HEAD")
        XCTAssertEqual(RequestMethod.trace.rawValue, "TRACE")
        XCTAssertEqual(RequestMethod.connect.rawValue, "CONNECT")
        XCTAssertEqual(RequestMethod.patch.rawValue, "PATCH")
    }

    func testInitFromRawValue() {
        XCTAssertEqual(RequestMethod(rawValue: "GET"), .get)
        XCTAssertEqual(RequestMethod(rawValue: "POST"), .post)
        XCTAssertEqual(RequestMethod(rawValue: "PUT"), .put)
        XCTAssertEqual(RequestMethod(rawValue: "DELETE"), .delete)
        XCTAssertEqual(RequestMethod(rawValue: "OPTIONS"), .options)
        XCTAssertEqual(RequestMethod(rawValue: "HEAD"), .head)
        XCTAssertEqual(RequestMethod(rawValue: "TRACE"), .trace)
        XCTAssertEqual(RequestMethod(rawValue: "CONNECT"), .connect)
        XCTAssertEqual(RequestMethod(rawValue: "PATCH"), .patch)
        XCTAssertNil(RequestMethod(rawValue: "INVALID"))
    }

    func testDescription() {
        XCTAssertEqual(RequestMethod.get.description, "GET")
        XCTAssertEqual(RequestMethod.post.description, "POST")
        XCTAssertEqual(RequestMethod.put.description, "PUT")
        XCTAssertEqual(RequestMethod.delete.description, "DELETE")
        XCTAssertEqual(RequestMethod.options.description, "OPTIONS")
        XCTAssertEqual(RequestMethod.head.description, "HEAD")
        XCTAssertEqual(RequestMethod.trace.description, "TRACE")
        XCTAssertEqual(RequestMethod.connect.description, "CONNECT")
        XCTAssertEqual(RequestMethod.patch.description, "PATCH")
    }
}
