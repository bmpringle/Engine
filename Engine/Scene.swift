//
//  Scene.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/28/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

public class Scene {
    private var rootNode: Node = Node(vertices: nil, children: nil)
    
    func addChild(_ Child: Node) {
        rootNode.addChild(Child)
    }
    
    func renderScene(renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        rootNode.renderNode(renderEncoder, device)
    }
}

public class Node {
    var vertices: [SIMD4<Float>]?
    var children: [Node] = [Node]()
    
    init(vertices: [SIMD4<Float>]?, children: [Node]?) {
        self.vertices = vertices
        
        if(children != nil) {
            for i in 0..<children!.count {
                self.children.append(children![i])
            }
        }
    }
    
    func addChild(_ child: Node) {
        children.append(child)
    }
    
    func renderNode(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        if(vertices != nil) {
            let buffer = device.makeBuffer(bytes: vertices!, length: vertices!.count*MemoryLayout<SIMD4<Float>>.stride, options: [])
            
            renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices!.count)
        }
        renderChildren(renderEncoder, device)

    }
    
    func renderChildren(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        for i in 0..<children.count {
            children[i].renderNode(renderEncoder, device)
        }
    }
}
