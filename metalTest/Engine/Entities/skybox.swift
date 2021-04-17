//
//  skybox.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//
import Metal
import AppKit

private struct Slice{
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
    
    init(device: MTLDevice, singleImage textureName: String){
        vertexBuffer = VertexBuffer(device, model: cubeSkyBoxVertices())
        if let image = Image(filename: textureName){
            
            let sizeImageCube = image.height/3
            let textureDescriptor = MTLTextureDescriptor.textureCubeDescriptor(pixelFormat: .rgba8Unorm, size: sizeImageCube, mipmapped: false)
            texture = device.makeTexture(descriptor: textureDescriptor)
            for slice in 0...5 {
                let data = NSData(data: SkyBox.getSeparateData(image: image, slice: Slice.slices[slice], sizeImageCube: sizeImageCube))
                let region = MTLRegionMake2D(0, 0, sizeImageCube
                                             , sizeImageCube)
                texture.replace(region: region, mipmapLevel: 0, slice: slice, withBytes: data.bytes, bytesPerRow: sizeImageCube*4, bytesPerImage: sizeImageCube*4*sizeImageCube)
            }
        }else{
            print("\(textureName) has not been found")
        }
    }
    
    /*
     Skybox image must be named this way :
     - <textureName>_front.<ext>
     - <textureName>_back.<ext>
     - <textureName>_up.<ext>
     - <textureName>_down.<ext>
     - <textureName>_left.<ext>
     - <textureName>_right.<ext>
     */
    init(device: MTLDevice, multipleImage textureName:String, ext: String){
        let images = [
            Image(filename: textureName + "_left." + ext),
            Image(filename: textureName + "_right." + ext),
            Image(filename: textureName + "_up." + ext),
            Image(filename: textureName + "_down." + ext),
            Image(filename: textureName + "_front." + ext),
            Image(filename: textureName + "_back." + ext),
            ]
        vertexBuffer = VertexBuffer(device, model: cubeSkyBoxVertices())
        if let firstImage = images[0]{
            let sizeImageCube = firstImage.width
            let textureDescriptor = MTLTextureDescriptor.textureCubeDescriptor(pixelFormat: .rgba8Unorm, size: sizeImageCube, mipmapped: false)
            texture = device.makeTexture(descriptor: textureDescriptor)
            for slice in 0...5 {
                let image = images[slice]!
                let region = MTLRegionMake2D(0, 0, sizeImageCube
                                             , sizeImageCube)
                texture.replace(region: region, mipmapLevel: 0, slice: slice, withBytes: image.pixels, bytesPerRow: sizeImageCube*4, bytesPerImage: sizeImageCube*4*sizeImageCube)
            }
        }else{
            print("""
                \(textureName) images has not been found. Please verify that they are named like this:
                      <textureName>_front.<ext>
                      <textureName>_back.<ext>
                      <textureName>_up.<ext>
                      <textureName>_down.<ext>
                      <textureName>_left.<ext>
                      <textureName>_right.<ext>
                """)
        }
        
    }
    private static func getSeparateData(image: Image, slice: Slice.pair, sizeImageCube: Int) -> Data {
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

}
extension SkyBox{
    func draw(_ device: MTLDevice, encoder: MTLRenderCommandEncoder){
        encoder.setRenderPipelineState(Provider.pipelineState.get(device: device, "skybox"))
        encoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)
        encoder.setFragmentTexture(texture, index: 0)
        let (buffer, indices) = (vertexBuffer.buffer, vertexBuffer.indices)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount:indices.count, indexType: .uint32, indexBuffer: buffer, indexBufferOffset: indices.offset)
    }
}
