//
//  File.metal
//  metalTest
//
//  Created by techsoft3d on 11/04/2021.
//

#include <metal_stdlib>
#include "shader_definitions.h"
using namespace metal;
struct VertexOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]],
                              const device UniformBuffer &uni [[buffer(1)]],
                              const device CameraBuffer &camera [[buffer(2)]],
                              unsigned int vid [[vertex_id]]){
    
    auto vertex_in = vertexArray[vid];
    
    return VertexOut{vertex_in.color, camera.vp * uni.model * float4(vertex_in.pos, 1)};
    
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}


