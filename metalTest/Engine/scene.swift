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
    private var lights: [Light] = []
    private var entities:[Entity] = []
    let skybox: SkyBox
    
    init(device: MTLDevice){
        entities.append(Entity(device: device, meshModel: "f16"))
        entities[0].setTexture(device: device, textureName: "F16s.bmp")
        entities[0].setMaterial(useTexture: 1)
        //entities[0].scale(vec3(1))
        entities[0].move(vec3(0, 0.5, 0))
      
        let light = Light(device: device)
        light.move(vec3(0, 3, 0))
        light.scale(vec3(0.1))
        
        lights.append(light)
        
        
        plane = Entity(device: device, customModel: "plane", pipelineName: "envMapping")
        plane.scale(vec3(3))
        
        skybox = SkyBox(device: device, singleImage: "skyboxForest.png")
       
    }
}

extension Scene{
    func draw(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        encoder.setFragmentBytes(lights[0].getPos().elements, length: MemoryLayout<vec4>.size, index: 2)
        for light in lights {
            light.draw(device, encoder: encoder)
        }
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
