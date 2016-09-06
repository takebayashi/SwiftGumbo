import XCTest
@testable import SwiftGumbo

class SwiftGumboTests: XCTestCase {
    func testParse() {
        let html = "<html><head></head><body><p>test</p><p id='p2'>test2</p></body></html>"
        guard let document = parse(html: html) else {
            XCTFail("failed parsing html")
            return
        }
        // /html
        XCTAssertEqual(document.children.count, 1)
        if let root = document.children[0] as? ElementNode {
            XCTAssertEqual(root.children.count, 2)
            // /html/body
            if let body = root.children[1] as? ElementNode {
                XCTAssertEqual(body.children.count, 2)
                // /html/body/p[1]
                if let p = body.children[1] as? ElementNode {
                    if let attr = p.attributes.first {
                        XCTAssertEqual(attr.name, "id")
                        XCTAssertEqual(attr.value, "p2")
                    } else {
                        XCTFail("1 Attribute should be, but not")
                    }
                } else {
                    XCTFail("ElementNode should be return, but not")
                }
            } else {
                XCTFail("ElementNode should be return, but not")
            }
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
