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
    func draw(_ device: MTLDevice, _ encoder: MTLRenderCommandEncoder);
}

