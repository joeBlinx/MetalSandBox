//
//  scene.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//

import Metal
import SGLMath

class Scene{
    private let plane: Entity
    
    private var entities:[Entity] = []
    let skybox: SkyBox
    
    init(device: MTLDevice){
        let cube = Entity(device: device, customModel: "cube")
        cube.setTexture(device: device, textureName: "realCat.jpg")
        cube.setMaterial(useTexture: 1)
        cube.move(vec3(0, 1.1, 0))
        entities.append(cube)
        entities.append(Entity(device: device, meshModel: "bunny"))
        entities[1].setTexture(device: device, textureName: "realCat.jpg")
        entities[1].setMaterial(useTexture: 1)
        entities[1].scale(vec3(1))
        entities[1].move(vec3(0, 0.5, 0))
      
        plane = Entity(device: device, customModel: "plane")
        plane.scale(vec3(3))
        
        skybox = SkyBox(device: device, singleImage: "skyboxForest.png")
       
    }
}

extension Scene{
    func draw(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        for entity in entities{
            entity.draw(device, encoder: encoder)
        }
    }
    func drawReflection(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        for entity in entities{
            entity.draw(device, encoder: encoder, reflectY: true)
        }
    }
   
    func drawPlane(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        plane.draw(device, encoder: encoder)
    }
    
    func drawSkybox(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        skybox.draw(device, encoder: encoder)
    }
    
    func update(){
        for entity in entities{
            entity.update()
        }
    }
}
