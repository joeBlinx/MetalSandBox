//
//  scene.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//

import Metal
import SGLMath

class Scene{
    private let cube:Entity
    private let reflectionCube: Entity
    private let plane: Entity
    
    init(device: MTLDevice){
        cube = Entity(device: device, model: "cube")
        cube.setTexture(device: device, textureName: "cat.jpg")
        cube.setMaterial(useTexture: 1)
        cube.move(vec3(0, 1, 0))
        
        reflectionCube = Entity(device: device, model: "cube")
        reflectionCube.setMaterial(useTexture: 1, invertUv: 1)
        reflectionCube.setTexture(device: device, textureName: "cat.jpg")
        reflectionCube.move(vec3(0, -1, 0))
        
        plane = Entity(device: device, model: "plane")
        plane.scale(vec3(2))
    }
}

extension Scene{
    func drawCube(encoder: MTLRenderCommandEncoder){
        cube.draw(encoder: encoder)
    }
    func drawReflectionCube(encoder: MTLRenderCommandEncoder){
        reflectionCube.draw(encoder: encoder)
    }
    func drawPlane(encoder: MTLRenderCommandEncoder){
        plane.draw(encoder: encoder)
    }
    func update(){
        cube.update()
        reflectionCube.update()
    }
}