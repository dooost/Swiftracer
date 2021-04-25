public protocol Light: AnyObject {
    var position: Tuple { get }
    var intensity: Color { get }
}

public class PointLight: Light {
    public let position: Tuple
    public let intensity: Color
    
    public init(position: Tuple, intensity: Color) {
        self.position = position
        self.intensity = intensity
    }
}
