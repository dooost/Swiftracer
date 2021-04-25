import XCTest
import SwiftRayTracer

final class MaterialTest: XCTestCase {
    let material = Material()
    let position = Tuple(pointWith: 0, 0, 0)
    
    func testLighting_EyeBetweenLightAndSurface() {
        let eyeVector = Tuple(vectorWith: 0, 0, -1)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 0, -10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: false)
        AssertApproximatelyEqual(result, Color(1.9, 1.9, 1.9))
    }
    
    func testLighting_EyeBetweenLightAndSurfaceWithEyeOffset45Degrees() {
        let eyeVector = Tuple(vectorWith: 0, sqrt(2) / 2, -sqrt(2) / 2)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 0, -10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: false)
        AssertApproximatelyEqual(result, Color(1.0, 1.0, 1.0))
    }
    
    func testLighting_EyeFacingSurfaceWithLightOffset45Degrees() {
        let eyeVector = Tuple(vectorWith: 0, 0, -1)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 10, -10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: false)
        AssertApproximatelyEqual(result, Color(0.7364, 0.7364, 0.7364))
    }
    
    func testLighting_EyeOnThePathOfReflection() {
        let eyeVector = Tuple(vectorWith: 0, -sqrt(2) / 2, -sqrt(2) / 2)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 10, -10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: false)
        AssertApproximatelyEqual(result, Color(1.6364, 1.6364, 1.6364))
    }
    
    func testLighting_LightBehindSurface() {
        let eyeVector = Tuple(vectorWith: 0, -sqrt(2) / 2, -sqrt(2) / 2)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 0, 10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: false)
        AssertApproximatelyEqual(result, Color(0.1, 0.1, 0.1))
    }
    
    func testLighting_IsShadowed() {
        let eyeVector = Tuple(vectorWith: 0, sqrt(2) / 2, -sqrt(2) / 2)
        let normalVector = Tuple(vectorWith: 0, 0, -1)
        let light = PointLight(position: Tuple(pointWith: 0, 0, -10), intensity: Color(1, 1, 1))
        
        let result = material.lighting(with: light, at: position, eyeVector: eyeVector, normalVector: normalVector, isShadowed: true)
        AssertApproximatelyEqual(result, Color(0.1, 0.1, 0.1))
    }
    
}
