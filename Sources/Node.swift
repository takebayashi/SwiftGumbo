import CGumbo

public protocol OpaqueNode {
    var parent: OpaqueNode? { get }
}

public protocol Node: OpaqueNode {
    associatedtype RawType
    init(rawNode: RawType, parent: OpaqueNode?)
}

fileprivate func mapPointerToStruct(rawNode: UnsafeMutablePointer<GumboNode>) -> OpaqueNode {
    var parent: OpaqueNode? = nil
    if rawNode.pointee.parent != nil {
        parent = mapPointerToStruct(rawNode: rawNode.pointee.parent)
    }
    switch rawNode.pointee.type {
    case GUMBO_NODE_DOCUMENT:
        return DocumentNode(
            rawNode: rawNode.pointee.v.document,
            parent: parent
        )
    case GUMBO_NODE_ELEMENT:
        return ElementNode(
            rawNode: rawNode.pointee.v.element,
            parent: parent
        )
    case GUMBO_NODE_TEXT:
        return TextNode(
            rawNode: rawNode.pointee.v.text,
            parent: parent
        )
    default:
        fatalError()
    }
}

public typealias TagType = GumboTag

public struct DocumentNode: Node {
    public typealias RawType = GumboDocument

    public let parent: OpaqueNode?
    public let children: [OpaqueNode]

    public init(rawNode: GumboDocument, parent: OpaqueNode?) {
        self.parent = parent
        self.children = rawNode.children
            .flatMap { $0?.assumingMemoryBound(to: GumboNode.self) }
            .map(mapPointerToStruct)
    }
}

public struct ElementNode: Node {
    public typealias RawType = GumboElement

    public let parent: OpaqueNode?
    public let children: [OpaqueNode]
    public let tag: TagType
    public let attributes: [Attribute]

    public init(rawNode: GumboElement, parent: OpaqueNode?) {
        self.parent = parent
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

    public let parent: OpaqueNode?
    public let text: String

    public init(rawNode: GumboText, parent: OpaqueNode?) {
        self.parent = parent
        self.text = String(cString: rawNode.text)
    }
}

public struct Attribute {
    public let name: String
    public let value: String

    public init(rawNode: GumboAttribute) {
        self.name = String(cString: rawNode.name)
        self.value = String(cString: rawNode.value)
    }
}
