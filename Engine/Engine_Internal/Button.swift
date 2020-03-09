//
//  Button.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/8/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class Button: Node {
    var length: Float = 1
    var width: Float = 1
    var x: Float = 1
    var y: Float = 1
    var state = 0
    //0 is not pressed, 1 is pressed
    var texture_unpressed = ""
    var texture_pressed = ""
    var monitor: Any!
    
    init(children: [Node]?, _ root: Node) {
        super.init(vertices: Renderer.genericbox, children: children, root)
        monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {event in
            return self.handleMouseDown(with: event)
        }
    }
    
    init(children: [Node]?) {
        super.init(vertices: Renderer.genericbox, children: children)
        monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {event in
            return self.handleMouseDown(with: event)
        }
    }
    
    deinit {
        NSEvent.removeMonitor(monitor!)
    }
    
    @objc func resetstate() {
        state = 0
    }
    
    func handleMouseDown(with event: NSEvent) -> NSEvent {
        var location = SIMD2<Float>(Float(event.locationInWindow.x/(event.window?.contentView?.bounds.size.width)!), Float(event.locationInWindow.y/(event.window?.contentView?.bounds.size.height)!))
        location = (location*200)-100
        if(location[0] >= x && location[0] <= x+length) {
            if(location[1] >= y && location[1] <= y+width) {
                print("Clicked!")
                state = 1
                Timer.scheduledTimer(timeInterval: 1/2, target: self, selector: #selector(resetstate), userInfo: nil, repeats: false)
                return event
            }
        }
        state = 0
        return event
    }
    
    func setWidth(_ width: Float) {
        self.width = width
    }
    
    func setLength(_ length: Float) {
        self.length = length
    }
    
    func setX(_ x: Float) {
        self.x = x
        self.xyz = SIMD3<Float>(x, self.xyz[1], self.xyz[2])
    }
    
    func setY(_ y: Float) {
        self.y = y
        self.xyz = SIMD3<Float>(self.xyz[0], y, self.xyz[2])
    }
    
    override func renderNodeInternal(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice, _ allocator: MTLAllocator, _ descriptor: MTLRenderPipelineDescriptor) {
        
        if(state == 0) {
            if(texture_in_use) {
                texture_name = texture_unpressed
            }else {
                texture_name = "Test"
            }
        }else {
            if(texture_in_use) {
                texture_name = texture_pressed
            }else {
                texture_name = "Test"
            }
        }
        
        super.renderNodeInternal(renderEncoder, device, allocator, descriptor)
    }
    
}
