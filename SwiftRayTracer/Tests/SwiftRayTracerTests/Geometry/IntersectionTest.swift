import XCTest
import SwiftRayTracer

final class IntersectionTest: XCTestCase {
    func testPrepareComputations() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersection = Intersection(t: 4, object: sphere)

        let computations = intersection.prepareComputations(for: ray)
        XCTAssert(computations.object === sphere, "Object is not the provided instance")
        XCTAssertEqual(computations.isInside, false)
        AssertApproximatelyEqual(computations.t, intersection.t)
        AssertApproximatelyEqual(computations.point, Tuple(pointWith: 0, 0, -1))
        AssertApproximatelyEqual(computations.eyeVector, Tuple(vectorWith: 0, 0, -1))
        AssertApproximatelyEqual(computations.normalVector, Tuple(vectorWith: 0, 0, -1))
    }
    
    func testPrepareComputations_HitIsInside() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 0), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersection = Intersection(t: 1, object: sphere)

        let computations = intersection.prepareComputations(for: ray)
        XCTAssert(computations.object === sphere, "Object is not the provided instance")
        XCTAssertEqual(computations.isInside, true)
        AssertApproximatelyEqual(computations.t, intersection.t)
        AssertApproximatelyEqual(computations.point, Tuple(pointWith: 0, 0, 1))
        AssertApproximatelyEqual(computations.eyeVector, Tuple(vectorWith: 0, 0, -1))
        // Normal would have been (0, 0, 1) but is reverted
        AssertApproximatelyEqual(computations.normalVector, Tuple(vectorWith: 0, 0, -1))
    }
    
    func testPrepareComputations_OverPointIsSlightlyBumpedUp() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        sphere.transformation = Transformation.translation(0, 0, 1)
        let intersection = Intersection(t: 5, object: sphere)

        let computations = intersection.prepareComputations(for: ray)
        XCTAssertLessThan(computations.overPoint.z, -.epsilon / 2)
        XCTAssertLessThan(computations.overPoint.z, computations.point.z)
    }
}
