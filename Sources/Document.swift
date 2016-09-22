import CGumbo

public struct DocumentNode: Node {
    public typealias RawType = GumboDocument

    public let children: [OpaqueNode]

    public init(rawNode: GumboDocument) {
        self.children = rawNode.children
            .flatMap { $0?.assumingMemoryBound(to: GumboNode.self) }
            .map(mapPointerToStruct)
    }
}
