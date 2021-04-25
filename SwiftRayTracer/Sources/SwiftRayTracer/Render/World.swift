public class World {
    public private(set) var objects: [Object]
    public var light: Light?
    
    public required init(objects: [Object], light: Light?) {
        self.objects = objects
        self.light = light
    }
    
    
    public convenience init() {
        self.init(objects: [], light: nil)
    }
    
    // Adds the object instance to the world, fails silently if object already exists in the world
    public func addObject(_ object: Object) {
        guard !objects.contains(where: { storedObject in storedObject === object }) else {
            return
        }
        objects.append(object)
    }
    
    // Removes the object instance from the world
    public func removeObject(_ object: Object) {
        if let index = objects.firstIndex(where: { storedObject in storedObject === object }) {
            objects.remove(at: index)
        }
    }
    
    public func intersect(_ ray: Ray) -> Intersections {
        var unsortedIntersections: [Intersection] = []
        for object in objects {
            let objectIntersections = object.unsortedIntersect(ray)
            unsortedIntersections.append(contentsOf: objectIntersections)
        }
        return Intersections(unsortedIntersections)
    }
    
    public func shade(hit comps: Intersection.Computations) -> Color {
        guard let light = light else { return .black }
        let isShadowed = isPointShadowed(comps.overPoint)
        return comps.object.material.lighting(with: light,
                                              at: comps.overPoint,
                                              eyeVector: comps.eyeVector,
                                              normalVector: comps.normalVector,
                                              isShadowed: isShadowed)
    }
    
    public func color(for ray: Ray) -> Color {
        guard let hit = intersect(ray).hit() else { return .black }
        
        let comps = hit.prepareComputations(for: ray)
        return shade(hit: comps)
    }
    
    public func isPointShadowed(_ point: Tuple) -> Bool {
        guard let light = light else { return true }
        
        let pointToLightVector = light.position - point
        let distance = pointToLightVector.magnitude
        
        let ray = Ray(origin: point, direction: pointToLightVector.normalized)
        let hit = intersect(ray).hit()
        if let hit = hit, hit.t < distance {
            return true
        }
        return false
    }
}

extension World {
    public static var `default`: Self {
        let light = PointLight(position: Tuple(pointWith: -10, 10, -10), intensity: Color.white)
        
        let s1 = Sphere()
        s1.material.color = Color(0.8, 1.0, 0.6)
        s1.material.diffuse = 0.7
        s1.material.specular = 0.2
        
        let s2 = Sphere()
        s2.transformation = Transformation.scaling(0.5, 0.5, 0.5)
        
        return self.init(objects: [s1, s2], light: light)
    }
}
