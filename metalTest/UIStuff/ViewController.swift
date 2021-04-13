//
//  ViewController.swift
//  metalTest
//
//  Created by techsoft3d on 11/04/2021.
//

import Cocoa
import Metal
import MetalKit


class ViewController: NSViewController {

    var mtk_view:MTKView!
    var renderer: Renderer!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mtk_view_temp = self.view as? MTKView else {
            print("View attached to view controller is not a MTKView");
            return;
        }
        mtk_view = mtk_view_temp
        mtk_view.depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        mtk_view.clearDepth = 1.0
        mtk_view.clearStencil = 0
        
        guard let default_device = MTLCreateSystemDefaultDevice() else{
            print("Metal not supported")
            return
        }
        print("My gpu is: \(default_device)")
        mtk_view.device = default_device
        
        guard let renderer_temp = Renderer(mtk_view) else{
            print("Renderer failed to initialize")
            return
        }
        renderer = renderer_temp
        mtk_view.delegate = renderer
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

