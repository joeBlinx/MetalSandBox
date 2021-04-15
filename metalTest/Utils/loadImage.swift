//
//  loadImage.swift
//  metalTest
//
//  Created by techsoft3d on 15/04/2021.
//
import stb_image
import AppKit
class Image{
    
    var width = 0
    var height = 0
    var nbChannels = 0
    var pixels :UnsafeMutablePointer<stbi_uc>
    init?(filename: String) {
    
        let name = String(filename.split(separator: ".")[0])
        let ext = String(filename.split(separator: ".")[1])
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            
            var (x, y, channels) : (Int32, Int32, Int32) = (0, 0, 0);
            pixels = stbi_load(url.path, &x, &y, &channels, 4)!
            
            width = Int(x)
            height = Int(y)
            nbChannels = 4
        }else {
            return nil
        }
    }
    deinit {
        stb_image.free(pixels)
    }
}

