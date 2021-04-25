import XCTest
@testable import SwiftRayTracer

final class CameraTest: XCTestCase {
    func testInit() {
        let camera = Camera(hsize: 160, vsize: 120, fieldOfView: .pi / 2)
        
        XCTAssertEqual(camera.hsize, 160)
        XCTAssertEqual(camera.vsize, 120)
        XCTAssertEqual(camera.fieldOfView, .pi / 2)
    }
    
    func testPixelSize() {
        let camera = Camera(hsize: 200, vsize: 125, fieldOfView: .pi / 2)
        
        AssertApproximatelyEqual(camera.pixelSize, 0.01)
        
        camera.hsize = 125
        camera.vsize = 200
        
        AssertApproximatelyEqual(camera.pixelSize, 0.01)
    }
    
    func testCreateRay() {
        let camera = Camera(hsize: 201, vsize: 101, fieldOfView: .pi / 2)
        
        // Constructing a ray through the center of canvas
        var ray = camera.createRay(forPixelWithX: 100, y: 50)
        AssertApproximatelyEqual(ray.origin, Tuple(pointWith: 0, 0, 0))
        AssertApproximatelyEqual(ray.direction, Tuple(vectorWith: 0, 0, -1))
        
        // Constructing a ray through a corner of canvas
        ray = camera.createRay(forPixelWithX: 0, y: 0)
        AssertApproximatelyEqual(ray.origin, Tuple(pointWith: 0, 0, 0))
        AssertApproximatelyEqual(ray.direction, Tuple(vectorWith: 0.66519, 0.33259, -0.66851))

        // Constructing a ray when the camera is transformed
        camera.transform = Transformation.rotation(y: .pi / 4) * Transformation.translation(0, -2, 5)
        ray = camera.createRay(forPixelWithX: 100, y: 50)
        AssertApproximatelyEqual(ray.origin, Tuple(pointWith: 0, 2, -5))
        AssertApproximatelyEqual(ray.direction, Tuple(vectorWith: sqrt(2) / 2, 0, -sqrt(2) / 2))
    }
    
    func testRenderWorld() {
        let world = World.default
        let camera = Camera(hsize: 11, vsize: 11, fieldOfView: .pi / 2)
        
        let from = Tuple(pointWith: 0, 0, -5)
        let to = Tuple(pointWith: 0, 0, 0)
        let up = Tuple(vectorWith: 0, 1, 0)
        camera.transform = Transformation.viewTransform(from: from, to: to, up: up)
        
        let canvas = camera.render(world: world)
        AssertApproximatelyEqual(canvas.getPixel(at: 5, 5), Color(0.38066, 0.47583, 0.2855))
    }
}
