import XCTest
import SwiftRayTracer

final class ColorTest: XCTestCase {
    func testColorInit() {
        let color = Color(red: -0.5, green: 0.4, blue: 1.7)
        XCTAssertEqual(color.red, -0.5)
        XCTAssertEqual(color.green, 0.4)
        XCTAssertEqual(color.blue, 1.7)
    }
    
    func testComparison() {
        let color = Color(0.7 + 0.1, 0.9 - 0.7, 0)
        
        // Due to floating point rounding error they should not be equal
        XCTAssertNotEqual(color, Color(0.8, 0.2, 0))
        
        // They should however be approximately equal
        XCTAssert(color.isApproaximatelyEqual(to: Color(0.8, 0.2, 0)))
        
        // AssertApproximatelyEqual should give the same result
        AssertApproximatelyEqual(color, Color(0.8, 0.2, 0))
    }
    
    func testAddition() {
        let firstColor = Color(0.9, 0.6, 0.75)
        let secondColor = Color(0.7, 0.1, 0.25)
        AssertApproximatelyEqual(firstColor + secondColor, Color(1.6, 0.7, 1.0))
    }
    
    func testSubtraction() {
        let firstColor = Color(0.9, 0.6, 0.75)
        let secondColor = Color(0.7, 0.1, 0.25)
        AssertApproximatelyEqual(firstColor - secondColor, Color(0.2, 0.5, 0.5))
    }
    
    func testMultiplication_ByScalar() {
        let color = Color(0.2, 0.3, 0.4)
        AssertApproximatelyEqual(color * 2, Color(0.4, 0.6, 0.8))
    }
    
    func testMultiplication_SchurProduct() {
        let firstColor = Color(1.0, 0.2, 0.4)
        let secondColor = Color(0.9, 1.0, 0.1)
        AssertApproximatelyEqual(firstColor * secondColor, Color(0.9, 0.2, 0.04))
    }
}
