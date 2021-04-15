//
//  depthStencilStateCreation.swift
//  metalTest
//
//  Created by techsoft3d on 13/04/2021.
//
import Metal


func createDepthStencilStateForUsingCanvas(_ device: MTLDevice) -> MTLDepthStencilState{
    let stencilDescriptor = MTLStencilDescriptor()
    stencilDescriptor.stencilCompareFunction = MTLCompareFunction.less
    stencilDescriptor.depthStencilPassOperation = MTLStencilOperation.incrementClamp
    stencilDescriptor.depthFailureOperation = MTLStencilOperation.keep
    stencilDescriptor.stencilFailureOperation = .keep
    stencilDescriptor.writeMask = 0xff
    stencilDescriptor.readMask = 0xff
    
    let depthDescriptor = MTLDepthStencilDescriptor()
    depthDescriptor.isDepthWriteEnabled = true
    depthDescriptor.backFaceStencil = stencilDescriptor
    depthDescriptor.frontFaceStencil = stencilDescriptor
    depthDescriptor.depthCompareFunction = .lessEqual
    
    return device.makeDepthStencilState(descriptor: depthDescriptor)!
}
func createDepthStencilStateForCreatingCanvas(_ device: MTLDevice)-> MTLDepthStencilState{
    
    let stencilDescriptor = MTLStencilDescriptor()
    stencilDescriptor.stencilCompareFunction = MTLCompareFunction.always
    stencilDescriptor.depthStencilPassOperation = MTLStencilOperation.incrementClamp
    stencilDescriptor.depthFailureOperation = MTLStencilOperation.incrementClamp
    stencilDescriptor.writeMask = 0xff
    stencilDescriptor.readMask = 0xff
    
    let depthDescriptor = MTLDepthStencilDescriptor()
    depthDescriptor.isDepthWriteEnabled = false
    depthDescriptor.backFaceStencil = stencilDescriptor
    depthDescriptor.frontFaceStencil = stencilDescriptor
    depthDescriptor.depthCompareFunction = .lessEqual
    
    return device.makeDepthStencilState(descriptor: depthDescriptor)!
}
func createBasicDepthStencilState(_ device: MTLDevice) -> MTLDepthStencilState{
    let depthDescriptor = MTLDepthStencilDescriptor()
    depthDescriptor.isDepthWriteEnabled = true
    depthDescriptor.depthCompareFunction = MTLCompareFunction.lessEqual
    return device.makeDepthStencilState(descriptor: depthDescriptor)!
}

