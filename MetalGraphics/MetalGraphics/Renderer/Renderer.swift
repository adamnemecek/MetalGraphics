//
//  Renderer.swift
//  MetalGraphics
//
//  Created by lowe on 2018/9/7.
//  Copyright © 2018 lowe. All rights reserved.
//

import Metal
import MetalKit
import UIKit
import GSMath

protocol Renderer: class, MTKViewDelegate {
    var rotationX: Float { get set }
    var rotationY: Float { get set }
    var scaleFactor: Float { get }
    
    var uniformBuffer: MTLBuffer? { get set }
    init(mtkView: MTKView)
    
    func updateDynamicBuffer(view: MTKView)
}

extension Renderer {
    var scaleFactor: Float {
        return 0.8
    }
    
    func updateDynamicBuffer(view: MTKView) {
        if uniformBuffer == nil {
            uniformBuffer = view.device?.makeBuffer(length: Uniforms.memoryStride, options: .storageModeShared)
        }
        
        let rotate1 = GSMath.rotation(axis: float3(1, 0, 0), angle: rotationX)
        let rotate2 = GSMath.rotation(axis: float3(0, 1, 0), angle: rotationY)
        let scale = GSMath.scale(scaleFactor)
        let translate = GSMath.translate(x: 0, y: 0, z: -5)
        let size = view.drawableSize
        let apsect = Float(size.width / size.height)
        let projection = GSMath.perspective(aspect: apsect, fovy: 72.radian, near: 1, far: 100)
        let mat = projection * translate * rotate2 * rotate1 * scale
        
        let uniforms = Uniforms(mvp: mat)
        let uniformRawBuffer = uniformBuffer?.contents()
        uniformRawBuffer?.storeBytes(of: uniforms,
                                     toByteOffset: 0,
                                     as: Uniforms.self)
    }
    
}
