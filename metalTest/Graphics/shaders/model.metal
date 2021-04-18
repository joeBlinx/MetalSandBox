//
//  model.metal
//  metalTest
//
//  Created by techsoft3d on 18/04/2021.
//

#include <metal_stdlib>
#include "shader_definitions.h"
using namespace metal;


struct VertexIn{
    float3 pos [[attribute (0)]];
    float3 normal [[attribute (1)]];
    float2 texCoord [[attribute (2)]];
};

struct VertexOut{
    float4 pos [[ position ]];
    float3 normal;
    float2 texCoord;
    float3 modelPos;
};


vertex VertexOut mainVertexShader(const VertexIn in[[stage_in]],
                                  const device UniformBuffer &uni [[buffer(1)]],
                                  const device CameraBuffer &camera [[buffer(2)]]
                                  ){
    return {
        camera.vp * uni.model * float4(in.pos, 1),
        normalize(uni.normalMatrix * in.normal),
        in.texCoord,
        float3(uni.model*float4(in.pos, 1))
    };
}

fragment float4 mainFragmentShader(const VertexOut in[[stage_in]] ,
                                   sampler sampler2d[[ sampler(0) ]],
                                   texture2d<float> texture [[ texture(0) ]],
                                   const device MaterialBuffer& material [[ buffer(0) ]],
                                   const device float3& lightPos [[ buffer (2)]]
                                  ){
    float4 color;
    if(material.useTexture){
        color = texture.sample(sampler2d, float2(in.texCoord.x, -in.texCoord.y));
    }else{
        color = float4(material.color, 1);
    }
    auto const ambient = 0.4;
    auto const normal = normalize(in.normal);
    auto const lightDir = normalize(lightPos - in.modelPos);
    auto const diffuse = max(dot(normal, lightDir), 0.f);
    return float4(float3(color)*(diffuse+ambient), color.a);
}
