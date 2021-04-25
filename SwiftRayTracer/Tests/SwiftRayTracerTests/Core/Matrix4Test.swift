import XCTest
import SwiftRayTracer

final class Matrix4Test: XCTestCase {
    func testMatrix4Init() {
        let row1 = Tuple(1, 2, 3, 4)
        let row2 = Tuple(5.5, 6.5, 7.5, 8.5)
        let row3 = Tuple(9, 10, 11, 12)
        let row4 = Tuple(13.5, 14.5, 15.5, 16.5)
        let matrix = Matrix4(rows: [row1, row2, row3, row4])
        
        AssertApproximatelyEqual(matrix[0, 0], 1)
        AssertApproximatelyEqual(matrix[3, 0], 4)
        AssertApproximatelyEqual(matrix[0, 1], 5.5)
        AssertApproximatelyEqual(matrix[2, 1], 7.5)
        AssertApproximatelyEqual(matrix[2, 2], 11)
        AssertApproximatelyEqual(matrix[0, 3], 13.5)
        AssertApproximatelyEqual(matrix[2, 3], 15.5)
    }
    
    func testComparisonEqual() {
        let row1_1 = Tuple(0.9 - 0.7, 1, 1, 1)
        let row2_1 = Tuple(1, 1, 1, 1)
        let row3_1 = Tuple(1, 1, 1, 1)
        let row4_1 = Tuple(1, 1, 1, 1)
        let matrix1 = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
        
        let row1_2 = Tuple(0.2, 1, 1, 1)
        let row2_2 = Tuple(1, 1, 1, 1)
        let row3_2 = Tuple(1, 1, 1, 1)
        let row4_2 = Tuple(1, 1, 1, 1)
        let matrix2 = Matrix4(rows: [row1_2, row2_2, row3_2, row4_2])
        
        AssertApproximatelyEqual(matrix1, matrix2)
    }
    
    func testComparisonNotEqual() {
        let row1_1 = Tuple(0.9 - 0.7, 1, 1, 1)
        let row2_1 = Tuple(1, 1, 1, 1)
        let row3_1 = Tuple(1, 1, 1, 1)
        let row4_1 = Tuple(1, 1, 1, 1)
        let matrix1 = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
        
        let row1_2 = Tuple(0.2, 1, 1, 1)
        let row2_2 = Tuple(1, 1, 1, 1)
        let row3_2 = Tuple(1, 1, 1, 1)
        let row4_2 = Tuple(1, 1, 1, 2)
        let matrix2 = Matrix4(rows: [row1_2, row2_2, row3_2, row4_2])

        AssertApproximatelyNotEqual(matrix1, matrix2)
    }
    
    func testMultiplicationByMatrix() {
        let row1_1 = Tuple(1, 2, 3, 4)
        let row2_1 = Tuple(5, 6, 7, 8)
        let row3_1 = Tuple(9, 8, 7, 6)
        let row4_1 = Tuple(5, 4, 3, 2)
        let matrix1 = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
        
        let row1_2 = Tuple(-2, 1, 2, 3)
        let row2_2 = Tuple(3, 2, 1, -1)
        let row3_2 = Tuple(4, 3, 6, 5)
        let row4_2 = Tuple(1, 2, 7, 8)
        let matrix2 = Matrix4(rows: [row1_2, row2_2, row3_2, row4_2])
        
        let row1_3 = Tuple(20, 22, 50, 48)
        let row2_3 = Tuple(44, 54, 114, 108)
        let row3_3 = Tuple(40, 58, 110, 102)
        let row4_3 = Tuple(16, 26, 46, 42)
        let matrix3 = Matrix4(rows: [row1_3, row2_3, row3_3, row4_3])
        
        AssertApproximatelyEqual(matrix1 * matrix2, matrix3)
    }
    
    func testMultiplicationByVector() {
        let row1_1 = Tuple(1, 2, 3, 4)
        let row2_1 = Tuple(2, 4, 4, 2)
        let row3_1 = Tuple(8, 6, 4, 1)
        let row4_1 = Tuple(0, 0, 0, 1)
        let matrix1 = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
        
        let tuple = Tuple(1, 2, 3, 1)
        
        AssertApproximatelyEqual(matrix1 * tuple, Tuple(18, 24, 33, 1))
    }
    
    func testIdentityMatrixMultiplyMatrix() {
        let row1_1 = Tuple(1, 2, 3, 4)
        let row2_1 = Tuple(2, 4, 4, 2)
        let row3_1 = Tuple(8, 6, 4, 1)
        let row4_1 = Tuple(0, 0, 0, 1)
        let matrix = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
        
        AssertApproximatelyEqual(matrix * Matrix4.identity, matrix)
    }
    
    func testIdentityMatrixMultiplyTuple() {
        let tuple = Tuple(1, 2, 3, 1)
        AssertApproximatelyEqual(Matrix4.identity * tuple, tuple)
    }
    
    func testNotInvertible() {
        let row1_1 = Tuple(-4, 2, -2, -3)
        let row2_1 = Tuple(9, 6, 2, 6)
        let row3_1 = Tuple(0, -5, 1, -5)
        let row4_1 = Tuple(0, 0, 0, 0)
        let matrix = Matrix4(rows: [row1_1, row2_1, row3_1, row4_1])
    }
}
