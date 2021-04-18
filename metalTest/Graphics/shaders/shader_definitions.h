//
//  shader_definitions.h
//  metalTest
//
//  Created by techsoft3d on 11/04/2021.
//

#ifndef shader_definitions_h
#define shader_definitions_h
#include <simd/simd.h>

struct UniformBuffer{
    matrix_float4x4 model;
    matrix_float3x3 normalMatrix;
};
struct CamPos{
    vector_float3 campos;
};
struct CameraBuffer{
    matrix_float4x4 vp;
};

struct MaterialBuffer{
    int useTexture;
    vector_float3 color;
};
#endif /* shader_definitions_h */
