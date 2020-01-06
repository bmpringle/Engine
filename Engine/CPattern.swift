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
    
    func createBoard(xTiles: Int, yTiles: Int, _ hNaL: Bool) -> Node {
        let tiles: Node = Node(vertices: nil, children: nil)
        let walls: Node = Node(vertices: nil, children: nil)
        
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
                let tile = Node(vertices: tVerts, children: nil)
                if(hNaL) {
                    if(xMV == 0) {
                        let one = Node(vertices: nil, children: Line2D.ONE_TEXT)
                        one.scale(tLength/4)
                        one.move(xyz: SIMD3<Float>(-tLength, 0, 0))
                        tile.addChild(one)
                    }
                }
                tile.move(xyz: SIMD3<Float>(xMV, yMV, 0))
                tiles.addChild(tile)
                colorSwitch = !colorSwitch
            }
        }
        let room = Node(vertices: nil, children: [tiles, walls])
        room.move(xyz: SIMD3<Float>(Float(xTiles) * -tLength/2+tLength/2, Float(yTiles) * -tLength/2+tLength/2, 0))
        return room
    }
}


