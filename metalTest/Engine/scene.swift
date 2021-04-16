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
    
    private let mesh: ModelMesh
    
    init(device: MTLDevice){
        let cube = Entity(device: device, model: "cube")
        cube.setTexture(device: device, textureName: "realCat.jpg")
        cube.setMaterial(useTexture: 1)
        cube.move(vec3(0, 1.1, 0))
        entities.append(cube)
      
        plane = Entity(device: device, model: "plane")
        plane.scale(vec3(3))
        
        skybox = SkyBox(device: device, singleImage: "skyboxForest.png")
        mesh = ModelMesh(device: device, modelName: "bunny")
    }
}

extension Scene{
    func draw(encoder: MTLRenderCommandEncoder){
        for entity in entities{
            entity.draw(encoder: encoder)
        }
    }
    func drawReflection(encoder: MTLRenderCommandEncoder){
        for entity in entities{
            entity.draw(encoder: encoder, reflectY: true)
        }
    }
   
    func drawPlane(encoder: MTLRenderCommandEncoder){
        plane.draw(encoder: encoder)
    }
    func drawSkybox(encoder: MTLRenderCommandEncoder){
        skybox.draw(encoder: encoder)
    }
    func drawMesh(encoder: MTLRenderCommandEncoder){
        mesh.drawPrimitives(encoder)
    }
    func update(){
        for entity in entities{
            entity.update()
        }
    }
}
