import XCTest
@testable import NetworkKit
#if os(Linux)
import FoundationNetworking
#endif

// https://github.com/toddmotto/public-apis

class NetworkKitTests: XCTestCase {
    var sampleRequest: URLRequest!
    var sampleResource: Resource<Name>!
    var sampleMultiRequest: URLRequest!
    var sampleMultiResource: Resource<[Name]>!

    override func setUp() {
        sampleRequest = RequestBuilder(url: URL(string: "http://uinames.com/api/")!).build()
        sampleResource = Resource(request: sampleRequest, parseResponse: { data in
            return try? JSONDecoder().decode(Name.self, from: data)
        })

        sampleMultiRequest = RequestBuilder(url: URL(string: "http://uinames.com/api/")!).parameters(["amount": 10]).build()
        sampleMultiResource = Resource(request: sampleMultiRequest, parseResponse: { data in
            return try? JSONDecoder().decode([Name].self, from: data)
        })
    }

    func testLoadSingleResource() {
        let exp = expectation(description: "Load single name resource")
        let subject = NetworkKit()

        subject.load(resource: sampleResource) { result in
            if case let .success(value) = result {
                XCTAssertNotNil(value)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadMultipleResources() {
        let exp = expectation(description: "Load 10 name resources")
        let subject = NetworkKit()

        subject.load(resource: sampleMultiResource) { result in
            if case let .success(value) = result {
                XCTAssertNotNil(value)
                XCTAssertEqual(value.count, 10)
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    static var allTests: [(String, (NetworkKitTests) -> () throws -> Void)] {
        return [
            ("testLoadSingleResource", testLoadSingleResource),
            ("testLoadMultipleResources", testLoadMultipleResources)
        ]
    }
}

struct Name: Codable {
    let firstname: String
    let surname: String
    let gender: String
    let region: String

    enum CodingKeys: String, CodingKey {
        case firstname = "name"
        case surname
        case gender
        case region
    }
}

extension Name: Equatable {
    static func == (lhs: Name, rhs: Name) -> Bool {
        return lhs.firstname == rhs.firstname &&
            lhs.surname == rhs.surname &&
            lhs.gender == rhs.gender &&
            lhs.region == rhs.region
    }
}
