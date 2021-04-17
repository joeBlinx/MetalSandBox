//
//  model.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//
import MetalKit
import simd
struct Vertex{
    let pos: vector_float3
    let normals: vector_float3
    let texCoord: vector_float2
};

struct ColorVertex{
    let color: vector_float4
    let pos: vector_float3
    let texCoord: vector_float2
};

struct VertexSkyBox{
    let pos: vector_float3
};

func cubeVertices() -> ([ColorVertex], [UInt32]){
    (
        [ColorVertex(color: [1.0, 0.0, 0.0, 1.0], pos:[-1.0, 1.0, 1.0], texCoord: [0, 1])
        ,ColorVertex(color: [0.0, 1.0, 0.0, 1.0], pos:[-1.0,-1.0, 1.0], texCoord: [0, 0])
        ,ColorVertex(color: [0.0, 0.0, 1.0, 1.0], pos:[ 1.0,-1.0, 1.0], texCoord: [1, 0])
        ,ColorVertex(color: [0.1, 0.6, 0.4, 1.0], pos:[ 1.0, 1.0, 1.0], texCoord: [1, 1])

        ,ColorVertex(color: [0.0, 0.0, 0.0, 1.0], pos:[-1.0, 1.0, -1.0], texCoord: [1, 0])
        ,ColorVertex(color: [1.0, 1.0, 1.0, 1.0], pos:[ 1.0, 1.0, -1.0], texCoord: [0, 0])
        ,ColorVertex(color: [0.0, 1.0, 1.0, 1.0], pos:[-1.0,-1.0, -1.0], texCoord: [1, 1])
        ,ColorVertex(color: [0.1, 0.6, 0.4, 1.0], pos:[ 1.0,-1.0, -1.0], texCoord: [0, 1])],
    
     [ 0,1,2 ,0,2,3,   //Front
       5,7,6 ,4,5,6,   //Back
       
       4,1,6 ,4,1,0,   //Left
       3,2,7 ,3,7,5,   //Right
       
       4,0,3 ,4,3,5,   //Top
       1,6,7 ,1,7,2    //Bot]
     ])
}

func cubeSkyBoxVertices() -> ([VertexSkyBox], [UInt32]) {
    (
    [VertexSkyBox(pos:[-1.0, 1.0, 1.0]),
     VertexSkyBox(pos:[-1.0,-1.0, 1.0]),
     VertexSkyBox(pos:[ 1.0,-1.0, 1.0]),
     VertexSkyBox(pos:[ 1.0, 1.0, 1.0]),
    VertexSkyBox(pos:[-1.0, 1.0, -1.0]),
    VertexSkyBox(pos:[ 1.0, 1.0, -1.0]),
    VertexSkyBox(pos:[-1.0,-1.0, -1.0]),
    VertexSkyBox(pos:[ 1.0,-1.0, -1.0])],
                  
     [ 0,1,2 ,0,2,3,   //Front
       5,7,6 ,4,5,6,   //Back
       
       4,1,6 ,4,1,0,   //Left
       3,2,7 ,3,7,5,   //Right
       
       4,0,3 ,4,3,5,   //Top
       1,6,7 ,1,7,2    //Bot]
     ])
}

func planeVertices() -> ([ColorVertex], [UInt32]){
    let color:vector_float4 = [0.1, 0.5, 0.5, 1]
    return (
        [ColorVertex(color: color, pos: [-1, 0, -1], texCoord: [0, 0]),
         ColorVertex(color: color, pos: [1, 0, -1], texCoord: [0, 1]),
         ColorVertex(color: color, pos: [1, 0, 1], texCoord: [1, 1]),
         ColorVertex(color: color, pos: [-1, 0, 1], texCoord: [1, 0])
        ],
        [0, 1, 2, 0, 2, 3]
    )
}
