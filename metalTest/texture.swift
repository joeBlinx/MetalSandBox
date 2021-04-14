//
//  Texture.swift
//  metalTest
//
//  Created by techsoft3d on 14/04/2021.
//

import MetalKit
import Metal
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
        let name = String(self._textureName.split(separator: ".")[0])
        let textureExtension = String(self._textureName.split(separator: ".")[1])
        if let url = Bundle.main.url(forResource: name, withExtension: textureExtension) {
            let textureLoader = MTKTextureLoader(device: device)
            
            let options: [MTKTextureLoader.Option : MTKTextureLoader.Origin] = [MTKTextureLoader.Option.origin : _origin]
            
            do{
                result = try textureLoader.newTexture(URL: url, options: options)
                result.label = _textureName
            }catch let error as NSError {
                print("ERROR::CREATING::TEXTURE::__\(_textureName!)__::\(error)")
            }
        }else {
            print("ERROR::CREATING::TEXTURE::__\(_textureName!) does not exist")
        }
        
        return result
    }
}
