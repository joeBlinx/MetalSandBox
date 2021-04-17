//
//  pipelineStateCreator.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
import MetalKit

private func createRenderPipelineDescriptor(device: MTLDevice, vertexShader: String, fragmentShader: String) -> MTLRenderPipelineDescriptor{
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = device.makeDefaultLibrary()
    pipelineDescriptor.vertexFunction = library?.makeFunction(name: vertexShader)
    pipelineDescriptor.fragmentFunction = library?.makeFunction(name: fragmentShader)
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
    pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
    
    return pipelineDescriptor
}
func createRenderPipelineBasic(device: MTLDevice) -> MTLRenderPipelineState{
    let pipelineDescriptor = createRenderPipelineDescriptor(device: device, vertexShader: "vertexShader", fragmentShader: "fragmentShader")
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

func createRenderPipelineEnvMapping(device: MTLDevice) -> MTLRenderPipelineState{
    let pipelineDescriptor = createRenderPipelineDescriptor(device: device, vertexShader: "vertexShader", fragmentShader: "environmentMappingFragmentShader")
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
    let pipelineDescriptor = createRenderPipelineDescriptor(device: device, vertexShader: "skyboxVertexShader", fragmentShader: "skyboxFragmentShader")
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

func createRenderPipelineState(device: MTLDevice)->MTLRenderPipelineState{
    let pipelineDescriptor = createRenderPipelineDescriptor(device: device, vertexShader: "mainVertexShader", fragmentShader: "mainFragmentShader")
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
