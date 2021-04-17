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
    private var material = MaterialBuffer(useTexture: 0)
    private var texture: Texture?
    
    private var mesh: Mesh
    
    init(device: MTLDevice, customModel: String){
        mesh = CustomMesh(device: device, model: customModel)
    }
    init(device: MTLDevice, meshModel:String){
        mesh = ModelMesh(device: device, modelName: meshModel)
    }
}

extension Entity{
    
    func draw(_ device: MTLDevice, encoder: MTLRenderCommandEncoder, reflectY: Bool = false){
        
        let model:mat4
        if(reflectY){
            model = SGLMath.scale(mat4(1), vec3(1, -1, 1))*self.model
        }else{
            model = self.model
        }
        encoder.setVertexBytes(model.elements, length: MemoryLayout<mat4>.size, index: 1)
        encoder.setFragmentBytes(&material, length: MemoryLayout<MaterialBuffer>.size, index: 0)
        if(material.useTexture == 1){
            if let texture = texture{
                encoder.setFragmentTexture(texture.texture, index: 0)
            }else{
                print("useTexture is set to true, but no texture has been load.")
            }
        }
        mesh.draw(device, encoder)
    }
    
    func setTexture(device: MTLDevice, textureName: String){
        texture = Texture(device: device, textureName)
    }
    func setMaterial(useTexture:Int32 = -1){
        material.useTexture = useTexture != -1 ? useTexture: material.useTexture
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
