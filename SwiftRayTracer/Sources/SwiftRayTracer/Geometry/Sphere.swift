import Darwin

public class Sphere: Object {
    public let center: Tuple
    public let radius: Double
    
    public var transformation: Matrix4 = Matrix4.identity
    public var material: Material = Material()
    
    public init() {
        self.center = Tuple(pointWith: 0, 0, 0)
        self.radius = 1.0
    }
    
    public func localUnsortedIntersect(_ localRay: Ray) -> [Intersection] {
        let sphereToRayDistance = localRay.origin - center
        let a = localRay.direction .* localRay.direction
        let b = 2 * (localRay.direction .* sphereToRayDistance)
        let c = (sphereToRayDistance .* sphereToRayDistance) - radius
        
        let d = pow(b, 2) - 4 * a * c
        
        guard d >= 0 else { return [] }
        
        let intersection1 = Intersection(t: (-b - sqrt(d)) / (2 * a), object: self)
        let intersection2 = Intersection(t: (-b + sqrt(d)) / (2 * a), object: self)
        return [intersection1, intersection2]
    }
    
    public func localNormal(at localPoint: Tuple) -> Tuple {
        return localPoint - center
    }
}
