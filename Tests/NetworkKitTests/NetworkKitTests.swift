import XCTest
@testable import NetworkKit

class NetworkKitTests: XCTestCase {
    var sampleURL: URL!
    var sampleHeaders: RequestHeader!
    var sampleRequest: Request!
    var sampleResource: Resource!
    var sampleAddress: Address!
    
    override func setUp() {
        sampleURL = URL(string: "http://nu.nl")
        sampleHeaders = ["X-Auth": "oAuth",
                         "Bearer": "xxxxxxxxxxxxx"]
        sampleRequest = Request(url: sampleURL, method: .Put, headers: sampleHeaders)
        sampleResource = Resource(request: sampleRequest)
        sampleAddress = Address(street: "a", number: 1, city: "b", zipcode: "1234aa", country: "d")
    }
    
    func testLoadResource() {
        let exp = expectation(description: "Load address resource")
        let subject = NetworkKit()
    
        subject.load(resource: sampleResource) { (a:Address?, e:NetworkError?) in
            XCTAssertNotEqual(a, self.sampleAddress)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    static var allTests : [(String, (NetworkKitTests) -> () throws -> Void)] {
        return [
            ("testLoadResource", testLoadResource),
        ]
    }
}

struct Address {
    let street: String
    let number: Int
    let city: String
    let zipcode: String
    let country: String
}

extension Address: JSONDecodable {
    init(json: JSONDictionary) throws {
        guard let street = json["street"] as? String else {
            throw SerializationError.missing("street")
        }

        guard let number = json["number"] as? Int else {
            throw SerializationError.missing("number")
        }

        guard case (0...100) = number else {
            throw SerializationError.invalid("number", number)
        }
        
        guard let city = json["city"] as? String else {
            throw SerializationError.missing("city")
        }

        guard let zipcode = json["zipcode"] as? String else {
            throw SerializationError.missing("zipcode")
        }
        
        guard let country = json["country"] as? String else {
            throw SerializationError.missing("country")
        }

        self.street = street
        self.city = city
        self.number = number
        self.zipcode = zipcode
        self.country = country
    }
}

extension Address: Equatable { }

func ==(lhs: Address, rhs: Address) -> Bool {
    return lhs.city == rhs.city &&
        lhs.country == rhs.country &&
        lhs.street == rhs.street &&
        lhs.number == rhs.number &&
        lhs.zipcode == rhs.zipcode
}
