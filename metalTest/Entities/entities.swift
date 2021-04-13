//
//  entities.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//
import SGLMath
import MetalKit

class Entity{
    static let entitiesModel:[String: ([Vertex], [UInt32])] =
    [
        "cube" : cubeVertices(),
        "plane" : planeVertices()
    ]
    private var model: mat4 = mat4(1.0)
    private let buffer: VertexBuffer
    
    init(device: MTLDevice, model: String){
        buffer = VertexBuffer.init(device, model: Entity.entitiesModel[model]!)
    }
    init(_ src: Entity){
        model = src.model;
        buffer = src.buffer;
    }
}

extension Entity{
    
   
    func getDrawings() -> (MTLBuffer, Indices){
        return (buffer.buffer, buffer.indices)
    }
    func getModel() -> mat4{
        model
    }
    
    func move(_ v: vec3){
        model = SGLMath.translate(model, v)
    }
    func rotate(_ v:vec3, angle: Float){
        model = SGLMath.rotate(model, angle, v)
    }
    func scale(_ newScale: vec3){
        model = SGLMath.scale(model, newScale)
    }
    func update(){
        model = SGLMath.rotate(model, 0.01, vec3(0.0, 1.0, 0.0))
    }
}
