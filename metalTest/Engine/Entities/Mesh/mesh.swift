//
//  mesh.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
import AppKit
import MetalKit

protocol Mesh{
    var pipelineName: String {get}
    func draw(_ device: MTLDevice, _ encoder: MTLRenderCommandEncoder);
}

