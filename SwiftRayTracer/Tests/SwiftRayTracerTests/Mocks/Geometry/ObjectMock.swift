import SwiftRayTracer
import Darwin

protocol ObjectMockDelegate: AnyObject {
    func didCallLocalUnsortedIntersect(with localRay: Ray)
}

// Actually a sphere 🤷
final class ObjectMock: Object {
    let center: Tuple
    let radius: Double
    
    weak var delegate: ObjectMockDelegate?
    
    var transformation: Matrix4 = Matrix4.identity
    var material: Material = Material()
    
    init() {
        self.center = Tuple(pointWith: 0, 0, 0)
        self.radius = 1.0
    }
    
    func localUnsortedIntersect(_ localRay: Ray) -> [Intersection] {
        delegate?.didCallLocalUnsortedIntersect(with: localRay)
        return []
    }
    
    func localNormal(at localPoint: Tuple) -> Tuple {
        return localPoint - center
    }
}
