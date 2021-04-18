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
    private var eye = vec3(0, 1.5, 5)
    private var center = vec3(0, 0.5, 0)
    private let up = vec3(0, 1, 0)
    private var fov:Float = 70
    private var ratio:Float = 0
    
    
    init(viewWidth: Float, viewHeight: Float){
        view = SGLMath.lookAt(eye, center, up)
        viewResize(viewWidth: viewWidth, viewHeight: viewHeight)
    }
    
    func viewResize(viewWidth: Float, viewHeight: Float){
        ratio = viewWidth/viewHeight
        computePerspective()
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
    func rotate(angle: vec3){
        eye = vec3(vec4(eye, 1) * SGLMath.rotate(mat4(1), angle.x, vec3(1, 0, 0)))
        eye = vec3(vec4(eye, 1) * SGLMath.rotate(mat4(1), angle.y, vec3(0, 1, 0)))
        eye = vec3(vec4(eye, 1) * SGLMath.rotate(mat4(1), angle.z, vec3(0, 0, 1)))
        computeView()
    }
    func handleInput(){
        let delta: Float = 1
        if Keyboard.isKeyPressed(.downArrow) {
            fov += delta
            fov = fov > 100 ? 100: fov
            computePerspective()
        }
        if Keyboard.isKeyPressed(.upArrow) {
            fov -= delta
            fov = fov < 1 ? 1:fov
            computePerspective()
        }
        let deltaRotate: Float = 0.005
        if(Keyboard.isKeyPressed(.leftArrow)){
            rotate(angle: vec3(0, deltaRotate, 0))
            computeView()
        }
        if(Keyboard.isKeyPressed(.rightArrow)){
            rotate(angle: vec3(0, -deltaRotate, 0))
            computeView()
        }
    }
    
}
extension Camera{
    private func computeView(){
        view = SGLMath.lookAt(eye, center, up)
    }
    private func computePerspective(){
        proj = SGLMath.perspective(radians(fov), ratio, 0.1, 100.0)
    }
}
