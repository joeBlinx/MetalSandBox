//
//  Camera.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//

import SGLMath

class Camera{
    private var view: mat4
    private var proj: mat4
    
    init(){
        view = SGLMath.lookAt(vec3(-10, 1.5, -5), vec3(0, 0.5, 0), vec3(0, 1, 0))
        proj = SGLMath.perspective(70.0, 16.0/9.0, 0.1, 100.0)
    }
    
    func getVP() -> mat4{
        proj * view
    }
    
}
