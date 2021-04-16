//
//  provider.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal

struct pair<T>{
    var value: T?
    var function: (MTLDevice) -> T
}
struct ProviderImpl<T>{
    let vault:[String: pair<T>]
    func get(device: MTLDevice, _ name: String) -> T{
        let values = vault[name]!
        var stateOpt = values.value
        let function = values.function
        if stateOpt == nil {
            stateOpt = function(device)
        }
        
        return stateOpt!
    }
    init(vault: [String: pair<T>]){
        self.vault = vault
    }
}

struct Provider{
    static let depthState = ProviderImpl<MTLDepthStencilState>(vault: [
        "depth": pair(value:nil, function: createBasicDepthStencilState),
        "createCanvas": pair(value: nil, function: createDepthStencilStateForCreatingCanvas),
        "useCanvas": pair (value: nil, function: createDepthStencilStateForUsingCanvas),
        "skybox": pair(value: nil, function: createDepthStencilForSkyBox)
            ])
    
    static let pipelineState = ProviderImpl<MTLRenderPipelineState>(vault: [
        "basic": pair(value: nil, function: createRenderPipelineBasic),
        "skybox": pair(value: nil, function: createRenderPipelineSkyBox)
    ])
    
    static let samplerState = ProviderImpl<MTLSamplerState>(vault: [
        "linear": pair(value: nil, function: createLinearSampler)
    ])
}
