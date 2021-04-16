//
//  Renderer.swift
//  metalTest
//
//  Created by techsoft3d on 11/04/2021.
//

import Metal
import MetalKit
import SGLMath
import simd

class Renderer : NSObject, MTKViewDelegate{
    
    private var device: MTLDevice
    private var command_queue: MTLCommandQueue
    
    private let sampler:MTLSamplerState!
    private let camera:Camera
    
    private let scene:Scene
    
    
    init(_ mtk_view:MTKView){
        self.device = mtk_view.device!
        self.command_queue = device.makeCommandQueue()!
        
        scene = Scene(device: device)
        let viewSize = mtk_view.drawableSize
        camera = Camera(viewWidth: Float(viewSize.width), viewHeight: Float(viewSize.height))
        sampler = createLinearSampler(device: device)
      
    }
  
    func draw(in view:MTKView){
        scene.update()
        camera.update()
        guard let command_buffer = command_queue.makeCommandBuffer() else {return }
        guard let renderpass_descriptor = view.currentRenderPassDescriptor  else {return}
        Renderer.setRenderPassDescriptor(renderpass_descriptor)
        guard let render_encoder = command_buffer.makeRenderCommandEncoder(descriptor: renderpass_descriptor) else {return }
        
        
        render_encoder.setDepthStencilState(Provider.depthState.get(device:device, "skybox"))
        render_encoder.setRenderPipelineState(Provider.pipelineState.get(device:device, "skybox"))
        render_encoder.setVertexBytes(self.camera.getVPSkyBox().elements, length: MemoryLayout<mat4>.size, index: 1)
        render_encoder.setFragmentSamplerState(sampler, index: 0)
        scene.drawSkybox(encoder: render_encoder)
        
        render_encoder.setRenderPipelineState(Provider.pipelineState.get(device:device, "basic"))
        
        render_encoder.setDepthStencilState(Provider.depthState.get(device: device, "depth"))
        render_encoder.setVertexBytes(self.camera.getVP().elements, length: MemoryLayout<mat4>.size, index: 2)
        render_encoder.setFragmentTexture(scene.skybox.texture, index: 1)
        render_encoder.setFragmentSamplerState(sampler, index: 0)
        render_encoder.setFragmentBytes(camera.getPos().elements, length: MemoryLayout<vec4>.size, index: 1)
       
        scene.drawCube(encoder: render_encoder)
        
        render_encoder.setDepthStencilState(Provider.depthState.get(device: device, "createCanvas"))

        scene.drawPlane(encoder: render_encoder)
        
        render_encoder.setDepthStencilState(Provider.depthState.get(device: device, "useCanvas"))
    
        scene.drawReflectionCube(encoder: render_encoder)
        render_encoder.endEncoding()
        
        command_buffer.present(view.currentDrawable!)
        command_buffer.commit()
        
    }
    func viewResize(width: Float, height: Float){
        camera.viewResize(viewWidth: width, viewHeight: height)
    }
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    
    }
    
}

extension Renderer {
    private class func setRenderPassDescriptor(_ renderpassDescriptor:MTLRenderPassDescriptor){
        renderpassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1)
        renderpassDescriptor.colorAttachments[0].loadAction = .clear;
        renderpassDescriptor.depthAttachment.clearDepth = 1.0
        renderpassDescriptor.depthAttachment.loadAction = .clear
        renderpassDescriptor.stencilAttachment.clearStencil = 0
        renderpassDescriptor.stencilAttachment.loadAction = .clear
    }
    
    
}
