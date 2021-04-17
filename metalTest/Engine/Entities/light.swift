//
//  light.swift
//  metalTest
//
//  Created by techsoft3d on 17/04/2021.
//
import Metal
import SGLMath
class Light: Entity{
   
    var direction = vec3(0, 1, 0)
    init(device: MTLDevice){
        super.init(device: device, meshModel: "cone")
    }
    
    override func rotate(_ v: vec3, angle: Float) {
        super.rotate(v, angle: angle)
        direction = vec3(vec4(direction, 1) * SGLMath.rotate(mat4(1), angle, v))
        setColor([1, 1, 1])
     
    }
}
