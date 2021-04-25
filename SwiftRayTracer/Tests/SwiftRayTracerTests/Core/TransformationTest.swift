import XCTest
import SwiftRayTracer

final class TransformationTest: XCTestCase {
    func testTranslation() {
        let transform = Transformation.translation(5, -3, 2)
        let p = Tuple(pointWith: -3, 4, 5)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 2, 1, 7))
    }
    
    func testTranslationInverse() {
        let transform = Transformation.translation(5, -3, 2)
        let inverse = transform.inverse
        let p = Tuple(pointWith: -3, 4, 5)
        AssertApproximatelyEqual(inverse * p, Tuple(pointWith: -8, 7, 3))
    }
    
    func testTranslationVector() {
        let transform = Transformation.translation(5, -3, 2)
        let v = Tuple(vectorWith: -3, 4, 5)
        AssertApproximatelyEqual(transform * v, v)
    }
    
    func testScaling() {
        let transform = Transformation.scaling(2, 3, 4)
        let p = Tuple(pointWith: -4, 6, 8)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: -8, 18, 32))
    }
    
    func testScalingInverse() {
        let transform = Transformation.scaling(2, 3, 4)
        let inverse = transform.inverse
        let p = Tuple(pointWith: -4, 6, 8)
        AssertApproximatelyEqual(inverse * p, Tuple(pointWith: -2, 2, 2))
    }
    
    func testScalingNegative() {
        let transform = Transformation.scaling(-1, 1, 1)
        let p = Tuple(pointWith: 2, 3, 4)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: -2, 3, 4))
    }
    
    func testRotationAroundX() {
        let p = Tuple(pointWith: 0, 1, 0)
        let halfQuarter = Transformation.rotation(x: .pi / 4)
        let fullQuarter = Transformation.rotation(x: .pi / 2)
        
        AssertApproximatelyEqual(halfQuarter * p, Tuple(pointWith: 0, sqrt(2) / 2, sqrt(2) / 2))
        AssertApproximatelyEqual(fullQuarter * p, Tuple(pointWith: 0, 0, 1))
    }
    
    func testRotationAroundY() {
        let p = Tuple(pointWith: 0, 0, 1)
        let halfQuarter = Transformation.rotation(y: .pi / 4)
        let fullQuarter = Transformation.rotation(y: .pi / 2)
        
        AssertApproximatelyEqual(halfQuarter * p, Tuple(pointWith: sqrt(2) / 2, 0, sqrt(2) / 2))
        AssertApproximatelyEqual(fullQuarter * p, Tuple(pointWith: 1, 0, 0))
    }
    
    func testRotationAroundZ() {
        let p = Tuple(pointWith: 0, 1, 0)
        let halfQuarter = Transformation.rotation(z: .pi / 4)
        let fullQuarter = Transformation.rotation(z: .pi / 2)
        
        AssertApproximatelyEqual(halfQuarter * p, Tuple(pointWith: -sqrt(2) / 2, sqrt(2) / 2, 0))
        AssertApproximatelyEqual(fullQuarter * p, Tuple(pointWith: -1, 0, 0))
    }
    
    func testShearing() {
        let p = Tuple(pointWith: 2, 3, 4)
        
        var transform = Transformation.shearing(1, 0, 0, 0, 0, 0)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 5, 3, 4))
        
        transform = Transformation.shearing(0, 1, 0, 0, 0, 0)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 6, 3, 4))
        
        transform = Transformation.shearing(0, 0, 1, 0, 0, 0)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 2, 5, 4))
        
        transform = Transformation.shearing(0, 0, 0, 1, 0, 0)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 2, 7, 4))
        
        transform = Transformation.shearing(0, 0, 0, 0, 1, 0)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 2, 3, 6))

        transform = Transformation.shearing(0, 0, 0, 0, 0, 1)
        AssertApproximatelyEqual(transform * p, Tuple(pointWith: 2, 3, 7))
    }
    
    func testChainingTransformations() {
        let p = Tuple(pointWith: 1, 0, 1)
        let A = Transformation.rotation(x: .pi / 2)
        let B = Transformation.scaling(5, 5, 5)
        let C = Transformation.translation(10, 5, 7)
        
        let p2 = A * p
        AssertApproximatelyEqual(p2, Tuple(pointWith: 1, -1, 0))
        
        let p3 = B * p2
        AssertApproximatelyEqual(p3, Tuple(pointWith: 5, -5, 0))
        
        let p4 = C * p3
        AssertApproximatelyEqual(p4, Tuple(pointWith: 15, 0, 7))
        
        let T = C * B * A
        AssertApproximatelyEqual(T * p, Tuple(pointWith: 15, 0, 7))
    }
    
    func testViewTransform_DefaultOrientation() {
        let from = Tuple(pointWith: 0, 0, 0)
        let to = Tuple(pointWith: 0, 0, -1)
        let up = Tuple(vectorWith: 0, 1, 0)
        let transformation = Transformation.viewTransform(from: from, to: to, up: up)
        AssertApproximatelyEqual(transformation, .identity)
    }
    
    func testViewTransform_LookingInPositiveZDirection() {
        let from = Tuple(pointWith: 0, 0, 0)
        let to = Tuple(pointWith: 0, 0, 1)
        let up = Tuple(vectorWith: 0, 1, 0)
        let transformation = Transformation.viewTransform(from: from, to: to, up: up)
        AssertApproximatelyEqual(transformation, Transformation.scaling(-1, 1, -1))
    }
    
    func testViewTransform_MovingTheWorld() {
        let from = Tuple(pointWith: 0, 0, 8)
        let to = Tuple(pointWith: 0, 0, 0)
        let up = Tuple(vectorWith: 0, 1, 0)
        let transformation = Transformation.viewTransform(from: from, to: to, up: up)
        AssertApproximatelyEqual(transformation, Transformation.translation(0, 0, -8))
    }
    
    func testViewTransform_Arbitrary() {
        let from = Tuple(pointWith: 1, 3, 2)
        let to = Tuple(pointWith: 4, -2, 8)
        let up = Tuple(vectorWith: 1, 1, 0)
        let transformation = Transformation.viewTransform(from: from, to: to, up: up)
        
        let row1 = Tuple(-0.50709, 0.50709,  0.67612, -2.36643)
        let row2 = Tuple(0.76772, 0.60609,  0.12122, -2.82843)
        let row3 = Tuple(-0.35857, 0.59761, -0.71714, 0)
        let row4 = Tuple(0, 0, 0, 1)
        let expectedResult = Matrix4(rows: [row1, row2, row3, row4])
        AssertApproximatelyEqual(transformation, expectedResult)
    }
}
