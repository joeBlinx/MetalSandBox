//
//  skybox.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//
import Metal
import AppKit

struct Slice{
    struct pair{
        let row: Int;
        let column: Int;
    }
    static let PosX = pair(row: 1, column: 3);
    static let NegX = pair(row: 1, column: 1);
    static let PosY = pair(row: 0, column: 1);
    static let NegY = pair(row: 2, column: 1);
    static let PosZ = pair(row: 1, column: 2);
    static let NegZ = pair(row: 1, column: 0);
    static let slices = [
        PosX,
        NegX,
        PosY,
        NegY,
        PosZ,
        NegZ
    ]
}
struct SkyBox{
    var texture: MTLTexture!
    let vertexBuffer: VertexBuffer
    
    init(device: MTLDevice){
    
        vertexBuffer = VertexBuffer(device, model: Entity.model["cube"]!)
        if let image = Image(filename: "skyboxForest.png"){
            
            let sizeImageCube = image.height/3
            let textureDescriptor = MTLTextureDescriptor.textureCubeDescriptor(pixelFormat: .rgba8Unorm, size: sizeImageCube, mipmapped: false)
            texture = device.makeTexture(descriptor: textureDescriptor)
            for slice in 0...5 {
                let data = NSData(data: getSeparateData(image: image, slice: Slice.slices[slice], sizeImageCube: sizeImageCube))
                let region = MTLRegionMake2D(0, 0, sizeImageCube
                                             , sizeImageCube)
                texture.replace(region: region, mipmapLevel: 0, slice: slice, withBytes: data.bytes, bytesPerRow: sizeImageCube*4, bytesPerImage: sizeImageCube*4*sizeImageCube)
            }
        }
    }
}
extension SkyBox{
    func draw(encoder: MTLRenderCommandEncoder){
        encoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)
        encoder.setFragmentTexture(texture, index: 0)
        let (buffer, indices) = (vertexBuffer.buffer, vertexBuffer.indices)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount:indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
    }
}
func getSeparateData(image: Image, slice: Slice.pair, sizeImageCube: Int) -> Data {
    let newData = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: sizeImageCube * sizeImageCube * 4)
    for i in 0...sizeImageCube - 1 {
        let beginRow = 4*(sizeImageCube*slice.row + i)
        let beginColumn = 4*sizeImageCube*slice.column
        let range = NSRange(location: beginColumn + beginRow*image.width, length: sizeImageCube*4)
        memcpy(newData.baseAddress! + i*range.length, image.pixels + range.location, range.length)
    }
    let data = Data(buffer: newData)
    newData.deallocate()
    return data
}
