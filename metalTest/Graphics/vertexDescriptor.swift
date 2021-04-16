//
//  vertexDescriptor.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import Metal
func createBasicVertexDescriptor(_:MTLDevice) -> MTLVertexDescriptor {
    let vertexDescriptor = MTLVertexDescriptor()
    
    
    vertexDescriptor.attributes[0].format = .float3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = .float3;
    vertexDescriptor.attributes[1].offset = MemoryLayout<vector_float3>.size;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = .float2;
    vertexDescriptor.attributes[2].offset = MemoryLayout<vector_float3>.size * 2;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
    
    return vertexDescriptor
}

func createColorVertexDescriptor(_:MTLDevice) -> MTLVertexDescriptor {
    let vertexDescriptor = MTLVertexDescriptor()
    
    
    vertexDescriptor.attributes[0].format = .float4;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
    vertexDescriptor.attributes[1].format = .float3;
    vertexDescriptor.attributes[1].offset = MemoryLayout<vector_float4>.size;
    vertexDescriptor.attributes[1].bufferIndex = 0;
    
    vertexDescriptor.attributes[2].format = .float2;
    vertexDescriptor.attributes[2].offset = MemoryLayout<vector_float4>.size + MemoryLayout<vector_float3>.size;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = MemoryLayout<ColorVertex>.stride
    
    return vertexDescriptor
}

func createSkyBoxVertexDescriptor(_:MTLDevice) -> MTLVertexDescriptor {
    let vertexDescriptor = MTLVertexDescriptor()
    
    
    vertexDescriptor.attributes[0].format = .float3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    
  
    vertexDescriptor.layouts[0].stride = MemoryLayout<VertexSkyBox>.stride
    
    return vertexDescriptor
}


