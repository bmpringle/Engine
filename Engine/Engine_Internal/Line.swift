//
//  Line.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/4/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Line2D {
    static func createLine(length: Float, width: Float, angle: Float, scene: Scene) -> Node {
        let verts: [PosAndColor] = [
            PosAndColor(pos: SIMD4(width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            
            PosAndColor(pos: SIMD4(width/2, -length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(-width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
            PosAndColor(pos: SIMD4(width/2, length/2, 0, 1), color: SIMD4(0, 0, 0, 0)),
        ]
        
        let node = Node(vertices: verts, children: nil, scene.getRootNode())
        node.rotate(xyz: SIMD3<Float>(0, 0, angle))
        
        return node
    }
}


