//
//  light.swift
//  metalTest
//
//  Created by techsoft3d on 17/04/2021.
//
import Metal
import SGLMath
class Light: Entity{
   
    private var direction = vec3(0, 1, 0)
    init(device: MTLDevice){
        super.init(device: device, meshModel: "sphere")
        setColor([1, 1, 1])
        setTexture(device: device, textureName: "realCat.jpg")
    }
    func getDirection() -> vec3{
        direction
    }
    
    func setDirection(newDirection: vec3){
        let newDirection = normalize(newDirection)
        
        let projXYDirection = vec2(direction)
        let projXYNewDirection = vec2(newDirection)
        
        if projXYDirection != vec2(0) && projXYNewDirection != vec2(0){
            let angleXY = acos(dot(projXYDirection, projXYNewDirection))
            rotate(vec3(0, 0, 1), angle: angleXY)
        }
        
        let projXZDirection = vec2(direction.x, direction.z)
        let projXZNewDirection = vec2(newDirection.x, newDirection.z)
        if projXZDirection != vec2(0) && projXZNewDirection != vec2(0){
            let angleXZ = acos(dot(projXZDirection, projXZNewDirection))
            rotate(vec3(0, 1, 0), angle: angleXZ)
        }
        let projYZDirection = vec2(direction.y, direction.z)
        let projYZNewDirection = vec2(newDirection.y, newDirection.z)
        
        if projYZDirection != vec2(0) && projYZNewDirection != vec2(0){
            let angleYZ = acos(dot(projYZDirection, projYZNewDirection))
            rotate(vec3(1, 0, 0), angle: angleYZ)
        }
        
       

        direction = newDirection
    }
    
    
}
