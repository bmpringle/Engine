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
    var vertices: [PosAndColor]?
    var children: [Node] = [Node]()
    var xyz: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
    var yaw: Float = 0
    var pitch: Float = 0
    var roll: Float = 0
    var type: MTLPrimitiveType = .triangle
    
    func move(xyz: SIMD3<Float>) {
        self.xyz = self.xyz+xyz
        for i in 0..<children.count {
            children[i].move(xyz: xyz)
        }
    }
    
    func rotate(xyz: SIMD3<Float>) {
        yaw = yaw+xyz[0]
        pitch = pitch+xyz[1]
        roll = roll+xyz[2]
    }
    
    func getWorldMatrix() -> float4x4 {
        let yMatrix = float4x4(SIMD4<Float>(1, 0, 0, 0), SIMD4<Float>(0, 1, cos(radians_from_degrees(yaw)), -sin(radians_from_degrees(yaw))), SIMD4<Float>(0, 0, sin(radians_from_degrees(yaw)), cos(radians_from_degrees(yaw))), SIMD4<Float>(0, 0, 0, 0))
        let pMatrix = float4x4(SIMD4<Float>(cos(radians_from_degrees(pitch)), 0, sin(radians_from_degrees(pitch)), 0), SIMD4<Float>(0, 1, 0, 0), SIMD4<Float>(-sin(radians_from_degrees(pitch)), 0, cos(radians_from_degrees(pitch)), 0), SIMD4<Float>(0, 0, 0, 0))
        let rMatrix = float4x4(SIMD4<Float>(cos(radians_from_degrees(roll)), -sin(radians_from_degrees(roll)), 0, 0), SIMD4<Float>(sin(radians_from_degrees(roll)), cos(radians_from_degrees(roll)), 0, 0), SIMD4<Float>(0, 0, 1, 0), SIMD4<Float>(0, 0, 0, 0))
        let mvMatrix = float4x4(SIMD4<Float>(0, 0, 0, xyz[0]), SIMD4<Float>(0, 0, 0, xyz[1]), SIMD4<Float>(0, 0, 0, xyz[2]), SIMD4<Float>(0, 0, 0, 1))
        return yMatrix*pMatrix*rMatrix+mvMatrix
    }
    
    init(vertices: [PosAndColor]?, children: [Node]?) {
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
        var worldVertices: [PosAndColor] = []
        
        for i in 0..<vertices!.count {
            worldVertices.append(PosAndColor(pos: vertices![i].pos*getWorldMatrix(), color: vertices![i].color))
        }
        
        let buffer = device.makeBuffer(bytes: worldVertices, length: worldVertices.count*MemoryLayout<PosAndColor>.stride, options: [])
        
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
