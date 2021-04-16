//
//  pipelineStateCreator.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
import MetalKit
func createRenderPipelineBasic(device: MTLDevice) -> MTLRenderPipelineState{
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = device.makeDefaultLibrary()
    pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
    pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
    pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
    pipelineDescriptor.vertexDescriptor = Provider.vertexDescriptor.get(device: device, "color")
    
    let result:MTLRenderPipelineState?
    do {
        result = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }catch{
        result = nil
        print("Unable to create render pipeline state")
    }
    return result!
}

func createRenderPipelineSkyBox(device: MTLDevice) -> MTLRenderPipelineState{
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = device.makeDefaultLibrary()
    pipelineDescriptor.vertexFunction = library?.makeFunction(name: "skyboxVertexShader")
    pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "skyboxFragmentShader")
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
    pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
    pipelineDescriptor.vertexDescriptor = Provider.vertexDescriptor.get(device: device, "skybox")
    
    let result:MTLRenderPipelineState?
    do {
        result = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }catch{
        result = nil
        print("Unable to create render pipeline state")
    }
    return result!
}
