//
//  Line.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/4/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Line2D {
    static func createLine(length: Float, width: Float, angle: Float) -> Node {
        let verts: [PosAndColor] = [
            PosAndColor(pos: SIMD4(width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            
            PosAndColor(pos: SIMD4(width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
        ]
        
        let node = Node(vertices: verts, children: nil)
        node.rotate(xyz: SIMD3<Float>(0, 0, angle))
        
        return node
    }
}

extension Line2D {
    
    public static var ONE_TEXT: [Node] {
        var nodes = [Node]()
        let line1 = Line2D.createLine(length: 0.5, width: 0.05, angle: -45)
        line1.move(xyz: SIMD3(-0.18, 0.79, 0))
        let line2 = Line2D.createLine(length: 1.9, width: 0.03, angle: 0)
        let line3 = Line2D.createLine(length: 0.8, width: 0.05, angle: -90)
        line3.move(xyz: SIMD3<Float>(0, -0.95, 0))
        nodes.append(line1)
        nodes.append(line2)
        nodes.append(line3)
        return nodes
    }
    
    public static var NUMBER_TEXT_ARRAY: [[Node]] = [
        ONE_TEXT,
    ]
}
