import XCTest
import SwiftRayTracer

final class BinaryFloatingPoint_ApproximateComparisonTest: XCTestCase {
    func testDoubleError() {
        let first = 0.9
        let second = 0.7
        
        // Due to floating point rounding error they should not be equal
        XCTAssertNotEqual(first - second, 0.2)
        
        // They should however be approximately equal
        XCTAssert((first - second).isApproaximatelyEqual(to: 0.2))
        
        // AssertApproximatelyEqual should give the same result
        AssertApproximatelyEqual(first - second, 0.2)
    }
}
