//
//  sampler.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//

import Metal
func createLinearSampler(device: MTLDevice) -> MTLSamplerState{
    
    let descriptor = MTLSamplerDescriptor()
    descriptor.minFilter = .linear
    descriptor.magFilter = .linear
    descriptor.label = "linear"
    descriptor.rAddressMode = .repeat
    descriptor.sAddressMode = .repeat
    descriptor.tAddressMode = .repeat
    return device.makeSamplerState(descriptor: descriptor)!
    
}
