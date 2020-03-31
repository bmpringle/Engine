//
//  Background.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/21/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Background {
    
    var width: Float = 100
    var height: Float = 100
    var texture: String
    
    init(_ texture: String) {
        self.texture = texture
    }
    
    func asNode(scene: Scene, unit: Float) -> Node {
        if(texture != "") {
            let background = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode(), "Test2", "fragment_texture_shader")
          //  background.scaleX(width*unit)
          //  background.scaleY(height*unit)
            background.scale(200)
            background.move(xyz: SIMD3<Float>(-unit*width/Float(2), -unit*height/Float(2), 0))
            print("hi")
            return background
        }else {
            let background = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
            background.scaleX(width*unit)
            background.scaleY(height*unit)
            background.move(xyz: SIMD3<Float>(-unit*width/Float(2), -unit*height/Float(2), 0))
            return background
        }
    }
}
