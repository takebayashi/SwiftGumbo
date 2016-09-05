import CGumbo

public struct GumboVectorIterator: IteratorProtocol {
    public typealias Element = UnsafeMutableRawPointer?

    var datum: UnsafeMutablePointer<UnsafeMutableRawPointer?>?
    var length: Int
    var position: Int

    mutating public func next() -> UnsafeMutableRawPointer?? {
        if position >= length {
            return nil
        }
        if let datum = datum {
            let data = datum.advanced(by: position).pointee
            position += 1
            return data
        }
        return nil
    }
}

extension GumboVector: Sequence {
    public typealias Iterator = GumboVectorIterator

    public func makeIterator() -> GumboVectorIterator {
        return GumboVectorIterator(
            datum: self.data,
            length: Int(self.length),
            position: 0
        )
    }
}
