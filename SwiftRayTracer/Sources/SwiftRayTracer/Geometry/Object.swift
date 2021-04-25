public protocol Object: AnyObject {
    var transformation: Matrix4 { get set }
    var material: Material { get set }
    
    // Returns a presorted Intersections object using the result of `unsortedIntersect`
    // Doesn't need to be implemented by subclasses.
    func intersect(_ worldRay: Ray) -> Intersections
    
    // Returns an unsorted list of intersections to avoid double sorting, since the
    // Intersections class presorts its content. Converts ray to object space and uses
    // `localUnsortedIntersect` to implement functionality.
    // Doesn't need to be implemented by subclasses.
    func unsortedIntersect(_ worldRay: Ray) -> [Intersection]
    
    // This function implements the core logic of intersection for a ray that has already
    // been converted to object space.
    // Needs to be implemented by subclasses.
    func localUnsortedIntersect(_ localRay: Ray) -> [Intersection]
    
    // Converts point to object space, uses `localNormal` to get normal in object space, and
    // finally converts the result back to object space and returns it.
    // Doesn't need to be implemented by subclasses.
    func normal(at worldPoint: Tuple) -> Tuple
    
    // This function implements the core logic of surface normal for a point that has already
    // been converted to object space. Does not have to be normalized.
    // Needs to be implemented by subclasses.
    func localNormal(at localPoint: Tuple) -> Tuple
}

extension Object {
    public func intersect(_ ray: Ray) -> Intersections {
        let unsortedIntersections = unsortedIntersect(ray)
        return Intersections(unsortedIntersections)
    }
    
    public func unsortedIntersect(_ ray: Ray) -> [Intersection] {
        let tansformedRay = ray.transform(by: transformation.inverse)
        return localUnsortedIntersect(tansformedRay)
    }
    
    public func normal(at worldPoint: Tuple) -> Tuple {
        let objectPoint = transformation.inverse * worldPoint
        let objectNormal = localNormal(at: objectPoint)
        var worldNormal = transformation.inverse.transpose * objectNormal
        worldNormal.w = 0
        return worldNormal.normalized
    }
}
