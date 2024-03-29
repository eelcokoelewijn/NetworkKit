@testable import NetworkKit
import XCTest
#if os(Linux)
import FoundationNetworking
#endif

// https://github.com/toddmotto/public-apis

class NetworkKitTests: XCTestCase {
    var sampleRequest: URLRequest!
    var sampleResource: Resource<HTTPBinUUID>!

    override func setUp() {
        sampleRequest = RequestBuilder(url: URL(string: "https://httpbin.org/uuid")!).build()
        sampleResource = Resource(request: sampleRequest, parseResponse: { data in
            try? JSONDecoder().decode(HTTPBinUUID.self, from: data)
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

    func testAsyncLoadingSingleResource() {
        let exp = expectation(description: "Async load single name resource")
        let subject = NetworkKit()

        Task {
            do {
                let result = try await subject.load(resource: sampleResource)
                XCTAssertNotNil(result)
                exp.fulfill()
            } catch {
                throw error
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}

struct HTTPBinUUID: Codable {
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case uuid
    }
}

extension HTTPBinUUID: Equatable {
    static func == (lhs: HTTPBinUUID, rhs: HTTPBinUUID) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
