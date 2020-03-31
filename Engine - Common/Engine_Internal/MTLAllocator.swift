//
//  MTLAllocator.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/9/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MetalKit
import Metal

struct IDAndState {
    var state: MTLRenderPipelineState
    var id: String
}

class MTLAllocator {
    var device: MTLDevice
    var buffers: [MTLBuffer] = [MTLBuffer]()
    var mtkView: MTKView
    var states = [IDAndState]()
    
    init(device: MTLDevice, bufferAmnt: Int, bufferByteAmnts: [Int], _ mtV: MTKView) {
        mtkView = mtV
        self.device = device
        for _ in 0..<bufferAmnt {
            for i in 0..<bufferByteAmnts.count {
                buffers.append(self.device.makeBuffer(length: bufferByteAmnts[i], options: [])!)
            }
        }
    }
    
    func getView() -> MTKView {
        return mtkView
    }
    
    func getBuffer(bufByteAmnt: Int) -> MTLBuffer {
        for i in 0..<buffers.count {
            if(buffers[i].allocatedSize == bufByteAmnt) {
                return buffers[i]
            }
        }
        return device.makeBuffer(length: bufByteAmnt, options: [])!
    }
    
    func getBuffer(bufByteAmnt: Int, bytes: UnsafeRawPointer) -> MTLBuffer {
        return device.makeBuffer(bytes: bytes, length: bufByteAmnt, options: [])!
    }
    
    func getDevice() -> MTLDevice {
        return device
    }
    
    func addPipelineStateWithDescriptor(descriptor: MTLRenderPipelineDescriptor, ID: String) {
        states.append(IDAndState(state: try! device.makeRenderPipelineState(descriptor: descriptor), id: ID))
    }
    
    func getPipelineState(ID: String) -> MTLRenderPipelineState? {
        for i in states {
            if(i.id == ID) {
                return i.state
            }
        }
        return nil
    }
    
    func getTexture(descriptor: MTLTextureDescriptor) -> MTLTexture {
        return device.makeTexture(descriptor: descriptor)!
    }
}
