import CGumbo

public protocol OpaqueNode {
    var children: [OpaqueNode] { get }
}

public protocol Node: OpaqueNode {
    associatedtype RawType
    init(rawNode: RawType)
}

fileprivate func mapPointerToStruct(rawNode: UnsafeMutablePointer<GumboNode>) -> OpaqueNode {
    switch rawNode.pointee.type {
    case GUMBO_NODE_DOCUMENT:
        return DocumentNode(rawNode: rawNode.pointee.v.document)
    case GUMBO_NODE_ELEMENT:
        return ElementNode(rawNode: rawNode.pointee.v.element)
    case GUMBO_NODE_TEXT:
        return TextNode(rawNode: rawNode.pointee.v.text)
    default:
        fatalError()
    }
}

public struct DocumentNode: Node {
    public typealias RawType = GumboDocument

    public let children: [OpaqueNode]

    public init(rawNode: GumboDocument) {
        self.children = rawNode.children
            .flatMap { $0?.assumingMemoryBound(to: GumboNode.self) }
            .map(mapPointerToStruct)
    }
}

public struct ElementNode: Node {
    public typealias RawType = GumboElement

    public let children: [OpaqueNode]
    public let tag: Tag
    public let attributes: [Attribute]

    public init(rawNode: GumboElement) {
        self.children = rawNode.children
            .flatMap { $0?.assumingMemoryBound(to: GumboNode.self) }
            .map(mapPointerToStruct)
        self.tag = rawNode.tag
        self.attributes = rawNode.attributes
            .flatMap { $0?.assumingMemoryBound(to: GumboAttribute.self) }
            .map { Attribute(rawNode: $0.pointee) }
    }
}

public struct TextNode: Node {
    public typealias RawType = GumboText

    public let children: [OpaqueNode] = []
    public let text: String

    public init(rawNode: GumboText) {
        self.text = String(cString: rawNode.text)
    }
}
