import XCTest
@testable import NetworkKitTests
@testable import RequestBuilderTests
@testable import ResponseTests

XCTMain([
     testCase(NetworkKitTests.allTests),
     testCase(RequestBuilderTests.allTests),
     testCase(ResponseTests.allTests)
])
