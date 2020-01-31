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
    public var backgroundColor: MTLClearColor = MTLClearColorMake(0, 0, 0, 0)
    var rootNode: Node = Node()
    
    func setAllocator(allocator: MTLAllocator) {
        rootNode.allocator = allocator
    }
    
    func addChild(_ Child: Node) {
        rootNode.addChild(Child)
    }
    
    func getRootNode() -> Node {
        return rootNode
    }
    
    func setClearColor(_ cc: SIMD4<Double>) {
        backgroundColor = MTLClearColorMake(cc[0], cc[1], cc[2], cc[3])
    }
    
    func renderScene(renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice!, _ descriptor: MTLRenderPipelineDescriptor) {
        if(rootNode.allocator == nil) {
            print("No allocator, cannot render scene")
        } else {
            rootNode.renderNode(renderEncoder, device, rootNode.allocator!, descriptor)
        }
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
    var scalar: Float = 1
    var allocator: MTLAllocator?
    var vertex_function = "vertex_shader"
    var fragment_function = "fragment_shader"
    var root_node: Node!
    var texture_in_use = false
    var texture_name = "Test"
    
    func getXYZ() -> SIMD3<Float> {
        return xyz
    }
    
    func move(xyz: SIMD3<Float>) {
        self.xyz = self.xyz+xyz
        for i in 0..<children.count {
            children[i].move(xyz: xyz)
        }
    }
    
    func set(xyz: SIMD3<Float>) {
        self.xyz = xyz
        for i in 0..<children.count {
            children[i].move(xyz: xyz)
        }
    }
    
    func setTextureName(_ name: String) {
        texture_name = name
    }
    
    func createTexture() -> MTLTexture{
        let textureLoader = MTKTextureLoader(device: root_node.allocator!.getDevice())
        let texture = try! textureLoader.newTexture(name: texture_name, scaleFactor: 1, bundle: Bundle.main, options: [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft as NSObject])
        
        return texture
    }
    
    func setRootNode(_ r: Node) {
        root_node = r
    }
    
    func scale(_ scalar: Float) {
        self.scalar = self.scalar*scalar
        for i in 0..<children.count {
            children[i].scale(scalar)
        }
        self.xyz = self.xyz*scalar
    }
    
    func rotate(xyz: SIMD3<Float>) {
        yaw = yaw+xyz[0]
        pitch = pitch+xyz[1]
        roll = roll+xyz[2]
        for i in 0..<children.count {
            children[i].rotate(xyz: xyz)
        }
    }
    
    func getVertexChildrenNodes() -> [Node] {
        var nde = [Node]()
        
        for i in children {
            if(i.vertices == nil) {
                let nde2 = i.getVertexChildrenNodes()
                for j in nde2 {
                    nde.append(j)
                }
            }else {
                nde.append(i)
            }
        }
        return nde
    }
    
    func setPrimitiveType(_ t: MTLPrimitiveType) {
        type = t
    }
    
    func getWorldMatrix() -> float4x4 {
        let yMatrix = float4x4(SIMD4<Float>(1, 0, 0, 0), SIMD4<Float>(0, 1, cos(radians_from_degrees(yaw)), -sin(radians_from_degrees(yaw))), SIMD4<Float>(0, 0, sin(radians_from_degrees(yaw)), cos(radians_from_degrees(yaw))), SIMD4<Float>(0, 0, 0, 0))
        let pMatrix = float4x4(SIMD4<Float>(cos(radians_from_degrees(pitch)), 0, sin(radians_from_degrees(pitch)), 0), SIMD4<Float>(0, 1, 0, 0), SIMD4<Float>(-sin(radians_from_degrees(pitch)), 0, cos(radians_from_degrees(pitch)), 0), SIMD4<Float>(0, 0, 0, 0))
        let rMatrix = float4x4(SIMD4<Float>(cos(radians_from_degrees(roll)), -sin(radians_from_degrees(roll)), 0, 0), SIMD4<Float>(sin(radians_from_degrees(roll)), cos(radians_from_degrees(roll)), 0, 0), SIMD4<Float>(0, 0, 1, 0), SIMD4<Float>(0, 0, 0, 0))
        let mvMatrix = float4x4(SIMD4<Float>(0, 0, 0, xyz[0]), SIMD4<Float>(0, 0, 0, xyz[1]), SIMD4<Float>(0, 0, 0, xyz[2]), SIMD4<Float>(0, 0, 0, 1))
        return(scalar*(yMatrix*pMatrix*rMatrix))+mvMatrix
    }
    
    init(vertices: [PosAndColor]?, children: [Node]?, _ root: Node) {
        self.vertices = vertices
        
        if(children != nil) {
            for i in 0..<children!.count {
                self.children.append(children![i])
            }
        }
        if((root) != nil) {
            root_node = root
        }
    }
 
    init(vertices: [PosAndColor]?, children: [Node]?, _ root: Node, _ texture: Bool) {
        self.vertices = vertices
        self.texture_in_use = texture
        if(children != nil) {
            for i in 0..<children!.count {
                self.children.append(children![i])
            }
        }
        if((root) != nil) {
            root_node = root
        }
    }
    
    init() {
        self.vertices = nil
        self.root_node = nil
    }
    
    func addChild(_ child: Node) {
        children.append(child)
    }

    private func renderNodeInternal(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice, _ allocator: MTLAllocator, _ descriptor: MTLRenderPipelineDescriptor) {
        var worldVertices: [PosAndColorTexture] = []
        
        for i in 0..<vertices!.count {
            worldVertices.append(PosAndColorTexture(pos: vertices![i].pos*getWorldMatrix(), color: vertices![i].color, texCoords: SIMD2<Float>(vertices![i].pos[0], vertices![i].pos[1])))
        }
        
        let lib = device.makeDefaultLibrary()
        
        if(vertex_function != "vertex_shader") {
            descriptor.vertexFunction = lib?.makeFunction(name: vertex_function)
        }
        
        if(fragment_function != "fragment_shader") {
            descriptor.fragmentFunction = lib?.makeFunction(name: fragment_function)
        }
        
        do {
            renderEncoder.setRenderPipelineState(try! device.makeRenderPipelineState(descriptor: descriptor))
        }
        
        if(texture_in_use) {
            renderEncoder.setFragmentTexture(createTexture(), index: 0)
        }
        
        let buffer = allocator.getBuffer(bufByteAmnt: worldVertices.count*MemoryLayout<PosAndColorTexture>.stride, bytes: worldVertices)
        renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: type, vertexStart: 0, vertexCount: worldVertices.count)
        descriptor.vertexFunction = lib?.makeFunction(name: "vertex_shader")
        descriptor.fragmentFunction = lib?.makeFunction(name: "fragment_color_shader")
    }
    
    func renderNode(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice, _ allocator: MTLAllocator, _ descriptor: MTLRenderPipelineDescriptor) {
        if(vertices != nil) {
            renderNodeInternal(renderEncoder, device, allocator, descriptor)
        }
        renderChildren(renderEncoder, device, allocator, descriptor)

    }
    
    func renderChildren(_ renderEncoder: MTLRenderCommandEncoder!, _ device: MTLDevice, _ allocator: MTLAllocator, _ descriptor: MTLRenderPipelineDescriptor) {
        for i in 0..<children.count {
            children[i].renderNode(renderEncoder, device, allocator, descriptor)
        }
    }
}
