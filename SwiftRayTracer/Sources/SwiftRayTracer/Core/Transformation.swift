import Darwin

public class Transformation {
    public static func translation(_ x: Double, _ y: Double, _ z: Double) -> Matrix4 {
        let row1 = Tuple(1, 0, 0, x)
        let row2 = Tuple(0, 1, 0, y)
        let row3 = Tuple(0, 0, 1, z)
        let row4 = Tuple(0, 0, 0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func scaling(_ x: Double, _ y: Double, _ z: Double) -> Matrix4 {
        let row1 = Tuple(x, 0, 0, 0)
        let row2 = Tuple(0, y, 0, 0)
        let row3 = Tuple(0, 0, z, 0)
        let row4 = Tuple(0, 0, 0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func rotation(x r: Double) -> Matrix4 {
        let row1 = Tuple(1,      0,       0, 0)
        let row2 = Tuple(0, cos(r), -sin(r), 0)
        let row3 = Tuple(0, sin(r),  cos(r), 0)
        let row4 = Tuple(0,      0,       0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func rotation(y r: Double) -> Matrix4 {
        let row1 = Tuple( cos(r), 0, sin(r), 0)
        let row2 = Tuple(      0, 1,      0, 0)
        let row3 = Tuple(-sin(r), 0, cos(r), 0)
        let row4 = Tuple(      0, 0,      0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func rotation(z r: Double) -> Matrix4 {
        let row1 = Tuple(cos(r), -sin(r), 0, 0)
        let row2 = Tuple(sin(r),  cos(r), 0, 0)
        let row3 = Tuple(     0,       0, 1, 0)
        let row4 = Tuple(     0,       0, 0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func shearing(_ xToY: Double, _ xToZ: Double, _ yToX: Double, _ yToZ: Double, _ zToX: Double, _ zToY: Double) -> Matrix4 {
        let row1 = Tuple(1   , xToY, xToZ, 0)
        let row2 = Tuple(yToX,    1, yToZ, 0)
        let row3 = Tuple(zToX, zToY,    1, 0)
        let row4 = Tuple(   0,    0,    0, 1)
        return Matrix4(rows: [row1, row2, row3, row4])
    }
    
    public static func viewTransform(from eye: Tuple, to point: Tuple, up: Tuple) -> Matrix4 {
        let forward = (point - eye).normalized
        let left = forward ** up.normalized
        let trueUp = left ** forward
        
        let row1 = Tuple(left.x, left.y, left.z, 0)
        let row2 = Tuple(trueUp.x, trueUp.y, trueUp.z, 0)
        let row3 = Tuple(-forward.x, -forward.y, -forward.z, 0)
        let row4 = Tuple(0, 0, 0, 1)
        let orientation = Matrix4(rows: [row1, row2, row3, row4])
        
        return orientation * translation(-eye.x, -eye.y, -eye.z)
    }
}
