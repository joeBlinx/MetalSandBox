//
//  engine.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//

import Metal
import SGLMath

class Engine{
    private let scene:Scene
    private let camera:Camera
    
    init(device: MTLDevice, viewSize: (Float, Float)){
        scene = Scene(device: device)
        camera = Camera(viewWidth: viewSize.0, viewHeight: viewSize.1)
    }
    
}

extension Engine{
    func update(){
        scene.update()
    }
    func handleInput(){
        camera.handleInput()
    }
    func viewResize(width: Float, height: Float){
        camera.viewResize(viewWidth: width, viewHeight: height)
    }
    func draw(device: MTLDevice, encoder: MTLRenderCommandEncoder){
        
        let sampler = Provider.samplerState.get(device: device, "linear")
        
        encoder.setDepthStencilState(Provider.depthState.get(device:device, "skybox"))
        encoder.setRenderPipelineState(Provider.pipelineState.get(device:device, "skybox"))
        encoder.setVertexBytes(camera.getVPSkyBox().elements, length: MemoryLayout<mat4>.size, index: 1)
        encoder.setFragmentSamplerState(sampler, index: 0)
        
        scene.drawSkybox(encoder: encoder)
        
        encoder.setRenderPipelineState(Provider.pipelineState.get(device:device, "color"))
        encoder.setDepthStencilState(Provider.depthState.get(device: device, "depth"))
        
        encoder.setVertexBytes(camera.getVP().elements, length: MemoryLayout<mat4>.size, index: 2)
        encoder.setFragmentTexture(scene.skybox.texture, index: 1)
        encoder.setFragmentSamplerState(sampler, index: 0)
        encoder.setFragmentBytes(camera.getPos().elements, length: MemoryLayout<vec4>.size, index: 1)
       
        scene.drawCube(encoder: encoder)
        
        encoder.setDepthStencilState(Provider.depthState.get(device: device, "createCanvas"))

        scene.drawPlane(encoder: encoder)
        
        encoder.setDepthStencilState(Provider.depthState.get(device: device, "useCanvas"))
    
        scene.drawReflectionCube(encoder: encoder)
        
        encoder.setDepthStencilState(Provider.depthState.get(device: device, "depth"))
        encoder.setRenderPipelineState(Provider.pipelineState.get(device: device, "basic"))
        scene.drawMesh(encoder: encoder)
    }
}
