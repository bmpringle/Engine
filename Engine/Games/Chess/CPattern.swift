//
//  Room.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/30/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class CPattern {
    var tLength: Float
    var col1 = SIMD4<Float>(1, 1, 1, 1)
    var col2 = SIMD4<Float>(0, 0, 1, 1)
    var silver = SIMD4<Float>(0.75, 0.75, 0.75, 1)
    
    init(_ tileLength: Float) {
        tLength = 2*tileLength
    }
    
    func setCol1(_ col: SIMD4<Float>) {
        col1 = col
    }
    
    func setCol2(_ col: SIMD4<Float>) {
        col2 = col
    }
    
    func createBoard(xTiles: Int, yTiles: Int, _ hNaL: Bool, scene: Scene) -> Node {
        let tiles: Node = Node(vertices: nil, children: nil, scene.getRootNode())
        let walls: Node = Node(vertices: nil, children: nil, scene.getRootNode())
        
        var colorSwitch = false
        for i in 0..<yTiles {
            if(xTiles.isMultiple(of: 2)) {
                colorSwitch = !colorSwitch
            }
            let yMV = Float(i)*tLength
            for j in 0..<xTiles {
                let xMV = Float(j)*tLength
                var color: SIMD4<Float>
                if(colorSwitch) {
                    color = col1
                }else{
                    color = col2
                }
                let x = -tLength/2
                let y = tLength/2
                let tVerts = [
                    PosAndColor(pos: SIMD4<Float>(x, y, 0, 1), color: color),
                    PosAndColor(pos: SIMD4<Float>(x, y-tLength, 0, 1), color: color),
                    PosAndColor(pos: SIMD4<Float>(x+tLength, y-tLength, 0, 1), color: color),
                    
                    PosAndColor(pos: SIMD4<Float>(x, y, 0, 1), color: color),
                    PosAndColor(pos: SIMD4<Float>(x+tLength, y-tLength, 0, 1), color: color),
                    PosAndColor(pos: SIMD4<Float>(x+tLength, y, 0, 1), color: color)
                ]
                let tile = Node(vertices: tVerts, children: nil, scene.getRootNode())
                if(hNaL) {
                    if(j == 0) {
                        let num = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
                        num.fragment_function = "fragment_texture_shader"
                        num.texture_in_use = true
                        num.setTextureName("\(i+1)")
                        num.scale(tLength/4)
                        num.move(xyz: SIMD3<Float>(-tLength, -tLength/8, 0))
                        tile.addChild(num)
                    }
                    if(j == xTiles-1) {
                        let num = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
                        num.fragment_function = "fragment_texture_shader"
                        num.texture_in_use = true
                        num.setTextureName("\(i+1)")
                        num.scale(tLength/4)
                        num.move(xyz: SIMD3<Float>(tLength, -tLength/8, 0))
                        tile.addChild(num)
                    }
                    if(i == 0) {
                        let letter = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
                        letter.fragment_function = "fragment_texture_shader"
                        letter.texture_in_use = true
                        letter.setTextureName(letters[j].uppercased())
                        letter.scale(tLength/4)
                        letter.move(xyz: SIMD3<Float>(-tLength/8, -tLength, 0))
                        tile.addChild(letter)
                    }
                    if(i == yTiles-1) {
                        let letter = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
                        letter.fragment_function = "fragment_texture_shader"
                        letter.texture_in_use = true
                        letter.setTextureName(letters[j].uppercased())
                        letter.scale(tLength/4)
                        letter.move(xyz: SIMD3<Float>(-tLength/8, tLength, 0))
                        tile.addChild(letter)
                    }
                }
                tile.move(xyz: SIMD3<Float>(xMV, yMV, 0))
                tiles.addChild(tile)
                colorSwitch = !colorSwitch
            }
        }
        let room = Node(vertices: nil, children: [tiles, walls], scene.getRootNode())
        room.move(xyz: SIMD3<Float>(Float(xTiles) * -tLength/2+tLength/2, Float(yTiles) * -tLength/2+tLength/2, 0))
        return room
    }
    
    private var letters: [Character] = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ]
}


