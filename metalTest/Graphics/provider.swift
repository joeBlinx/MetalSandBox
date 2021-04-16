//
//  provider.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal

class pair<T>{
    var value: T? = nil
    var function: (MTLDevice) -> T
    init(function: @escaping (MTLDevice) -> T){
        self.function = function
    }
    
}
struct ProviderImpl<T>{
    let vault:[String: pair<T>]
    func get(device: MTLDevice, _ name: String) -> T{
        let values = vault[name]!
        let function = values.function
        if vault[name]!.value == nil {
            vault[name]!.value = function(device)
        }
        return vault[name]!.value!
    }
    init(vault: [String: pair<T>]){
        self.vault = vault
    }
}

struct Provider{
    static let depthState = ProviderImpl<MTLDepthStencilState>(vault: [
        "depth": pair(function: createBasicDepthStencilState),
        "createCanvas": pair(function: createDepthStencilStateForCreatingCanvas),
        "useCanvas": pair (function: createDepthStencilStateForUsingCanvas),
        "skybox": pair(function: createDepthStencilForSkyBox)
            ])
    
    static let pipelineState = ProviderImpl<MTLRenderPipelineState>(vault: [
        "basic": pair(function: createRenderPipelineBasic),
        "skybox": pair(function: createRenderPipelineSkyBox)
    ])
    
    static let samplerState = ProviderImpl<MTLSamplerState>(vault: [
        "linear": pair(function: createLinearSampler)
    ])
    
    static let vertexDescriptor = ProviderImpl<MTLVertexDescriptor>(vault: [
        "basic" : pair(function: createBasicVertexDescriptor),
        "color" : pair(function: createColorVertexDescriptor),
        "skybox": pair(function: createSkyBoxVertexDescriptor)
    ])
}
