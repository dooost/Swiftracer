import simd

// Using typealias to get all defined operations painlessly
// Performance of a typealias SIMD seems to be better than a wrapper struct if
// imported from a different module but seems to be the same in the same module
public typealias Tuple = SIMD4<Double>

extension Tuple {
    public enum Kind {
        case vector
        case point
        case unknown
    }
    
    public var kind: Kind {
        switch w {
        case 1.0:
            return .point
        case 0.0:
            return .vector
        default:
            return .unknown
        }
    }

    public init(_ x: Double, _ y: Double, _ z: Double, _ w: Double) {
        self.init(x: x, y: y, z: z, w: w)
    }

    // More Swifty approach instead of factory methods
    public init(pointWith x: Double, _ y: Double, _ z: Double) {
        self.init(x: x, y: y, z: z, w: 1.0)
    }

    public init(vectorWith x: Double, _ y: Double, _ z: Double) {
        self.init(x: x, y: y, z: z, w: 0.0)
    }
}

// MARK: Approximate floating point comparison
extension Tuple {
    public func isApproaximatelyEqual(to other: Self) -> Bool {
        if self == other { return true }
        
        return abs(self - other).max() < 0.0001
    }
}


extension Tuple {
    public var normalized: Self {
        return normalize(self)
    }
    
    public var magnitude: Double {
        return length(self)
    }
}

// Dot product
infix operator .*
// Cross product
infix operator **
extension Tuple {
    public static func .*(lhs: Self, rhs: Self) -> Double {
        return dot(lhs, rhs)
    }

    public static func **(lhs: Self, rhs: Self) -> Self {
        assert(lhs.kind == .vector && rhs.kind == .vector, "Cross product can only be used on vectors")
        
        let lhsSimd3 = lhs[SIMD3(x: 0, y: 1, z: 2)]
        let rhsSimd3 = rhs[SIMD3(x: 0, y: 1, z: 2)]
        
        return self.init(cross(lhsSimd3, rhsSimd3), 0)
    }
}

extension Tuple {
    public func reflect(with normal: Tuple) -> Tuple {
        assert(self.kind == .vector, "Reflection can only be used on vectors")
        assert(normal.kind == .vector, "Normal has to be a vector")
        return self - normal * 2 * (self .* normal)
    }
}
