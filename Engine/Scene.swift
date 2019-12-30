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
    
    func getRootNode() -> Node {
        return rootNode
    }
    
    func renderScene(renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        rootNode.renderNode(renderEncoder, device)
    }
}

public class Node {
    var vertices: [SIMD4<Float>]?
    var children: [Node] = [Node]()
    var worldMatrix: float4x4 = matrix_identity_float4x4
    var type: MTLPrimitiveType = .triangle
    
    func move(xyz: SIMD3<Float>) {
        worldMatrix[0][3] = worldMatrix[0][3]+xyz[0]
        worldMatrix[1][3] = worldMatrix[1][3]+xyz[1]
        worldMatrix[2][3] = worldMatrix[2][3]+xyz[2]
        for i in 0..<children.count {
            children[i].move(xyz: xyz)
        }
    }
    
    func getWorldMatrix() -> float4x4 {
        return worldMatrix
    }
    
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

    private func renderNodeInternal(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        var worldVertices: [SIMD4<Float>] = []
        
        for i in 0..<vertices!.count {
            worldVertices.append(vertices![i]*worldMatrix)
        }
        
        let buffer = device.makeBuffer(bytes: worldVertices, length: worldVertices.count*MemoryLayout<SIMD4<Float>>.stride, options: [])
        
        renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: type, vertexStart: 0, vertexCount: worldVertices.count)
    }
    
    func renderNode(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        if(vertices != nil) {
            renderNodeInternal(renderEncoder, device)
        }
        renderChildren(renderEncoder, device)

    }
    
    func renderChildren(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!) {
        for i in 0..<children.count {
            children[i].renderNode(renderEncoder, device)
        }
    }
}
