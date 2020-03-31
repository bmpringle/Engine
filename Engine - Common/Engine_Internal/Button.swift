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
    
    let state: ButtonState
    
    init(children: [Node]?, _ root: Node, state: ButtonState) {
        self.state = state
        super.init(vertices: Renderer.genericbox, children: children, root)
    }
    
    override func renderNodeInternal(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice, _ allocator: MTLAllocator, _ descriptor: MTLRenderPipelineDescriptor) {
        
        xyz = SIMD3<Float>(state.x, state.y, xyz[2])
        scalar = state.scalar
        
        if(state.overlayName != "") {
            if(children.count == 0) {
                let overlay = Node(vertices: Renderer.genericbox, children: nil, self.root_node)
                overlay.scalar = state.scalar*80/100
                overlay.xyz = SIMD3<Float>(state.x+abs(0.03125*state.x+1), state.y+abs(0.03125*state.y), xyz[2])
                overlay.texture_in_use = true
                overlay.fragment_function = state.fragment_function
                overlay.texture_name = state.overlayName
                print("added Overlay")
                print(NSUIImage(named: NSImage.Name("Test")) != nil)
                addChild(overlay)
            }
        }
        
        if(state.fragment_function != "") {
            fragment_function = state.fragment_function
        }
        
        texture_in_use = state.texture_in_use
        
        if(state.pressed == 0) {
            if(texture_in_use) {
                texture_name = state.texture_unpressed
            }else {
                texture_name = "Test"
            }
        }else {
            if(texture_in_use) {
                texture_name = state.texture_pressed
            }else {
                texture_name = "Test"
            }
        }
        
        super.renderNodeInternal(renderEncoder, device, allocator, descriptor)
    }
    
}
