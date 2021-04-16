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
    private let plane: Entity
    
    let skybox: SkyBox
    
    private let mesh: ModelMesh
    
    init(device: MTLDevice){
        cube = Entity(device: device, model: "cube")
        cube.setTexture(device: device, textureName: "realCat.jpg")
        cube.setMaterial(useTexture: 1)
        cube.move(vec3(0, 1.1, 0))
        
        plane = Entity(device: device, model: "plane")
        plane.scale(vec3(2))
        
        skybox = SkyBox(device: device, singleImage: "skyboxForest.png")
        mesh = ModelMesh(device: device, modelName: "bunny")
    }
}

extension Scene{
    func drawCube(encoder: MTLRenderCommandEncoder){
        cube.draw(encoder: encoder)
    }
    func drawReflectionCube(encoder: MTLRenderCommandEncoder){
        cube.draw(encoder: encoder, reflectY: true)
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
        cube.update()
    }
}
