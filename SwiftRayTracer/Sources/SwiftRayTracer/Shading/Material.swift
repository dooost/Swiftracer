import Darwin

public struct Material {
    public var color: Color = .white
    public var ambient = 0.1
    public var diffuse = 0.9
    public var specular = 0.9
    public var shininess = 200.0
    
    public init() {}
    
    public func lighting(with light: Light, at point: Tuple, eyeVector: Tuple, normalVector: Tuple, isShadowed: Bool) -> Color {
        let effectiveColor = color * light.intensity
        
        let ambientContribution: Color = effectiveColor * self.ambient
        var diffuseContribution: Color
        var specularContribution: Color
        
        guard !isShadowed else { return ambientContribution }
        
        let lightVector = (light.position - point).normalized
        let lightDotNormal = lightVector .* normalVector
        if lightDotNormal < 0 {
            diffuseContribution = .black
            specularContribution = .black
        } else {
            diffuseContribution = effectiveColor * diffuse * lightDotNormal
            
            let reflectVector = (-lightVector).reflect(with: normalVector)
            let reflectDotEye = reflectVector .* eyeVector
            if reflectDotEye < 0 {
                specularContribution = .black
            } else {
                let factor = pow(reflectDotEye, shininess)
                specularContribution = light.intensity * specular * factor
            }
        }
        
        return ambientContribution + diffuseContribution + specularContribution
    }
}
