extension OpaqueNode {
    public func element(byId id: String) -> ElementNode? {
        let found: [ElementNode] = self.recursiveFlatMap { node in
            if let e = node as? ElementNode {
                if e.id ?? "" == id {
                    return e
                }
            }
            return nil
        }
        return found.first
    }

    public func elements(byClassName className: String) -> [ElementNode] {
        return self.recursiveFlatMap { node in
            if let e = node as? ElementNode {
                if e.classes.contains(className) {
                    return e
                }
            }
            return nil
        }
    }
}
