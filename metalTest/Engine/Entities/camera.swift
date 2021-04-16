//
//  Camera.swift
//  metalTest
//
//  Created by techsoft3d on 12/04/2021.
//

import SGLMath

class Camera{
    private var view: mat4
    private var proj = mat4(1)
    private var eye = vec3(-1, 1.5, -5)
    private var center = vec3(0, 0.5, 0)
    private let up = vec3(0, 1, 0)
    init(viewWidth: Float, viewHeight: Float){
        view = SGLMath.lookAt(eye, center, up)
        viewResize(viewWidth: viewWidth, viewHeight: viewHeight)
    }
    
    func viewResize(viewWidth: Float, viewHeight: Float){
        proj = SGLMath.perspective(70.0, viewWidth/viewHeight, 0.1, 100.0)
    }
    func getVP() -> mat4{
        proj * view
    }
    func getVPSkyBox() -> mat4 {
        proj*mat4(mat3(view))
    }
    func getView() -> mat4{
        view
    }
    func getPos() -> vec3{
        eye
    }
    func handleInput(){
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
