//
//  provider.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
struct ProviderImpl<T>{
    let vault:[String: (T?,(MTLDevice)->T)]
    func get(device: MTLDevice, _ name: String) -> T{
        var (stateOpt,  function) = vault[name]!
        if stateOpt == nil {
            stateOpt = function(device)
        }
        
        return stateOpt!
    }
    init(vault: [String: (T?, (MTLDevice)->T)]){
        self.vault = vault
    }
}

struct Provider{
    static let depthState = ProviderImpl<MTLDepthStencilState>(vault: [
        "depth": (MTLDepthStencilState?(nil), createBasicDepthStencilState),
        "createCanvas": (MTLDepthStencilState?(nil), createDepthStencilStateForCreatingCanvas),
        "useCanvas": (MTLDepthStencilState?(nil), createDepthStencilStateForUsingCanvas),
        "skybox": (MTLDepthStencilState?(nil), createDepthStencilForSkyBox)
            ])
}
