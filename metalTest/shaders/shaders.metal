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
    float2 texCoord;
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]],
                              const device UniformBuffer &uni [[buffer(1)]],
                              const device CameraBuffer &camera [[buffer(2)]],
                              unsigned int vid [[vertex_id]]){
    
    auto vertex_in = vertexArray[vid];
    
    return VertexOut{vertex_in.color,
        camera.vp * uni.model * float4(vertex_in.pos, 1),
        vertex_in.texCoord};
    
}

fragment float4 fragmentShader(VertexOut interpolated [[ stage_in ]],
                               sampler sampler2d[[ sampler(0) ]],
                               texture2d<float> texture [[ texture(0) ]],
                               const device MaterialBuffer& material [[ buffer(0) ]]){
    
    float4 color;
    if(material.useTexture){
        auto texCoord = interpolated.texCoord;
        if(material.invertUV){
            texCoord.y = 1 - texCoord.y;
        }
        color = texture.sample(sampler2d, texCoord);
    }else{
        color = interpolated.color;
    }
    return color;
}


struct VertexSkyBoxOut{
    float4 pos [[position]];
    float3 texCoord;
};
vertex VertexSkyBoxOut skyboxVertexShader(const device Vertex *vertexArray [[buffer(0)]],
                              const device CameraBuffer &camera [[buffer(1)]],
                              unsigned int vid [[vertex_id]]){
    
    auto vertex_in = vertexArray[vid];
    
    return VertexSkyBoxOut{camera.vp * float4(vertex_in.pos, 1),
        vertex_in.pos.xyz};
    
}


fragment float4 skyboxFragmentShader(VertexSkyBoxOut interpolated [[ stage_in ]],
                                     sampler sampler2d[[ sampler(0) ]],
                                     texturecube<float> texture [[ texture(0) ]]){
    return texture.sample(sampler2d, interpolated.texCoord);
}

