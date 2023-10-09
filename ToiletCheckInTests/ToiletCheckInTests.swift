//
//  ToiletCheckInTests.swift
//  ToiletCheckInTests
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import XCTest
import Testing
@testable import ToiletCheckIn

//final class ToiletCheckInTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}

final class AllTests: XCTestCase {
  func testAll() async {
    await XCTestScaffold.runAllTests(hostedBy: self)
  }
}

// Apple的には（Swiftコンパイラが並行性の安全性をより良く強制することを可能にするので）classよりもactor（or struct）を押している
actor MyActorTests {
    init() { }
    deinit { }
    @Test func isHoge() { Testing.__checkValue(false, sourceCode: .__fromSyntaxNode("false"), comments: [], isRequired: false, sourceLocation: Testing.SourceLocation()).__expected() }
}

@Test
func isHoge() {
    #expect(false)
}
