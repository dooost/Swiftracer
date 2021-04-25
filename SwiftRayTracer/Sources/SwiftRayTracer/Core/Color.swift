import simd

// Using typealias here as its performance seems to be more 2x better than a wrapper struct if imported from a different module
public typealias Color = SIMD3<Double>

extension Color {
    public var red: Double {
        get {
            x
        } set {
            x = newValue
        }
    }
    
    public var green: Double {
        get {
            return y
        } set {
            y = newValue
        }
    }
    
    public var blue: Double {
        get {
            return z
        } set {
            z = newValue
        }
    }
    
    public init(_ red: Double, _ green: Double, _ blue: Double) {
        self.init(x: red, y: green, z: blue)
    }
    
    public init(red: Double, green: Double, blue: Double) {
        self.init(x: red, y: green, z: blue)
    }
}

// MARK: Approximate floating point comparison
extension Color {
    public func isApproaximatelyEqual(to other: Self) -> Bool {
        if self == other { return true }
        
        return abs(self - other).max() < 0.0001
    }
}

extension Color {
    public static var black: Self { return Color(0, 0, 0) }
    public static var white: Self { return Color(1, 1, 1) }
}
