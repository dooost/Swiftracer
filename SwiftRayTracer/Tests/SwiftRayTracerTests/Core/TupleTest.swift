import XCTest
import SwiftRayTracer

final class TupleTest: XCTestCase {
    func testKindForPoint() {
        let tuple = Tuple(x: 3.0, y: 5.0, z: 1.0, w: 1.0)
        XCTAssertEqual(tuple.kind, .point)
        XCTAssertEqual(tuple.x, 3.0)
        XCTAssertEqual(tuple.y, 5.0)
        XCTAssertEqual(tuple.z, 1.0)
    }
    
    func testKindForVector() {
        let tuple = Tuple(x: 3.0, y: 5.0, z: 1.0, w: 0.0)
        XCTAssertEqual(tuple.kind, .vector)
        XCTAssertEqual(tuple.x, 3.0)
        XCTAssertEqual(tuple.y, 5.0)
        XCTAssertEqual(tuple.z, 1.0)
    }
    
    func testPointInit() {
        let point = Tuple(pointWith: 3.0, 5.0, 1.0)
        XCTAssertEqual(point, Tuple(x: 3.0, y: 5.0, z: 1.0, w: 1.0))
    }
    
    func testVectorInit() {
        let vector = Tuple(vectorWith: 3.0, 5.0, 1.0)
        XCTAssertEqual(vector, Tuple(x: 3.0, y: 5.0, z: 1.0, w: 0.0))
    }
    
    func testZeroVector() {
        XCTAssertEqual(Tuple.zero, Tuple(vectorWith: 0, 0, 0))
    }
    
    // This is rather important since the tests rely heavily on comparing floating point values,
    // which needs to be approximated, as exact floating point comparison is not reliable.
    func testComparison() {
        let tuple = Tuple(pointWith: 0.7 + 0.1, 0.9 - 0.7, 0)
        
        // Due to floating point rounding error they should not be equal
        XCTAssertNotEqual(tuple, Tuple(pointWith: 0.8, 0.2, 0))
        
        // They should however be approximately equal
        XCTAssert(tuple.isApproaximatelyEqual(to: Tuple(pointWith: 0.8, 0.2, 0)))
        
        // AssertApproximatelyEqual should give the same result
        AssertApproximatelyEqual(tuple, Tuple(pointWith: 0.8, 0.2, 0))
    }
    
    func testAddition() {
        let firstTuple = Tuple(x: 3.0, y: -2.0, z: 5.0, w: 1.0)
        let secondTuple = Tuple(x: -2.0, y: 3.0, z: 1.0, w: 0.0)
        
        AssertApproximatelyEqual(firstTuple + secondTuple, Tuple(x: 1.0, y: 1.0, z: 6.0, w: 1.0))
    }
    
    func testSubtraction_TwoPoints() {
        let firstPoint = Tuple(pointWith: 3.0, 2.0, 1.0)
        let secondPoint = Tuple(pointWith: 5.0, 6.0, 7.0)
        // Should result in a vector
        AssertApproximatelyEqual(firstPoint - secondPoint, Tuple(vectorWith: -2.0, -4.0, -6.0))
    }
    
    func testSubtraction_VectorFromPoint() {
        let point = Tuple(pointWith: 3.0, 2.0, 1.0)
        let vector = Tuple(vectorWith: 5.0, 6.0, 7.0)
        // Should result in a point
        AssertApproximatelyEqual(point - vector, Tuple(pointWith: -2.0, -4.0, -6.0))
    }
    
    func testSubtraction_TwoVector() {
        let firstVector = Tuple(vectorWith: 3.0, 2.0, 1.0)
        let secondVector = Tuple(vectorWith: 5.0, 6.0, 7.0)
        // Should result in a vector
        AssertApproximatelyEqual(firstVector - secondVector, Tuple(vectorWith: -2.0, -4.0, -6.0))
    }
    
    // Subtracting a vector from the zero vector
    func testSubtraction_VectorFromZeroVector() {
        let vector = Tuple(vectorWith: 1, -2, 3)
        AssertApproximatelyEqual(Tuple.zero - vector, Tuple(vectorWith: -1, 2, -3))
    }
    
    func testNegation() {
        let tuple = Tuple(x: 1, y: -2, z: 3, w: -4)
        AssertApproximatelyEqual(-tuple, Tuple(x: -1, y: 2, z: -3, w: 4))
    }
    
    func testScalarMultiplication() {
        let tuple = Tuple(x: 1, y: -2, z: 3, w: -4)
        AssertApproximatelyEqual(tuple * 3.5 , Tuple(3.5, -7, 10.5, -14))
        AssertApproximatelyEqual(tuple * 0.5 , Tuple(0.5, -1, 1.5, -2))
    }
    
    func testScalarDivision() {
        let tuple = Tuple(x: 1, y: -2, z: 3, w: -4)
        AssertApproximatelyEqual(tuple / 2 , Tuple(0.5, -1, 1.5, -2))
    }
    
    func testMagnitude_Vector() {
        // Computing the magnitude of vector(1, 0, 0) = 1
        var vector = Tuple(vectorWith: 1, 0, 0)
        AssertApproximatelyEqual(vector.magnitude, 1)
        
        // Computing the magnitude of vector(0, 1, 0) = 1
        vector = Tuple(vectorWith: 0, 1, 0)
        AssertApproximatelyEqual(vector.magnitude, 1)
        
        // Computing the magnitude of vector(0, 0, 1) = 1
        vector = Tuple(vectorWith: 0, 0, 1)
        AssertApproximatelyEqual(vector.magnitude, 1)
        
        // Computing the magnitude of vector(1, 2, 3) = √14
        vector = Tuple(vectorWith: 1, 2, 3)
        AssertApproximatelyEqual(vector.magnitude, sqrt(14))
        
        // Computing the magnitude of vector(-1, -2, -3) = √14
        vector = Tuple(vectorWith: -1, -2, -3)
        AssertApproximatelyEqual(vector.magnitude, sqrt(14))
    }
    
    func testNormalization() {
        // Normalizing vector(4, 0, 0)
        var vector = Tuple(vectorWith: 4, 0, 0)
        AssertApproximatelyEqual(vector.normalized, Tuple(vectorWith: 1, 0, 0))
        
        // Normalizing vector(1, 2, 3)
        vector = Tuple(vectorWith: 1, 2, 3)
        AssertApproximatelyEqual(vector.normalized, Tuple(vectorWith: (1/sqrt(14)), (2/sqrt(14)), (3/sqrt(14))))
        
        // Magnitude of a normalized vector should be 1
        vector = Tuple(vectorWith: 1, 2, 3)
        AssertApproximatelyEqual(vector.normalized.magnitude, 1)
    }
    
    func testDotProduct() {
        let firstTuple = Tuple(vectorWith: 1, 2, 3)
        let secondTuple = Tuple(vectorWith: 2, 3, 4)
        AssertApproximatelyEqual(firstTuple .* secondTuple, 20)
    }
    
    func testCrossProduct() {
        let firstVector = Tuple(vectorWith: 1, 2, 3)
        let secondVector = Tuple(vectorWith: 2, 3, 4)
        AssertApproximatelyEqual(firstVector ** secondVector, Tuple(vectorWith: -1, 2, -1))
    }
    
    func testReflectVectorAt45Degrees() {
        let vector = Tuple(vectorWith: 1, -1, 0)
        let normal = Tuple(vectorWith: 0, 1, 0)
        AssertApproximatelyEqual(vector.reflect(with: normal), Tuple(vectorWith: 1, 1, 0))
    }
    
    func testReflectVectorOffASlant() {
        let vector = Tuple(vectorWith: 0, -1, 0)
        let normal = Tuple(vectorWith: sqrt(2) / 2, sqrt(2) / 2, 0)
        AssertApproximatelyEqual(vector.reflect(with: normal), Tuple(vectorWith: 1, 0, 0))
    }
}
