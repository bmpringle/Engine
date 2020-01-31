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

protocol Piece {
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
    
    func getType() -> String {
        return ChessType
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
        print(SIMD3<Float>(Float(self.place.x-place.x)*2*squareSize, Float(self.place.y-place.y)*2*squareSize, 0))
        print("\(ChessType): \(self.xyz)")
        self.place = place
    }
}
