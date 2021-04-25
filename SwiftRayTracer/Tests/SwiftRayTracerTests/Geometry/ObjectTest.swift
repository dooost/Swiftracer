import XCTest
import SwiftRayTracer

final class ObjectTest: XCTestCase {
    private var receivedLocalRayOnLocalUnsortedIntersect: Ray?
    
    override func setUp() {
        receivedLocalRayOnLocalUnsortedIntersect = nil
    }
    
    func testIntersectingScaledObject() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let object = ObjectMock()
        object.delegate = self
        object.transformation = Transformation.scaling(2, 2, 2)
        
        let _ = object.intersect(ray)
        
        guard let localRay = receivedLocalRayOnLocalUnsortedIntersect else {
            XCTFail("localUnsortedIntersect was not called")
            return
        }
        AssertApproximatelyEqual(localRay.origin, Tuple(pointWith: 0, 0, -2.5))
        AssertApproximatelyEqual(localRay.direction, Tuple(vectorWith: 0, 0, 0.5))
    }
    
    func testIntersectingTranslatedObject() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let object = ObjectMock()
        object.delegate = self
        object.transformation = Transformation.translation(5, 0, 0)

        let _ = object.intersect(ray)
        
        guard let localRay = receivedLocalRayOnLocalUnsortedIntersect else {
            XCTFail("localUnsortedIntersect was not called")
            return
        }
        AssertApproximatelyEqual(localRay.origin, Tuple(pointWith: -5, 0, -5))
        AssertApproximatelyEqual(localRay.direction, Tuple(vectorWith: 0, 0, 1))
    }
    
    
    func testNormalIsNormalized() {
        let object = ObjectMock()
        let point = Tuple(pointWith: sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3)
        let normal = object.normal(at: point)
        AssertApproximatelyEqual(normal, normal.normalized)
    }
    
    func testNormalOnTransformedSphere() {
        // Translation
        var object = ObjectMock()
        object.transformation = Transformation.translation(0, 1, 0)
        var point = Tuple(pointWith: 0, 1.70711, -0.70711)
        var normal = object.normal(at: point)
        AssertApproximatelyEqual(normal, Tuple(vectorWith: 0, 0.70711, -0.70711))
        
        // Scaling and rotation
        object = ObjectMock()
        object.transformation = Transformation.scaling(1, 0.5, 1) * Transformation.rotation(z: .pi / 5)
        point = Tuple(pointWith: 0, sqrt(2) / 2, -sqrt(2) / 2)
        normal = object.normal(at: point)
        AssertApproximatelyEqual(normal, Tuple(vectorWith: 0, 0.97014, -0.24254))
    }
}

extension ObjectTest: ObjectMockDelegate {
    func didCallLocalUnsortedIntersect(with localRay: Ray) {
        receivedLocalRayOnLocalUnsortedIntersect = localRay
    }
}
