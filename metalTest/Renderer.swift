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
        
        depthStencilState =  Renderer.createDepthDescriptor(self.device, depth: true)
        preStencilState = Renderer.createNoDepthTest(device)
        postStencilState = Renderer.createPostStencil(device)
      
        // we allocate the size of a 4D Matrix of float
    }
    private class func setRenderPassDescriptor(_ renderpassDescriptor:MTLRenderPassDescriptor){
        renderpassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1)
        renderpassDescriptor.colorAttachments[0].loadAction = .clear;
        renderpassDescriptor.depthAttachment.clearDepth = 1.0
        renderpassDescriptor.depthAttachment.loadAction = .clear
        renderpassDescriptor.stencilAttachment.clearStencil = 0
        renderpassDescriptor.stencilAttachment.loadAction = .clear
    }
    
    private class func createPostStencil(_ device: MTLDevice) -> MTLDepthStencilState{
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.stencilCompareFunction = MTLCompareFunction.less
        stencilDescriptor.depthStencilPassOperation = MTLStencilOperation.incrementClamp
        stencilDescriptor.depthFailureOperation = MTLStencilOperation.keep
        stencilDescriptor.stencilFailureOperation = .keep
        stencilDescriptor.writeMask = 0xff
        stencilDescriptor.readMask = 0xff
        
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.isDepthWriteEnabled = true
        depthDescriptor.backFaceStencil = stencilDescriptor
        depthDescriptor.frontFaceStencil = stencilDescriptor
        depthDescriptor.depthCompareFunction = .lessEqual
        
        return device.makeDepthStencilState(descriptor: depthDescriptor)!
    }
    private class func createNoDepthTest(_ device: MTLDevice)-> MTLDepthStencilState{
        
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.stencilCompareFunction = MTLCompareFunction.always
        stencilDescriptor.depthStencilPassOperation = MTLStencilOperation.incrementClamp
        stencilDescriptor.depthFailureOperation = MTLStencilOperation.incrementClamp
        stencilDescriptor.writeMask = 0xff
        stencilDescriptor.readMask = 0xff
        
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.isDepthWriteEnabled = false
        depthDescriptor.backFaceStencil = stencilDescriptor
        depthDescriptor.frontFaceStencil = stencilDescriptor
        depthDescriptor.depthCompareFunction = .lessEqual
        
        return device.makeDepthStencilState(descriptor: depthDescriptor)!
    }
    private class func createDepthDescriptor(_ device: MTLDevice, depth: Bool) -> MTLDepthStencilState{
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.isDepthWriteEnabled = depth
        depthDescriptor.depthCompareFunction = MTLCompareFunction.lessEqual
        return device.makeDepthStencilState(descriptor: depthDescriptor)!
    }
    func draw(in view:MTKView){
        //cube.update()
        guard let command_buffer = command_queue.makeCommandBuffer() else {return }
        guard let renderpass_descriptor = view.currentRenderPassDescriptor  else {return}
        Renderer.setRenderPassDescriptor(renderpass_descriptor)
        guard let render_encoder = command_buffer.makeRenderCommandEncoder(descriptor: renderpass_descriptor) else {return }
        
        let (buffer, indices) = cube.getDrawings()
        render_encoder.setRenderPipelineState(pipelineState)
        
        render_encoder.setDepthStencilState(self.depthStencilState)
        render_encoder.setCullMode(MTLCullMode.none)
        
        render_encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        
        render_encoder.setVertexBytes(cube.getModel().elements, length: MemoryLayout<mat4>.size, index: 1)
       
        render_encoder.setVertexBytes(self.camera.getVP().elements, length: MemoryLayout<mat4>.size, index: 2)
       
        render_encoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
        render_encoder.setDepthStencilState(preStencilState)
        let (bufferPlane, indicesPlane) = plane.getDrawings()
        render_encoder.setVertexBuffer(bufferPlane, offset: 0, index: 0)
        render_encoder.setVertexBytes(plane.getModel().elements, length: MemoryLayout<mat4>.size, index: 1)
        render_encoder.drawIndexedPrimitives(type: .triangle, indexCount: indicesPlane.count, indexType: .uint32, indexBuffer: bufferPlane, indexBufferOffset: indicesPlane.offset)
        
        render_encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        
        cube.rotate(vec3(0, 0, 1), angle: 3.14159)
        cube.move(vec3(0, 2, 0))
        
        render_encoder.setDepthStencilState(postStencilState)
        render_encoder.setVertexBytes(cube.getModel().elements, length: MemoryLayout<mat4>.size, index: 1)
        render_encoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
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
