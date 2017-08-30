import XCTest
@testable import NetworkKit

// https://github.com/toddmotto/public-apis

class NetworkKitTests: XCTestCase {
    var sampleRequest: Request!
    var sampleResource: Resource<Name>!
    var sampleMultiRequest: Request!
    var sampleMultiResource: Resource<[Name]>!

    override func setUp() {
        sampleRequest = Request(url: URL(string: "http://uinames.com/api/")!)
        sampleResource = Resource(request: sampleRequest, parseResponse: { data in
            let json: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dic = json as? JSONDictionary else { return nil }
            do {
                return try Name(json: dic)
            } catch {
                print(error)
            }
            return nil
        })

        sampleMultiRequest = Request(url: URL(string: "http://uinames.com/api/")!, params: ["amount": 10])
        sampleMultiResource = Resource(request: sampleMultiRequest, parseResponse: { data in
            let json: Any? = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dic = json as? [JSONDictionary] else { return nil }
            do {
                return try dic.flatMap(Name.init)
            } catch {
                print(error)
            }
            return nil
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

struct Name {
    let firstname: String
    let surname: String
    let gender: String
    let region: String
}

extension Name {
    init(json: JSONDictionary) throws {
        guard let firstname = json["name"] as? String else {
            throw SerializationError.missing("firstname")
        }

        guard let surname = json["surname"] as? String else {
            throw SerializationError.missing("surname")
        }

        guard let gender = json["gender"] as? String else {
            throw SerializationError.missing("gender")
        }

        guard let region = json["region"] as? String else {
            throw SerializationError.missing("region")
        }

        self.firstname = firstname
        self.surname = surname
        self.gender = gender
        self.region = region
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
