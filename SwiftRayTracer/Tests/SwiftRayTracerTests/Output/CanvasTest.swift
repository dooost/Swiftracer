import XCTest
import SwiftRayTracer

final class CanvasTest: XCTestCase {
    func testCanvasInit() {
        let canvas = Canvas(x: 10, y: 20)
        XCTAssertEqual(canvas.width, 10)
        XCTAssertEqual(canvas.height, 20)
    }

    func testPixelGetSet() {
        let canvas = Canvas(x: 10, y: 20)
        let red = Color(1, 0, 0)
        canvas.setPixel(red, at: 9, 19)
        XCTAssertEqual(canvas.getPixel(at: 9, 19), red)
    }
    
    func testPPM_header() {
        let canvas = Canvas(x: 5, y: 3)
        let ppmData = canvas.createPPMData()
        
        // First three lines
        let headerLines = ppmData.components(separatedBy: "\n")[..<3]
        let headerString = headerLines.joined(separator: "\n")
        
        let expectedHeader = """
        P3
        5 3
        255
        """
        
        XCTAssertEqual(headerString,expectedHeader)
    }
    
    func testPPM_pixelData() {
        let canvas = Canvas(x: 5, y: 3)
        let firstColor = Color(1.5, 0, 0)
        let secondColor = Color(0, 0.5, 0)
        let thirdColor = Color(-0.5, 0, 1)
        
        canvas.setPixel(firstColor, at: 0, 0)
        canvas.setPixel(secondColor, at: 2, 1)
        canvas.setPixel(thirdColor, at: 4, 2)
        
        let ppmData = canvas.createPPMData()
        
        // Lines 4 to 6
        let payloadLines = ppmData.components(separatedBy: "\n")[3..<6]
        let payloadString = payloadLines.joined(separator: "\n")
        
        let expectedPayload = """
        255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
        """
        
        XCTAssertEqual(payloadString, expectedPayload)
    }
    
    func testPPM_pixelDataShouldNotExceed70Chars() {
        let canvas = Canvas(x: 10, y: 2)
        let color = Color(1, 0.8, 0.6)
        for x in 0..<10 {
            for y in 0..<2 {
                canvas.setPixel(color, at: x, y)
            }
        }
        
        let ppmData = canvas.createPPMData()
        
        // Lines 4 to 7
        let payloadLines = ppmData.components(separatedBy: "\n")[3..<7]
        let payloadString = payloadLines.joined(separator: "\n")
        
        let expectedPayload = """
        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
        153 255 204 153 255 204 153 255 204 153 255 204 153
        255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
        153 255 204 153 255 204 153 255 204 153 255 204 153
        """
        
        XCTAssertEqual(payloadString, expectedPayload)
    }
    
    func testPPM_shouldTerminateWithNewline() {
        let canvas = Canvas(x: 5, y: 3)
        let ppmData = canvas.createPPMData()
        XCTAssertEqual(ppmData.last, "\n")
    }
}
