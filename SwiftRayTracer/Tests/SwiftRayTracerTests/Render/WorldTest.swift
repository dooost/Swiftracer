import XCTest
@testable import SwiftRayTracer

final class WorldTest: XCTestCase {
    func testEmptyInit() {
        let world = World()
        
        XCTAssertNil(world.light)
        XCTAssertEqual(world.objects.count, 0)
    }
    
    func testIntersection() {
        let world = World.default
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        
        let intersections = world.intersect(ray)
        guard intersections.list.count == 4 else {
            XCTFail("Expected 4 intersections")
            return
        }
        AssertApproximatelyEqual(intersections.list[0].t, 4)
        AssertApproximatelyEqual(intersections.list[1].t, 4.5)
        AssertApproximatelyEqual(intersections.list[2].t, 5.5)
        AssertApproximatelyEqual(intersections.list[3].t, 6)
    }
    
    func testShading() {
        let world = World.default
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let object = world.objects[0]
        let intersection = Intersection(t: 4, object: object)
        let computations = intersection.prepareComputations(for: ray)
        let color = world.shade(hit: computations)
        AssertApproximatelyEqual(color, Color(0.38066, 0.47583, 0.2855))
    }
    
    func testShading_FromTheInside() {
        let world = World.default
        world.light = PointLight(position: Tuple(pointWith: 0, 0.25, 0), intensity: Color.white)
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 0), direction: Tuple(vectorWith: 0, 0, 1))
        let object = world.objects[1]
        let intersection = Intersection(t: 0.5, object: object)
        let computations = intersection.prepareComputations(for: ray)
        let color = world.shade(hit: computations)
        AssertApproximatelyEqual(color, Color(0.90498, 0.90498, 0.90498))
    }
    
    func testShading_InShadow() {
        let world = World()
        world.light = PointLight(position: Tuple(pointWith: 0, 0, -10), intensity: .white)
        let firstSphere = Sphere()
        let secondSphere = Sphere()
        secondSphere.transformation = Transformation.translation(0, 0, 10)
        world.addObject(firstSphere)
        world.addObject(secondSphere)
        
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 5), direction: Tuple(vectorWith: 0, 0, 1))
        let intersection = Intersection(t: 4, object: secondSphere)
        let comps = intersection.prepareComputations(for: ray)
        AssertApproximatelyEqual(world.shade(hit: comps), Color(0.1, 0.1, 0.1))
    }
    
    func testColoring_RayMisses() {
        let world = World.default
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 1, 0))
        let color = world.color(for: ray)
        AssertApproximatelyEqual(color, .black)
    }
    
    func testColoring_RayHits() {
        let world = World.default
        let ray = Ray(origin: Tuple(pointWith: 0, 0, -5), direction: Tuple(vectorWith: 0, 0, 1))
        let color = world.color(for: ray)
        AssertApproximatelyEqual(color, Color(0.38066, 0.47583, 0.2855))
    }
    
    func testColoring_IntersectionBehindRay() {
        let world = World.default
        let outer = world.objects[0]
        outer.material.ambient = 1
        let inner = world.objects[1]
        inner.material.ambient = 1
        let ray = Ray(origin: Tuple(pointWith: 0, 0, 0.75), direction: Tuple(vectorWith: 0, 0, -1))
        let color = world.color(for: ray)
        AssertApproximatelyEqual(color, inner.material.color)
    }
    
    func testIsPointShadowed_NothingBetweenPointAndLight() {
        let world = World.default
        let point = Tuple(pointWith: 0, 10, 0)
        XCTAssertEqual(world.isPointShadowed(point), false)
    }
    
    func testIsPointShadowed_ObjectBetweenPointAndLight() {
        let world = World.default
        let point = Tuple(pointWith: 10, -10, 10)
        XCTAssertEqual(world.isPointShadowed(point), true)
    }
    
    func testIsPointShadowed_ObjectBehindPoint() {
        let world = World.default
        let point = Tuple(pointWith: -2, 2, -2)
        XCTAssertEqual(world.isPointShadowed(point), false)
    }
}
