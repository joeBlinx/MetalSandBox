//
//  entities.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//
import SGLMath
import MetalKit

class Entity{
    static let model:[String: ([Vertex], [UInt32])] =
    [
        "cube" : cubeVertices(),
        "plane" : planeVertices()
    ]
    private var model: mat4 = mat4(1.0)
    private let buffer: VertexBuffer
    private var material = MaterialBuffer(useTexture: 0, invertUV: 0)
    private var texture: Texture?
    
    init(device: MTLDevice, model: String){
        buffer = VertexBuffer.init(device, model: Entity.model[model]!)
    }
}

extension Entity{
    
    func draw(encoder: MTLRenderCommandEncoder){
        
        let (buffer, indices) = getDrawings()
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        encoder.setVertexBytes(model.elements, length: MemoryLayout<mat4>.size, index: 1)
        encoder.setFragmentBytes(&material, length: MemoryLayout<MaterialBuffer>.size, index: 0)
        if(material.useTexture == 1){
            if let texture = texture{
                encoder.setFragmentTexture(texture.texture, index: 0)
            }else{
                print("useTexture is set to true, but no texture has been load.")
            }
        }
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
    }
    func getDrawings() -> (MTLBuffer, Indices){
        return (buffer.buffer, buffer.indices)
    }
    
    func setTexture(device: MTLDevice, textureName: String){
        texture = Texture(device: device, textureName)
    }
    func setMaterial(useTexture:Int32 = -1, invertUv:Int32 = -1){
        material.useTexture = useTexture != -1 ? useTexture: material.useTexture
        material.invertUV = invertUv != -1 ? invertUv: material.invertUV
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
