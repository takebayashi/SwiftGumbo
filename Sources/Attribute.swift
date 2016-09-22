import CGumbo

public struct Attribute {
    public let name: String
    public let value: String

    public init(rawNode: GumboAttribute) {
        self.name = String(cString: rawNode.name)
        self.value = String(cString: rawNode.value)
    }
}

extension Attribute {
    public var valuesSeparatedByWhiteSpaces: [String] {
        get {
            // https://www.w3.org/TR/html5/infrastructure.html#space-character
            // The space characters, for the purposes of this specification,
            // are U+0020 SPACE, "tab" (U+0009), "LF" (U+000A), "FF" (U+000C),
            // and "CR" (U+000D).
            let chunks = self.value.characters.split { c in
                switch c {
                case Character(UnicodeScalar(0x20)):
                    return true
                case Character(UnicodeScalar(0x09)):
                    return true
                case Character(UnicodeScalar(0x0a)):
                    return true
                case Character(UnicodeScalar(0x0c)):
                    return true
                case Character(UnicodeScalar(0x0d)):
                    return true
                default:
                    return false
                }
            }
            return chunks.map(String.init)
        }
    }
}

extension Collection where Iterator.Element == Attribute {
    public subscript(key: String) -> Attribute? {
        return self.first { $0.name == key }
    }
}
