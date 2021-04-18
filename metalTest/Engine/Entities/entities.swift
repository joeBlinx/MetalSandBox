//
//  entities.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//
import SGLMath
import MetalKit

class Entity{
    static let model:[String: ([ColorVertex], [UInt32])] =
    [
        "cube" : cubeVertices(),
        "plane" : planeVertices(),
    ]
    private var model: mat4 = mat4(1.0)
    private var material = MaterialBuffer(useTexture: 0, color: [1, 0, 1])
    private var texture: Texture?
    private var mesh: Mesh
    private var pos = vec3(0, 0, 0)
    private var size = vec3(1, 1, 1)
    private var rotation = vec3(0, 0, 0)
    
    init(device: MTLDevice, customModel: String, pipelineName: String){
        mesh = CustomMesh(device: device, model: customModel, pipelineName: pipelineName)
    }
    init(device: MTLDevice, meshModel:String){
        mesh = ModelMesh(device: device, modelName: meshModel)
    }
    struct UniformBuffer{
        var model:mat4
        var normalMatrix:mat3
        var pad: vec3 = vec3(0)
    };


    func draw(_ device: MTLDevice, encoder: MTLRenderCommandEncoder, reflectY: Bool = false){
        let model: mat4
        if(reflectY){
            model = SGLMath.scale(mat4(1), vec3(1, -1, 1))*getModel()
        }else{
            model = getModel()
        }
        
        var uni = UniformBuffer(model: model,
                                normalMatrix: mat3(inverse(transpose(model))))
        encoder.setVertexBytes(&uni, length: MemoryLayout<UniformBuffer>.stride, index: 1)
        encoder.setFragmentBytes(&material, length: MemoryLayout<MaterialBuffer>.size, index: 0)
        if let texture = texture{
            encoder.setFragmentTexture(texture.texture, index: 0)
        }
        
        mesh.draw(device, encoder)
    }
    
    private func getModel() -> mat4{
       /* let translationMatrix = SGLMath.translate(mat4(1), pos)
        let scaleMatrix = SGLMath.scale(mat4(1), size)
        let rotationMatrixX = SGLMath.rotate(mat4(1), rotation.x, vec3(1, 0, 0))
        let rotationMatrixY = SGLMath.rotate(mat4(1), rotation.y, vec3(0, 1, 0))
        let rotationMatrixZ = SGLMath.rotate(mat4(1), rotation.z, vec3(0, 0, 1))
        let rotationMatrix = rotationMatrixX*rotationMatrixY*rotationMatrixZ
        
        return scaleMatrix*translationMatrix*rotationMatrix*/
        model
    }
    func setColor(_ color: vector_float3){
        material.color = color
    }
    func setTexture(device: MTLDevice, textureName: String){
        texture = Texture(device: device, textureName)
    }
    func setMaterial(useTexture:Int32 = -1){
        material.useTexture = useTexture != -1 ? useTexture: material.useTexture
    }
    func move(_ v: vec3){
        pos += v
        model = SGLMath.translate(model, v)
    }
    func rotate(_ v:vec3, angle: Float){
        rotation += angle*v
        model = SGLMath.rotate(model, angle, v)
    }
    func scale(_ newScale: vec3){
        size += newScale
        model = SGLMath.scale(model, newScale)
    }
    func update(){
        rotate(vec3(0.0, 1.0, 0.0), angle: 0.01)
    }
    func getPos()-> vec3{
        pos
    }
}

