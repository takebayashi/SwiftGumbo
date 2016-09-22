import XCTest
import CGumbo
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

    func testTag() {
        let tags = [GUMBO_TAG_TITLE, GUMBO_TAG_P, GUMBO_TAG_A]
        let names = ["title", "p", "a"]
        for tag in tags {
            let index = tags.index(of: tag)!
            XCTAssertEqual(tag.name, names[index])
            XCTAssertEqual(Tag(name: names[index]), tag)
        }
    }

    func testAttributes() {
        let attrs = [
            Attribute(name: "a", value: "aa"),
            Attribute(name: "b", value: "bb"),
            Attribute(name: "c", value: "cc"),
        ]
        if let b = attrs["b"] {
            XCTAssertEqual(b.value, "bb")
        } else {
            XCTFail("failed to access attribute")
        }
        let classAttr = Attribute(name: "class", value: "class1 class2  class3")
        XCTAssertEqual(
            classAttr.valuesSeparatedByWhiteSpaces,
            ["class1", "class2", "class3"]
        )
    }

    static var allTests: [(String, (SwiftGumboTests) -> () throws -> Void)] {
        return [
            ("testParse", testParse),
            ("testTag", testTag),
        ]
    }
}
