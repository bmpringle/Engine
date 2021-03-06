//
//  Piece.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/28/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

enum Color {
    case WHITE
    case BLACK
}

protocol Piece: NSCopying {
    func getMoveVectors() -> [SIMD2<Int>]
    func getBoardPlace() -> SIMD2<Int>
    func skipsPieces() -> Bool
    func setBoardPlace(place: SIMD2<Int>)
    func move(xy: SIMD2<Int>)
    func toggleSelected(_ f: Bool)
    func getID() -> Int
    func addMagnitude(_ magnitude: Int)
    func getMagnitudes() -> [Int]
    func setID(id: Int)
    func getType() -> String
    func removeMagnitude(_ magnitude: Int)
    func getColor() -> Color
    func delete()
    func setType(_ type: String)
    func setMoveVectors(_ vec: [SIMD2<Int>])
}

class PieceImpl: Node, Piece {
    
    private var ID: Int
    private var moveVectors = [SIMD2<Int>]()
    private var magnitudes = [Int]()
    private var place: SIMD2<Int>
    private var canSkipPieces = false
    private var squareSize: Float = 0
    private var ChessType: String = "Untyped"
    private var color: Color
    
    func removeMagnitude(_ magnitude: Int) {
        for i in 0..<self.magnitudes.count {
            if(magnitudes[i] == magnitude) {
                self.magnitudes.remove(at: i)
            }
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let p = PieceImpl()
        p.ID = ID
        p.moveVectors = moveVectors
        p.magnitudes = magnitudes
        p.place = place
        p.canSkipPieces = canSkipPieces
        p.squareSize = squareSize
        p.ChessType = ChessType
        p.color = color
        p.vertices = vertices
        p.children = children
        p.xyz = xyz
        p.yaw = yaw
        p.pitch = pitch
        p.roll = roll
        p.type = type
        p.scalar = scalar
        p.allocator = allocator
        p.vertex_function = vertex_function
        p.fragment_function = fragment_function
        p.root_node = root_node
        p.texture_in_use = texture_in_use
        p.texture_name = texture_name
        return p
    }
    
    func setMoveVectors(_ vec: [SIMD2<Int>]) {
        self.moveVectors = vec
    }
    
    func getType() -> String {
        return ChessType
    }
    
    func setType(_ type: String) {
        self.ChessType = type
    }
    
    func getMagnitudes() -> [Int] {
        return magnitudes
    }
    
    func getID() -> Int {
        return ID
    }
    
    func setID(id: Int) {
        ID = id
    }
    
    var selected = false
    
    func toggleSelected(_ f: Bool) {
        selected = f
    }
    
    func getColor() -> Color {
        return color
    }
    
    override init() {
        ID = 0
        color = Color.BLACK
        place = SIMD2<Int>(0, 0)
        super.init()
    }
    
    init(_ vectors: [SIMD2<Int>], _ magnitudes: [Int], _ pos: SIMD2<Int>, _ canSkip: Bool, _ scene: Scene, _ tR: SIMD3<Float>, _ squareSize: Float, _ id: Int, _ type: String, _ color: Color) {
        self.color = color
        self.ChessType = type
        self.magnitudes = magnitudes
        moveVectors = vectors
        place = pos
        canSkipPieces = canSkip
        self.ID = id
        super.init(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
        self.scale(squareSize)
        self.move(xyz: tR-SIMD3<Float>(5/2*squareSize, 5/2*squareSize, 0))
        self.move(xyz: SIMD3<Float>(Float(pos.x)*2*squareSize, Float(pos.y)*2*squareSize, 0))
        self.squareSize = squareSize
    }
    
    func addMagnitude(_ magnitude: Int) {
        magnitudes.append(magnitude)
    }
    
    func move(xy: SIMD2<Int>) {
        self.move(xyz: SIMD3<Float>(Float(xy.x)*2*squareSize, Float(xy.y)*2*squareSize, 0))
    }
    
    func getMoveVectors() -> [SIMD2<Int>] {
        return moveVectors
    }
    
    func getBoardPlace() -> SIMD2<Int> {
        return place
    }
    
    func skipsPieces() -> Bool {
        return canSkipPieces
    }
    
    func delete() {
        self.vertices = nil
        self.children = [Node]()
    }
    
    func setBoardPlace(place: SIMD2<Int>) {
        self.move(xyz: SIMD3<Float>(-Float(self.place.x-place.x)*2*squareSize, -Float(self.place.y-place.y)*2*squareSize, 0))
        self.place = place
    }
}
