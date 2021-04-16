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
    float3 positionWorldSpace;
};


struct ColorVertexIn{
    float4 color [[attribute(0)]];
    float3 pos [[attribute(1)]];
    float2 texCoord [[attribute(2)]];
};
vertex VertexOut vertexShader(const ColorVertexIn vertexArray [[ stage_in ]],
                              const device UniformBuffer &uni [[buffer(1)]],
                              const device CameraBuffer &camera [[buffer(2)]]){
    
    auto vertex_in = vertexArray;
    
    return VertexOut{vertex_in.color,
        camera.vp * uni.model * float4(vertex_in.pos, 1),
        vertex_in.texCoord,
        float3(uni.model * float4(vertex_in.pos, 1))
    };
    
}
struct CamPos{
    vector_float3 campos;
};
fragment float4 fragmentShader(VertexOut interpolated [[ stage_in ]],
                               sampler sampler2d[[ sampler(0) ]],
                               texture2d<float> texture [[ texture(0) ]],
                               const device MaterialBuffer& material [[ buffer(0) ]],
                               const device CamPos& cameraPos [[ buffer (1) ]],
                               texturecube<float> textureCube [[ texture(1) ]]){
    
    float4 color;
    if(material.useTexture){
        auto texCoord = interpolated.texCoord;
        if(material.invertUV){
            texCoord.y = 1 - texCoord.y;
        }
        color = texture.sample(sampler2d, texCoord);
    }else{
        float3 normal(0, 1, 0);
        float3 I = normalize(interpolated.positionWorldSpace - cameraPos.campos);
        float3 R = reflect(I, normalize(normal));
        color = textureCube.sample(sampler2d, R);
    }
    return color;
}


struct VertexSkyBoxIn{
    float3 pos [[ attribute (0) ]];
};

struct VertexSkyBoxOut{
    float4 pos [[position]];
    float3 texCoord;
};
vertex VertexSkyBoxOut skyboxVertexShader(const VertexSkyBoxIn vertexArray [[stage_in]],
                              const device CameraBuffer &camera [[buffer(1)]],
                              unsigned int vid [[vertex_id]]){
    
    auto vertex_in = vertexArray;
    
    return VertexSkyBoxOut{camera.vp * float4(vertex_in.pos, 1),
        vertex_in.pos.xyz};
    
}


fragment float4 skyboxFragmentShader(VertexSkyBoxOut interpolated [[ stage_in ]],
                                     sampler sampler2d[[ sampler(0) ]],
                                     texturecube<float> texture [[ texture(0) ]]){
    return texture.sample(sampler2d, interpolated.texCoord);
}

