//
//  Room.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/30/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Room {
    var tLength: Float
    var white = SIMD4<Float>(1, 1, 1, 1)
    var blue = SIMD4<Float>(0, 0, 1, 1)
    var silver = SIMD4<Float>(0.75, 0.75, 0.75, 1)
    
    init(_ tileLength: Float) {
        tLength = 2*tileLength
    }
    
    func createRoom(xTiles: Int, yTiles: Int) -> Node {
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
                    color = white
                }else{
                    color = blue
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
