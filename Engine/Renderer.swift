//
//  Renderer.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/27/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var mtkView: MTKView!
    var scene: Scene!
    
    init(mtkView: MTKView) {
        super.init()
        self.mtkView = mtkView
        device = mtkView.device
        commandQueue = device.makeCommandQueue()
        scene = Game.createScene()
        
        do {
            pipelineState = try buildRenderPipelineWith(device: device, metalKitView: mtkView)
        } catch {
            print("Unable to compile render pipeline state: \(error)")
        }
    }
    
    func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        // Create a new pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // Setup the shaders in the pipeline
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertex_shader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragment_shader")
        pipelineDescriptor.sampleCount = mtkView.sampleCount
        pipelineDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        // Setup the output pixel format to match the pixel format of the metal kit view
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        // Compile the configured pipeline descriptor to a pipeline state object
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func draw(in view: MTKView) {
        let buffer = commandQueue.makeCommandBuffer()!
        let renderDescriptor = view.currentRenderPassDescriptor!
        renderDescriptor.colorAttachments[0].clearColor = scene.backgroundColor
        let encoder = buffer.makeRenderCommandEncoder(descriptor: renderDescriptor)!
        
        let constantsBuffer = device.makeBuffer(length: MemoryLayout<Constants>.size, options: [])!
        memcpy(constantsBuffer.contents(), &Game.constants, MemoryLayout<Constants>.size)
        encoder.setVertexBuffer(constantsBuffer, offset: 0, index: 1)
        encoder.setRenderPipelineState(pipelineState)
        
        //Do Scene Rendering
        doSceneDraw(encoder)
        
        encoder.endEncoding()
        buffer.present(view.currentDrawable!)
        buffer.commit()
    }
    
    func doSceneDraw(_ encoder: MTLRenderCommandEncoder) {
        scene.renderScene(renderEncoder: encoder, device)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
