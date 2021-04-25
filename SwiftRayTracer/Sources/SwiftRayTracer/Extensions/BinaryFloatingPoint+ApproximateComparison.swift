extension BinaryFloatingPoint {
    public static var epsilon: Self { 0.0001 }
    
    public func isApproaximatelyEqual(to other: Self) -> Bool {
        return self == other || abs(self - other) < .epsilon
    }
}
