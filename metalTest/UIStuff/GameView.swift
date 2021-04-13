//
//  GameView.swift
//  metalTest
//
//  Created by techsoft3d on 13/04/2021.
//

import MetalKit
class GameView: MTKView{
    var renderer: Renderer!
    
    required init(coder: NSCoder){
        super.init(coder: coder)
        
        depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        clearDepth = 1.0
        clearStencil = 0
        
        guard let default_device = MTLCreateSystemDefaultDevice() else{
            print("Metal not supported")
            return
        }
        print("My gpu is: \(default_device)")
        device = default_device
        
        guard let renderer_temp = Renderer(self) else{
            print("Renderer failed to initialize")
            return
        }
        renderer = renderer_temp
        delegate = renderer
        
    }
}
