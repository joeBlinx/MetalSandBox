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
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState:MTLDepthStencilState
    private let preStencilState: MTLDepthStencilState
    private let postStencilState: MTLDepthStencilState

    private let cube: Entity
    private let plane: Entity
    private let camera = Camera.init()
    
    init?(_ mtk_view:MTKView){
        self.device = mtk_view.device!
        self.command_queue = device.makeCommandQueue()!
        do{
            pipelineState = try Renderer.build_render_pipeline_with(device: device, metalKitView: mtk_view)
        }catch{
            print("Unable to create pipeline state")
            return nil
        }
       
        cube = Entity.init(device: device, model: "cube")
        cube.move(vec3(0, 1.01, 0))
        plane = Entity(device: device, model: "plane")
        plane.scale(vec3(2))
        
        depthStencilState = createBasicDepthStencilState(device, depth: true)
        preStencilState = createDepthStencilStateForCreatingCanvas(device)
        postStencilState = createDepthStencilStateForUsingCanvas(device)
      
    }
  
    func draw(in view:MTKView){
       
        guard let command_buffer = command_queue.makeCommandBuffer() else {return }
        guard let renderpass_descriptor = view.currentRenderPassDescriptor  else {return}
        Renderer.setRenderPassDescriptor(renderpass_descriptor)
        guard let render_encoder = command_buffer.makeRenderCommandEncoder(descriptor: renderpass_descriptor) else {return }
        
        render_encoder.setRenderPipelineState(pipelineState)
        
        render_encoder.setDepthStencilState(self.depthStencilState)
        render_encoder.setVertexBytes(self.camera.getVP().elements, length: MemoryLayout<mat4>.size, index: 2)
        
        cube.draw(encoder: render_encoder)
        render_encoder.setDepthStencilState(preStencilState)
        plane.draw(encoder: render_encoder)
        

        cube.rotate(vec3(0, 0, 1), angle: 3.14159)
        cube.move(vec3(0, 2, 0))
        
        render_encoder.setDepthStencilState(postStencilState)
        cube.draw(encoder: render_encoder)
        render_encoder.endEncoding()
        cube.rotate(vec3(0, 0, 1), angle: 3.14159)
        cube.move(vec3(0, 2, 0))
        
        command_buffer.present(view.currentDrawable!)
        command_buffer.commit()
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    
    }
    class func build_render_pipeline_with(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState{
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        pipelineDescriptor.stencilAttachmentPixelFormat = metalKitView.depthStencilPixelFormat
        
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
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
