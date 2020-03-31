//
//  ButtonState.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/13/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class ButtonState {
    var length: Float = 1
    var width: Float = 1
    var x: Float = 1
    var y: Float = 1
    var pressed = 0
    //0 is not pressed, 1 is pressed
    var monitor: Any!
    var texture_unpressed = ""
    var texture_pressed = ""
    var fragment_function = ""
    var scalar: Float = 1
    var texture_in_use = false
    var overlayName: String = ""
    var action: AnyClass?
    
    func scale(_ s: Float) {
        scalar = scalar*s
    }
    
    func addOverlay(_ name: String) {
        overlayName = name
    }
    
    init() {
        monitor = NSUIEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {event in
            return self.handleMouseDown(with: event)
        }
    }
    
    deinit {
        NSUIEvent.removeMonitor(monitor!)
    }
    
    @objc func resetstate() {
        pressed = 0
    }
    
    func handleMouseDown(with event: NSUIEvent) -> NSUIEvent {
        var location = SIMD2<Float>(Float(event.locationInWindow.x/(event.window?.contentView?.bounds.size.width)!), Float(event.locationInWindow.y/(event.window?.contentView?.bounds.size.height)!))
        location = (location*200)-100
        if(location[0] >= x && location[0] <= x+length) {
            if(location[1] >= y && location[1] <= y+width) {
                print("Clicked!")
                pressed = 1
                Timer.scheduledTimer(timeInterval: 1/2, target: self, selector: #selector(resetstate), userInfo: nil, repeats: false)
                return event
            }
        }
        pressed = 0
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
    }
    
    func setY(_ y: Float) {
        self.y = y
    }
}
