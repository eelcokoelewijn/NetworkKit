@testable import NetworkKitTests
@testable import RequestBuilderTests
@testable import ResponseTests
import XCTest

XCTMain([
    testCase(NetworkKitTests.allTests),
    testCase(RequestBuilderTests.allTests),
    testCase(ResponseTests.allTests)
])
