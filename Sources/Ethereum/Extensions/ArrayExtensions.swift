public extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }

    func paddedLeft(to length: Int, with element: Element) -> [Element] {
        Array(repeating: element, count: Swift.max(0, length - count)) + self
    }
}
