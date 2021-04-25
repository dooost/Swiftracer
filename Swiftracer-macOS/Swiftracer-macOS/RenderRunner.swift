//
//  RenderRunner.swift
//  Swiftracer-macOS
//
//  Created by Prezi on 2021. 03. 09..
//
import Foundation
import SwiftRayTracer

protocol RenderRunnerDelegate: AnyObject {
    func didFinishRunningFirstWorld(error: Error?)
}

extension RenderRunnerDelegate {
    func didFinishRunningFirstWorld(error: Error?) {}
}

class RenderRunner {
    weak var delegate: RenderRunnerDelegate?
    
    func runFirstWorld() {
        let floor = Sphere()
        floor.transformation = Transformation.scaling(10, 0.01, 10)
        floor.material.color = Color(1, 0.9, 0.9)
        floor.material.specular = 0
        
        let leftWall = Sphere()
        leftWall.transformation = Transformation.translation(0, 0, 5) *
            Transformation.rotation(y: -.pi / 4) *
            Transformation.rotation(x: .pi / 2) *
            Transformation.scaling(10, 0.01, 10)
        leftWall.material = floor.material
        
        let rightWall = Sphere()
        rightWall.transformation = Transformation.translation(0, 0, 5) *
            Transformation.rotation(y: .pi / 4) *
            Transformation.rotation(x: .pi / 2) *
            Transformation.scaling(10, 0.01, 10)
        rightWall.material = floor.material
        
        let middleSphere = Sphere()
        middleSphere.transformation = Transformation.translation(-0.5, 1, 0.5)
        middleSphere.material.color = Color(0.3, 1, 0.95)
        middleSphere.material.diffuse = 0.9
        middleSphere.material.specular = 0.2
        middleSphere.material.shininess = 50
        
        let rightSphere = Sphere()
        rightSphere.transformation = Transformation.translation(1.5, 0.5, -0.5) * Transformation.scaling(0.8, 0.5, 0.8)
        rightSphere.material.color = Color(1, 0.3, 0.3)
        rightSphere.material.diffuse = 0.7
        rightSphere.material.specular = 0.8
        rightSphere.material.shininess = 10
        
        let leftSphere = Sphere()
        leftSphere.transformation = Transformation.translation(-1.5, 0.66, -0.75) * Transformation.scaling(0.33, 0.66, 0.33)
        leftSphere.material.color = Color(1, 1, 0.5)
        leftSphere.material.diffuse = 0.7
        leftSphere.material.specular = 0.3
        leftSphere.material.shininess = 100
        
        let light = PointLight(position: Tuple(pointWith: -10, 10, -10),
                               intensity: .white)
        
        let world = World()
        world.light = light
        world.addObject(floor)
        world.addObject(leftWall)
        world.addObject(rightWall)
        world.addObject(middleSphere)
        world.addObject(rightSphere)
        world.addObject(leftSphere)
        
        let camera = Camera(hsize: 640, vsize: 360, fieldOfView: .pi / 3)
        camera.transform = Transformation.viewTransform(from: Tuple(pointWith: 0, 1.5, -5),
                                                        to: Tuple(pointWith: 0, 1, 0),
                                                        up: Tuple(vectorWith: 0, 1, 0))
        
        let renderedCanvas = camera.render(world: world)
        do {
            try createFile(for: renderedCanvas)
            delegate?.didFinishRunningFirstWorld(error: nil)
        } catch let error {
            delegate?.didFinishRunningFirstWorld(error: error)
        }
    }
    
    
    // Chapter 5 ending
    func runSphereOnWall() throws {
        let canvasPixels = 300
        let canvas = Canvas(x: canvasPixels, y: canvasPixels)

        let rayOrigin = Tuple(pointWith: 0, 0, -5)
        let wallZ = 10.0
        let wallSize = 7.0
        let halfOfWallSize = wallSize / 2
        let pixelSize = wallSize / Double(canvasPixels)
        
        let lightPosition = Tuple(pointWith: -10, 10, -10)
        let lightColor = Color.white
        let light = PointLight(position: lightPosition, intensity: lightColor)
        
        let shape = Sphere()
        shape.material.color = Color(0.2, 0.2, 1)
        shape.material.shininess = 50
        shape.material.specular = 0.3
        let scale = Transformation.scaling(0.4, 0.85, 1)
        let shear = Transformation.shearing(0.2, 0, 0, 0, 0, 0)
        let rotate = Transformation.rotation(z: (.pi / 1.6))
//        shape.transformation = rotate * shear * scale
        
        for y in 0..<canvasPixels {
            let worldY = halfOfWallSize - Double(y) * pixelSize
            for x in 0..<canvasPixels {
                let worldX = -halfOfWallSize + Double(x) * pixelSize
                let pointOnWall = Tuple(pointWith: worldX, worldY, wallZ)
                let ray = Ray(origin: rayOrigin, direction: (pointOnWall - rayOrigin).normalized)
                let intersections = shape.intersect(ray)
                let hit = intersections.hit()
                
                if let hit = hit {
                    let point = ray.position(at: hit.t)
                    let normal = hit.object.normal(at: point)
                    let eye = -ray.direction
                    
                    let color = hit.object.material.lighting(with: light, at: point, eyeVector: eye, normalVector: normal, isShadowed: false)
                    
                    canvas.setPixel(color, at: x, y)
                }
            }
        }
        do {
            try createFile(for: canvas)
        } catch { }
    }
    
    private func createFile(for canvas: Canvas) throws {
        let ppmData = canvas.createPPMData()
        try write(ppmData)
    }
    
    private func write(_ string: String) throws {
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at 'HH.mm.ss"
        let timeString = formatter.string(from: currentTime)
        let fileName = "Render \(timeString).ppm"
        let fileUrl = getDownloadsDirectory().appendingPathComponent(fileName)

        try string.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    }
    
    private func getDownloadsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        return paths[0]
    }
}
