import XCTest
import SwiftRayTracer

// MARK: Equality
func AssertApproximatelyEqual<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) {
    XCTAssert(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is not approx equal to \(rhs)")
}

func AssertApproximatelyEqual(_ lhs: Tuple, _ rhs: Tuple) {
    XCTAssert(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is not approx equal to \(rhs)")
}

func AssertApproximatelyEqual(_ lhs: Color, _ rhs: Color) {
    XCTAssert(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is not approx equal to \(rhs)")
}

func AssertApproximatelyEqual(_ lhs: Matrix4, _ rhs: Matrix4) {
    XCTAssert(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is not approx equal to \(rhs)")
}

// MARK: Ineqaulity
func AssertApproximatelyNotEqual<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) {
    XCTAssertFalse(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is approx equal to \(rhs)")
}

func AssertApproximatelyNotEqual(_ lhs: Tuple, _ rhs: Tuple) {
    XCTAssertFalse(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is approx equal to \(rhs)")
}

func AssertApproximatelyNotEqual(_ lhs: Color, _ rhs: Color) {
    XCTAssertFalse(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is approx equal to \(rhs)")
}

func AssertApproximatelyNotEqual(_ lhs: Matrix4, _ rhs: Matrix4) {
    XCTAssertFalse(lhs.isApproaximatelyEqual(to: rhs), "\(lhs) is approx equal to \(rhs)")
}
