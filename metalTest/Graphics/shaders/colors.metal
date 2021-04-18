//
//  File.metal
//  metalTest
//
//  Created by techsoft3d on 11/04/2021.
//

#include <metal_stdlib>
#include "shader_definitions.h"
using namespace metal;
struct VertexColorOut {
    float4 color;
    float4 pos [[position]];
    float2 texCoord;
    float3 positionWorldSpace;
};


struct ColorVertexIn{
    float4 color [[attribute(0)]];
    float3 pos [[attribute(1)]];
    float2 texCoord [[attribute(2)]];
};


vertex VertexColorOut vertexShader(const ColorVertexIn vertexArray [[ stage_in ]],
                              const device UniformBuffer &uni [[buffer(1)]],
                              const device CameraBuffer &camera [[buffer(2)]]){
    
    auto vertex_in = vertexArray;
    
    return {vertex_in.color,
        camera.vp * uni.model * float4(vertex_in.pos, 1),
        vertex_in.texCoord,
        float3(uni.model * float4(vertex_in.pos, 1))
    };
    
}

fragment float4 fragmentShader(VertexColorOut interpolated [[ stage_in ]],
                               sampler sampler2d[[ sampler(0) ]],
                               texture2d<float> texture [[ texture(0) ]],
                               const device MaterialBuffer& material [[ buffer(0) ]],
                               texturecube<float> textureCube [[ texture(1) ]]){
    
    float4 color;
    if(material.useTexture){
        auto texCoord = interpolated.texCoord;
        color = texture.sample(sampler2d, texCoord);
    }else{
        color = float4(material.color, 1);
    }
    return color;
}

fragment float4 environmentMappingFragmentShader(VertexColorOut interpolated [[ stage_in ]],
                               sampler sampler2d[[ sampler(0) ]],
                               const device MaterialBuffer& material [[ buffer(0) ]],
                               const device CamPos& cameraPos [[ buffer (1) ]],
                               texturecube<float> textureCube [[ texture(1) ]]){
    
   
    float3 normal(0, 1, 0);
    float3 I = normalize(interpolated.positionWorldSpace - cameraPos.campos);
    float3 R = reflect(I, normalize(normal));
   
    return textureCube.sample(sampler2d, R);;
}


