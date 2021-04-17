//
//  ModelMesh.swift
//  metalTest
//
//  Created by techsoft3d on 16/04/2021.
//
import MetalKit
import Metal
class ModelMesh: Mesh{
    private var _meshes: [Any]!
    private var _instanceCount: Int = 1
    internal let pipelineName: String
    
    init(device: MTLDevice, modelName: String) {
        pipelineName = "basic"
        loadModel(device, modelName)
    }
    
    func loadModel(_ device: MTLDevice, _ modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) does not exist.")
        }
        
        let descriptor = MTKModelIOVertexDescriptorFromMetal(Provider.vertexDescriptor.get(device: device, pipelineName))
        (descriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (descriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        (descriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate

        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset: MDLAsset = MDLAsset(url: assetURL,
                                       vertexDescriptor: descriptor,
                                       bufferAllocator: bufferAllocator)
        do{
            self._meshes = try MTKMesh.newMeshes(asset: asset,
                                                 device: device).metalKitMeshes
        } catch {
            print("ERROR::LOADING_MESH::__\(modelName)__::\(error)")
        }
    }
    
    func setInstanceCount(_ count: Int) {
        self._instanceCount = count
    }
    
    func draw(_ device: MTLDevice, _ renderCommandEncoder: MTLRenderCommandEncoder) {
        guard let meshes = self._meshes as? [MTKMesh] else { return }
        renderCommandEncoder.setRenderPipelineState(Provider.pipelineState.get(device: device, "basic"))
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: self._instanceCount)
                }
            }
        }
    }
}

