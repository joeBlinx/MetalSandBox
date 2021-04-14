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
    private var eye = vec3(-1, 1.5, -5)
    private var center = vec3(0, 0.5, 0)
    private let up = vec3(0, 1, 0)
    init(){
        
        view = SGLMath.lookAt(eye, center, up)
        proj = SGLMath.perspective(70.0, 16.0/9.0, 0.1, 100.0)
    }
    
    func getVP() -> mat4{
        proj * view
    }
    func update(){
        let delta: Float = 0.1
        if Keyboard.isKeyPressed(.downArrow) {
            eye.z -= delta
        }
        if Keyboard.isKeyPressed(.upArrow) {
            eye.z += delta
        }
        view = SGLMath.lookAt(eye, center, up)
    }
    
}
