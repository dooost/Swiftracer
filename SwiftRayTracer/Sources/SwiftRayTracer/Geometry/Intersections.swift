public struct Intersections {
    public let list: [Intersection]
    
    public init(_ list: [Intersection]) {
        self.list = list.sorted { $0.t < $1.t }
    }
    
    public func hit() -> Intersection? {
        return list.first { $0.t >= 0 }
    }
}
