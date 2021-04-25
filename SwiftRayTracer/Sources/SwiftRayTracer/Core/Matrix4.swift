import simd

public typealias Matrix4 = simd_double4x4

// MARK: Approximate floating point comparison
extension Matrix4 {
    public func isApproaximatelyEqual(to other: Self) -> Bool {
        if self == other { return true }
        
        return self.columns.0.isApproaximatelyEqual(to: other.columns.0) &&
            self.columns.1.isApproaximatelyEqual(to: other.columns.1) &&
            self.columns.2.isApproaximatelyEqual(to: other.columns.2) &&
            self.columns.3.isApproaximatelyEqual(to: other.columns.3)
    }
}

extension Matrix4 {
    public static var identity: Matrix4 {
        return matrix_identity_double4x4
    }
}

// MARK: Mathematic operations
extension Matrix4 {
    public static func * (lhs: Self, rhs: Self) -> Self {
        return matrix_multiply(lhs, rhs)
    }
    
    public static func * (lhs: Self, rhs: Tuple) -> Tuple {
        return matrix_multiply(lhs, rhs)
    }
}
