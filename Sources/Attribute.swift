import CGumbo

public struct Attribute {
    public let name: String
    public let value: String

    public init(rawNode: GumboAttribute) {
        self.name = String(cString: rawNode.name)
        self.value = String(cString: rawNode.value)
    }
}
