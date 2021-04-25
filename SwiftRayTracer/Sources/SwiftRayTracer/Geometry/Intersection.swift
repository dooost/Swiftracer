public class Intersection {
    public let t: Double
    public let object: Object
    
    public init(t: Double, object: Object) {
        self.t = t
        self.object = object
    }
    
    public func prepareComputations(for ray: Ray) -> Computations {
        let point = ray.position(at: t)
        let eyeVector = -ray.direction
        
        var normalVector = object.normal(at: point)
        var isInside = false
        if (normalVector .* eyeVector) < 0 {
            isInside = true
            normalVector = -normalVector
        }
        let overPoint = point + normalVector * Double.epsilon
        
        return Computations(t: t,
                            object: object,
                            point: point,
                            overPoint: overPoint,
                            eyeVector: eyeVector,
                            normalVector: normalVector,
                            isInside: isInside)
    }
}

extension Intersection {
    public struct Computations {
        public let t: Double
        public let object: Object
        public let point: Tuple
        public let overPoint: Tuple
        public let eyeVector: Tuple
        public let normalVector: Tuple
        public let isInside: Bool
        
        public init(t: Double, object: Object, point: Tuple, overPoint: Tuple, eyeVector: Tuple, normalVector: Tuple, isInside: Bool) {
            self.t = t
            self.object = object
            self.point = point
            self.overPoint = overPoint
            self.eyeVector = eyeVector
            self.normalVector = normalVector
            self.isInside = isInside
        }
    }
}
