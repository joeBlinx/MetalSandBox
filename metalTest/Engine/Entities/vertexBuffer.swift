//
//  buffer.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//
import Metal
import MetalKit

struct Indices{
    let offset: Int
    let count: Int
}
class VertexBuffer{
    
    let buffer : MTLBuffer
    let indices: Indices
    
    init<T>(_ device: MTLDevice, model: ([T], [UInt32])) {
        let (vertices, indices) = model
        self.indices = Indices(offset: vertices.count * MemoryLayout<T>.stride, count: indices.count)
        let indicesBytesSize = indices.count * MemoryLayout<UInt32>.size
       
        self.buffer = device.makeBuffer(length: self.indices.offset + indicesBytesSize, options: [])!
        memcpy(self.buffer.contents(), vertices, self.indices.offset)
        memcpy(self.buffer.contents() + self.indices.offset, indices, indicesBytesSize)
    }
}

