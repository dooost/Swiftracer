import Darwin

public class Camera {
    // Horizontal size in pixels
    public var hsize: Int {
        didSet { recalculateProperties() }
    }
    // Vertical size in pixels
    public var vsize: Int {
        didSet { recalculateProperties() }
    }
    
    public var fieldOfView: Double {
        didSet { recalculateProperties() }
    }
    
    public var transform: Matrix4 = .identity
    
    public private(set) var aspect: Double
    public private(set) var halfWidth: Double
    public private(set) var halfHeight: Double
    public private(set) var pixelSize: Double
    
    private let canvasZ: Double = -1
    private let origin: Tuple = Tuple(pointWith: 0, 0, 0)
    
    public init(hsize: Int, vsize: Int, fieldOfView: Double) {
        self.hsize = hsize
        self.vsize = vsize
        self.fieldOfView = fieldOfView
        
        // Temporarily setting private variables to nan to be able to call self for calculation of properties
        self.aspect = .nan
        self.halfWidth = .nan
        self.halfHeight = .nan
        self.pixelSize = .nan
        
        recalculateProperties()
    }
    
    private func recalculateProperties() {
        let halfView = tan(fieldOfView / 2)
        let aspect = Double(hsize) / Double(vsize)
        
        if aspect >= 1 {
            halfWidth = halfView
            halfHeight = halfView / aspect
        } else {
            halfHeight = halfView
            halfWidth = halfView * aspect
        }
        pixelSize = (halfWidth * 2) / Double(hsize)
    }
}

extension Camera {
    public func createRay(forPixelWithX x: Int, y: Int) -> Ray {
        // The offset from the edge of the canvas to the pixel's center
        let xOffset = (Double(x) + 0.5) * pixelSize
        let yOffset = (Double(y) + 0.5) * pixelSize
        
        // The untransformed coordinates of the pixel in world space.
        // The camera looks toward -z, so +x is to the left.
        let worldX = halfWidth - xOffset
        let worldY = halfHeight - yOffset
        
        let transformedOrigin = transform.inverse * origin
        let transformedPixel = transform.inverse * Tuple(pointWith: worldX, worldY, canvasZ)
        let direction = (transformedPixel - transformedOrigin).normalized
        return Ray(origin: transformedOrigin, direction: direction)
    }
    
    public func render(world: World) -> Canvas {
        let canvas = Canvas(x: hsize, y: vsize)
        
        for y in 0..<vsize {
            for x in 0..<hsize {
                let ray = createRay(forPixelWithX: x, y: y)
                let color = world.color(for: ray)
                canvas.setPixel(color, at: x, y)
            }
        }
        return canvas
    }
}
