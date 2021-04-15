//
//  Texture.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//

import MetalKit
import Metal
import stb_image
class Texture {
    var texture: MTLTexture!
    
    init(device: MTLDevice, _ textureName: String, origin: MTKTextureLoader.Origin = .topLeft){
        let textureLoader = TextureLoader(textureName: textureName, origin: origin)
        let texture: MTLTexture = textureLoader.loadTextureFromBundle(device: device)
        setTexture(texture)
    }
    
    func setTexture(_ texture: MTLTexture){
        self.texture = texture
    }
}

class TextureLoader {
    private var _textureName: String!
    private var _origin: MTKTextureLoader.Origin!
    
    init(textureName: String, origin: MTKTextureLoader.Origin = .topLeft){
        self._textureName = textureName
        self._origin = origin
    }
    
    public func loadTextureFromBundle(device: MTLDevice)->MTLTexture{
        var result: MTLTexture!
        if let image = Image(filename: _textureName){
            
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: image.width, height: image.height, mipmapped: false)
            result = device.makeTexture(descriptor: textureDescriptor)
            result.replace(region: MTLRegionMake2D(0, 0, image.width, image.height), mipmapLevel: 0, withBytes: image.pixels, bytesPerRow: image.width*image.nbChannels)
            
            
        }else {
            print("ERROR::CREATING::TEXTURE::__\(_textureName!) does not exist")
        }
        
      
       
        return result
    }
}
