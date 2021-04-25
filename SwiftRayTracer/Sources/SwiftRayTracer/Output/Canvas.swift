import Darwin

public class Canvas {
    public private(set) var pixelMap: [[Color]]
    
    private let ppmMagicNumber = "P3"
    private let ppmMaxColorValue = 255
    
    public var width: Int {
        pixelMap.count
    }
    
    public var height: Int {
        pixelMap.first?.count ?? 0
    }
    
    public init(pixelMap: [[Color]]) {
        self.pixelMap = pixelMap
    }
    
    public convenience init(x: Int, y: Int) {
        let pixelMap = Array(repeating: Array(repeating: Color(0, 0, 0), count: y), count: x)
        self.init(pixelMap: pixelMap)
    }
    
    public func getPixel(at x: Int, _ y: Int) -> Color {
        guard x > 0, y > 0, x < width, y < height else { return Color(0, 0, 0) }
        
        return pixelMap[x][y]
    }
    
    public func setPixel(_ pixel: Color, at x: Int, _ y: Int) {
        guard x >= 0, y >= 0, x < width, y < height else { return }
        
        pixelMap[x][y] = pixel
    }
}

// MARK: PPM File data
extension Canvas {
    public func createPPMData() -> String {
        let header = """
        \(ppmMagicNumber)
        \(width) \(height)
        \(ppmMaxColorValue)
        """
        
        var payloadLines: [String] = []
        for y in 0..<height {
            for x in 0..<width {
                let pixelComponents = [pixelMap[x][y].red,
                                       pixelMap[x][y].green,
                                       pixelMap[x][y].blue]
                for (colorIndex, component) in pixelComponents.enumerated() {
                    var limitedComponent = component
                    if component < 0 {
                        limitedComponent = 0
                    } else if component > 1 {
                        limitedComponent = 1
                    }
                    let component8Bit: Int = Int(ceil(limitedComponent * Double(ppmMaxColorValue)))
                    let componentString = String(component8Bit)
                    
                    // Start on a new line for each new row
                    if x == 0, colorIndex == 0 {
                        payloadLines.append(componentString)
                        continue
                    }
                    
                    // If appending the new component to last line would put it over 70 chars, start on a new line;
                    // other wise add it with a space spearator to last line
                    if let lastLine = payloadLines.last {
                        if lastLine.count + componentString.count + 1 >= 70 {
                            payloadLines.append(componentString)
                        } else {
                            payloadLines[payloadLines.count - 1].append(" \(componentString)")
                        }
                    }
                }
            }
        }
        
        let payload = payloadLines.joined(separator: "\n")
        return header + "\n" + payload + "\n"
    }
}
