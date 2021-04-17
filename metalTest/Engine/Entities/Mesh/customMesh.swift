//
//  customMesh.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
class CustomMesh: Mesh{
    
    private let buffer: VertexBuffer
    
    init(device: MTLDevice, model: String){
        buffer = VertexBuffer.init(device, model: Entity.model[model]!)
    }
    func draw(_ device: MTLDevice, _ encoder: MTLRenderCommandEncoder){
        let buffer = self.buffer.buffer
        let indices = self.buffer.indices
        encoder.setRenderPipelineState(Provider.pipelineState.get(device: device, "color"))
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
    }
}


