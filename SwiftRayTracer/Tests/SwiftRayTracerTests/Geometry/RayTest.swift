import XCTest
import SwiftRayTracer

final class RayTest: XCTestCase {
    func testInit() {
        let origin = Tuple(pointWith: 1, 2, 3)
        let direction = Tuple(vectorWith: 4, 5, 6)
        let ray = Ray(origin: origin, direction: direction)
        
        AssertApproximatelyEqual(ray.origin, origin)
        AssertApproximatelyEqual(ray.direction, direction)
    }
    
    func testPosition() {
        let origin = Tuple(pointWith: 2, 3, 4)
        let direction = Tuple(vectorWith: 1, 0, 0)
        let ray = Ray(origin: origin, direction: direction)
        
        AssertApproximatelyEqual(ray.position(at: 0), origin)
        AssertApproximatelyEqual(ray.position(at: 1), Tuple(pointWith: 3, 3, 4))
        AssertApproximatelyEqual(ray.position(at: -1), Tuple(pointWith: 1, 3, 4))
        AssertApproximatelyEqual(ray.position(at: 2.5), Tuple(pointWith: 4.5, 3, 4))
    }
}
