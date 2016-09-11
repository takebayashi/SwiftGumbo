import CGumbo

public typealias Tag = GumboTag

extension Tag {
    public init(name: String) {
        self.rawValue = name.withCString(gumbo_tag_enum).rawValue
    }

    public var name: String {
        get {
            return String(cString: gumbo_normalized_tagname(self))
        }
    }
}
