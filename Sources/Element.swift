import CGumbo

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
