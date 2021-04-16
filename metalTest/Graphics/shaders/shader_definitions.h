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
};

struct CameraBuffer{
    matrix_float4x4 vp;
};

struct MaterialBuffer{
    int useTexture;
};
#endif /* shader_definitions_h */
