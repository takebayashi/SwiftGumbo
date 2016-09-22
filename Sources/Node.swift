import CGumbo

public protocol OpaqueNode {
    var children: [OpaqueNode] { get }
}

public protocol Node: OpaqueNode {
    associatedtype RawType
    init(rawNode: RawType)
}

internal func mapPointerToStruct(rawNode: UnsafeMutablePointer<GumboNode>) -> OpaqueNode {
    switch rawNode.pointee.type {
    case GUMBO_NODE_DOCUMENT:
        return DocumentNode(rawNode: rawNode.pointee.v.document)
    case GUMBO_NODE_ELEMENT:
        return ElementNode(rawNode: rawNode.pointee.v.element)
    case GUMBO_NODE_TEXT:
        return TextNode(rawNode: rawNode.pointee.v.text)
    case GUMBO_NODE_CDATA:
        return CdataNode(rawNode: rawNode.pointee.v.text)
    case GUMBO_NODE_COMMENT:
        return CommentNode(rawNode: rawNode.pointee.v.text)
    case GUMBO_NODE_WHITESPACE:
        return WhitespaceNode(rawNode: rawNode.pointee.v.text)
    default:
        fatalError()
    }
}
