import CGumbo

public struct TextNode: Node {
    public typealias RawType = GumboText

    public let children: [OpaqueNode] = []
    public let text: String

    public init(rawNode: GumboText) {
        self.text = String(cString: rawNode.text)
    }
}

public struct CdataNode: Node {
    public typealias RawType = GumboText

    public let children: [OpaqueNode] = []
    public let text: String

    public init(rawNode: GumboText) {
        self.text = String(cString: rawNode.text)
    }
}

public struct CommentNode: Node {
    public typealias RawType = GumboText

    public let children: [OpaqueNode] = []
    public let text: String

    public init(rawNode: GumboText) {
        self.text = String(cString: rawNode.text)
    }
}

public struct WhitespaceNode: Node {
    public typealias RawType = GumboText

    public let children: [OpaqueNode] = []
    public let text: String

    public init(rawNode: GumboText) {
        self.text = String(cString: rawNode.text)
    }
}
