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

extension OpaqueNode {
    public func recursiveFlatMap<R>(_ transform: (OpaqueNode) throws -> R?) rethrows -> [R] {
        let selfResult = try transform(self)
        let childrenResults = try self.children.flatMap { child in
            return try child.recursiveFlatMap(transform)
        }
        var all: [R] = selfResult != nil ? [selfResult!] : []
        all.append(contentsOf: childrenResults)
        return all
    }
}
