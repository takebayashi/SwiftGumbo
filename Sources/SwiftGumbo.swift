import CGumbo

public func parse(html: String) -> DocumentNode? {
    let result =  html.withCString(gumbo_parse)
    if result?.pointee.document != nil {
        return DocumentNode(rawNode: result!.pointee.document.pointee.v.document)
    }
    return nil
}
