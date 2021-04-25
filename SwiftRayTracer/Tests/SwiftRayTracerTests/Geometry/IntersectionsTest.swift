import XCTest
import SwiftRayTracer

final class IntersectionsTest: XCTestCase {
    func testAllPositive() {
        let sphere = Sphere()
        let i1 = Intersection(t: 1, object: sphere)
        let i2 = Intersection(t: 2, object: sphere)
        let intersections = Intersections([i1, i2])
        guard let hit = intersections.hit() else {
            XCTFail("No hit found")
            return
        }
        XCTAssert(hit === i1)
    }
    
    func testSomeNegative() {
        let sphere = Sphere()
        let i1 = Intersection(t: -1, object: sphere)
        let i2 = Intersection(t: 1, object: sphere)
        let intersections = Intersections([i1, i2])
        guard let hit = intersections.hit() else {
            XCTFail("No hit found")
            return
        }
        XCTAssert(hit === i2)
    }
    
    func testAllNegative() {
        let sphere = Sphere()
        let i1 = Intersection(t: -1, object: sphere)
        let i2 = Intersection(t: -2, object: sphere)
        let intersections = Intersections([i1, i2])
        XCTAssertNil(intersections.hit(), "Expected no hit but found one")
    }
    
    func testLeastNonNegIntersection() {
        let sphere = Sphere()
        let i1 = Intersection(t: 5, object: sphere)
        let i2 = Intersection(t: 7, object: sphere)
        let i3 = Intersection(t: -3, object: sphere)
        let i4 = Intersection(t: 2, object: sphere)
        let intersections = Intersections([i1, i2, i3, i4])
        guard let hit = intersections.hit() else {
            XCTFail("No hit found")
            return
        }
        XCTAssert(hit === i4)
    }
}
