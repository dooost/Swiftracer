import XCTest
import SwiftRayTracer

final class SphereTest: XCTestCase {
    func testIntersectSetsObject() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersections = sphere.localUnsortedIntersect(ray)
        guard intersections.count == 2 else {
            XCTFail("Ray does not intersect with sphere")
            return
        }
        
        XCTAssert(intersections[0].object === sphere)
        XCTAssert(intersections[1].object === sphere)
    }
    
    func testIntersectAtTwoPoints() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersections = sphere.localUnsortedIntersect(ray)
        guard intersections.count == 2 else {
            XCTFail("Ray does not intersect with sphere")
            return
        }
        AssertApproximatelyEqual(intersections[0].t, 4)
        AssertApproximatelyEqual(intersections[1].t, 6)
    }
    
    func testIntersectAtTangent() {
        let ray = Ray(origin: Tuple(pointWith: 0, 1, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersections = sphere.localUnsortedIntersect(ray)
        guard intersections.count == 2 else {
            XCTFail("Ray does not intersect with sphere")
            return
        }
        AssertApproximatelyEqual(intersections[0].t, 5)
        AssertApproximatelyEqual(intersections[1].t, 5)
    }
    
    func testNoIntersection() {
        let ray = Ray(origin: Tuple(pointWith: 0, 2, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        XCTAssertEqual(sphere.localUnsortedIntersect(ray).count, 0)
    }
    
    func testIntersectionRayInsideSphere() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 0), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersections = sphere.localUnsortedIntersect(ray)
        guard intersections.count == 2 else {
            XCTFail("Ray does not intersect with sphere")
            return
        }
        AssertApproximatelyEqual(intersections[0].t, -1)
        AssertApproximatelyEqual(intersections[1].t, 1)
    }
    
    func testIntersectionRayBehindSphere() {
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 5), direction: Tuple(vectorWith: 0, 0, 1))
        let sphere = Sphere()
        let intersections = sphere.localUnsortedIntersect(ray)
        guard intersections.count == 2 else {
            XCTFail("Ray does not intersect with sphere")
            return
        }
        AssertApproximatelyEqual(intersections[0].t, -6)
        AssertApproximatelyEqual(intersections[1].t, -4)
    }
    
    func testLocalNormal() {
        // Point on X axis
        var sphere = Sphere()
        var point = Tuple(pointWith: 1, 0, 0)
        var localNormal = sphere.localNormal(at: point)
        AssertApproximatelyEqual(localNormal, Tuple(vectorWith: 1, 0, 0))
        
        // Point on Y axis
        sphere = Sphere()
        point = Tuple(pointWith: 0, 1, 0)
        localNormal = sphere.localNormal(at: point)
        AssertApproximatelyEqual(localNormal, Tuple(vectorWith: 0, 1, 0))
        
        // Point on Z axis
        sphere = Sphere()
        point = Tuple(pointWith: 0, 0, 1)
        localNormal = sphere.localNormal(at: point)
        AssertApproximatelyEqual(localNormal, Tuple(vectorWith: 0, 0, 1))
        
        // Nonaxial point
        sphere = Sphere()
        point = Tuple(pointWith: sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3)
        localNormal = sphere.localNormal(at: point)
        AssertApproximatelyEqual(localNormal, Tuple(vectorWith: sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3))
    }
}
