import XCTest
@testable import SwiftGumbo

class SwiftGumboTests: XCTestCase {
    func testParse() {
        let html = "<html><head></head><body><p>test</p><p>test2</p></body></html>"
        guard let document = parse(html: html) else {
            XCTFail("failed parsing html")
            return
        }
        // /html
        XCTAssertEqual(document.children.count, 1)
        if let e = document.children[0] as? ElementNode {
            XCTAssertEqual(e.children.count, 2)
        } else {
            XCTFail("ElementNode should be return, but not")
        }
    }


    static var allTests: [(String, (SwiftGumboTests) -> () throws -> Void)] {
        return [
            ("testParse", testParse),
        ]
    }
}
