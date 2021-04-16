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
    
    private let engine:Engine
    
    init(_ mtk_view:MTKView){
        self.device = mtk_view.device!
        self.command_queue = device.makeCommandQueue()!
        let viewSize = mtk_view.drawableSize
        
        engine = Engine(device: device, viewSize: (Float(viewSize.width), Float(viewSize.height)))
    }
  
    func draw(in view:MTKView){
        engine.handleInput()
        engine.update()
        
        guard let command_buffer = command_queue.makeCommandBuffer() else {return }
        guard let renderpass_descriptor = view.currentRenderPassDescriptor  else {return}
        Renderer.setRenderPassDescriptor(renderpass_descriptor)
        guard let render_encoder = command_buffer.makeRenderCommandEncoder(descriptor: renderpass_descriptor) else {return }
        
        
        engine.draw(device: device, encoder: render_encoder)
       
        render_encoder.endEncoding()
        
        command_buffer.present(view.currentDrawable!)
        command_buffer.commit()
        
    }
    func viewResize(width: Float, height: Float){
        engine.viewResize(width: width, height: height)
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
