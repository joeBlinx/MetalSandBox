//
//  skybox.metal
//  metalTest
//
//  Created by techsoft3d on 17/04/2021.
//

#include <metal_stdlib>
#include "shader_definitions.h"
using namespace metal;


struct VertexSkyBoxIn{
    float3 pos [[ attribute (0) ]];
};

struct VertexSkyBoxOut{
    float4 pos [[position]];
    float3 texCoord;
};
vertex VertexSkyBoxOut skyboxVertexShader(const VertexSkyBoxIn vertexArray [[stage_in]],
                              const device CameraBuffer &camera [[buffer(1)]]){
    
    auto vertex_in = vertexArray;
    
    return VertexSkyBoxOut{camera.vp * float4(vertex_in.pos, 1),
        vertex_in.pos.xyz};
    
}


fragment float4 skyboxFragmentShader(VertexSkyBoxOut interpolated [[ stage_in ]],
                                     sampler sampler2d[[ sampler(0) ]],
                                     texturecube<float> texture [[ texture(0) ]]){
    return texture.sample(sampler2d, interpolated.texCoord);
}

