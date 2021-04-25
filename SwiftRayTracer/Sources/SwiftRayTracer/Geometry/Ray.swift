public struct Ray {
    public let origin: Tuple
    public let direction: Tuple
    
    public init(origin: Tuple, direction: Tuple) {
        self.origin = origin
        self.direction = direction
    }
    
    public func position(at t: Double) -> Tuple {
        return origin + direction * t
    }
    
    public func transform(by matrix: Matrix4) -> Ray {
        return Ray(origin: matrix * self.origin, direction: matrix * self.direction)
    }
}
