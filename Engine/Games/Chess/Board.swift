//
//  Board.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/28/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Board {
    var squareSize: Float
    var topRight: SIMD3<Float>
    var scene: Scene
    var pieces: [Piece]
    var ids = 0
    
    init(_ squareSize: Float) {
        self.squareSize = squareSize
        scene = Scene()
        scene.setClearColor(SIMD4<Double>(0.1, 0.1, 0.1, 1))
        let board = CPattern(squareSize)
        board.setCol1(SIMD4<Float>(0, 0, 0, 1))
        board.setCol2(SIMD4<Float>(1, 1, 1, 1))
        let boardNode = board.createBoard(xTiles: 8, yTiles: 8, true, scene: scene)
        scene.addChild(boardNode)
        topRight = boardNode.getXYZ()
        pieces = [Piece]()
        
        //Rook
        addRook(SIMD2<Int>(1, 1), Color.WHITE)
        addRook(SIMD2<Int>(1, 8), Color.BLACK)
        addRook(SIMD2<Int>(8, 1), Color.WHITE)
        addRook(SIMD2<Int>(8, 8), Color.BLACK)
        for i in 1...8 {
            addPawnW(SIMD2<Int>(i, 2))
            addPawnB(SIMD2<Int>(i, 7))
        }
        
        addQueen(SIMD2<Int>(4, 8), Color.BLACK)
        addQueen(SIMD2<Int>(4, 1), Color.WHITE)
        
        addBishop(SIMD2<Int>(3, 8), Color.BLACK)
        addBishop(SIMD2<Int>(3, 1), Color.WHITE)
        addBishop(SIMD2<Int>(6, 1), Color.WHITE)
        addBishop(SIMD2<Int>(6, 8), Color.BLACK)

        addKnight(SIMD2<Int>(2, 8), Color.BLACK)
        addKnight(SIMD2<Int>(2, 1), Color.WHITE)
        addKnight(SIMD2<Int>(7, 1), Color.WHITE)
        addKnight(SIMD2<Int>(7, 8), Color.BLACK)

        
        addKing(SIMD2<Int>(5, 8), Color.BLACK)
        addKing(SIMD2<Int>(5, 1), Color.WHITE)
    }
    
    func tryMovePiece(_ id: Int, _ block: SIMD2<Int>) {
        guard let piece = getPiece(id) else {
            return
        }
        let magnitude = piece.getMagnitudes()
        let vectors = piece.getMoveVectors()
        let pos = piece.getBoardPlace()
        
        if(pieces[id].getType() == "knight") {
            if(abs(pos[0] - block[0]) == 2) {
                if(abs(pos[1]-block[1]) == 1) {
                    movePieceInternal(id: id, place: block, magRev: false, "knMV")
                    return
                }
            }else if(abs(pos[1] - block[1]) == 2) {
                if(abs(pos[0]-block[0]) == 1) {
                    movePieceInternal(id: id, place: block, magRev: false, "knMV")
                    return
                }
            }
        }
        
        if(pos[0] != block[0] && pos[1] != block[1]) {
            if(abs(pos[0]-block[0]) == abs(pos[1]-block[1])) {
                if(vectors.contains(SIMD2<Int>(1, 1))) {
                    if(magnitude.contains(abs(pos[1]-block[1]))) {
                        movePieceInternal(id: id, place: block, magRev: false, "diagMV")
                        return
                    }
                }
            }
        }
        if(pos[0] == block[0]) {
            if(pos[1] > block[1]) {
                if(vectors.contains(SIMD2<Int>(0, -1))) {
                    if(magnitude.contains(pos[1]-block[1])) {
                        movePieceInternal(id: id, place: block, magRev: false, "downMV")
                        return
                    }
                }
            }else if(pos[1] < block[1]){
                if(vectors.contains(SIMD2<Int>(0, 1))) {
                    if(magnitude.contains(block[1]-pos[1])) {
                        if(piece.getType() == "pawn") {
                            movePieceInternal(id: id, place: block, magRev: true, "upMV")
                        }else {
                            movePieceInternal(id: id, place: block, magRev: false, "upMV")
                        }
                        return
                    }
                }
            }
        }else if(pos[1] == block[1]) {
            if(pos[0] > block[0]) {
                if(vectors.contains(SIMD2<Int>(-1, 0))) {
                    if(magnitude.contains(pos[0]-block[0])) {
                        movePieceInternal(id: id, place: block, magRev: false, "leftMV")
                        return
                    }
                }
            }else if(pos[0] < block[0]){
                if(vectors.contains(SIMD2<Int>(1, 0))) {
                    if(magnitude.contains(block[0]-pos[0])) {
                        movePieceInternal(id: id, place: block, magRev: false, "rightMV")
                        return
                    }
                }
            }
        }
    }
    
    func movePieceInternal(id: Int, place: SIMD2<Int>, magRev: Bool, _ mv: String) {
        let piece = pieces[id]
        let magnitude = piece.getMagnitudes()
        let vectors = piece.getMoveVectors()
        let pos = piece.getBoardPlace()
        for p in pieces {
            if(mv == "knMV") {
                if(place == p.getBoardPlace()){
                    removePiece(p.getID())
                }
            }else if(mv == "diagMV") {
                let collideChecks = true
                
                if(collideChecks) {
                    if(place == p.getBoardPlace()){
                        removePiece(p.getID())
                    }
                }
            }else if(mv == "upMV") {
                let collideChecks = true
                
                if(collideChecks) {
                    if(place == p.getBoardPlace()){
                        removePiece(p.getID())
                    }
                }
            }else if(mv == "downMV") {
                let collideChecks = true
                
                if(collideChecks) {
                    if(place == p.getBoardPlace()){
                        removePiece(p.getID())
                    }
                }
            }else if(mv == "leftMV") {
                let collideChecks = true
                
                if(collideChecks) {
                    if(place == p.getBoardPlace()){
                        removePiece(p.getID())
                    }
                }
            }else if(mv == "rightMV") {
                let collideChecks = true
                
                if(collideChecks) {
                    if(place == p.getBoardPlace()){
                        removePiece(p.getID())
                    }
                }
            }
            
        }
        
        piece.setBoardPlace(place: place)
        if(magRev) {
            piece.removeMagnitude(2)
        }
        
        pieces[id] = piece
    }
    
    func setSelected(_ piece: Piece) {
        for i in 0..<pieces.count {
            if(pieces[i].getID() == piece.getID()) {
                let p = pieces[i]
                p.toggleSelected(true)
                pieces[i] = p
            }
        }
    }
    
    func setNoneSelected() {
        for i in 0..<pieces.count {
            let p = pieces[i]
            p.toggleSelected(false)
            pieces[i] = p
        }
    }
    
    func getPiece(_ pos: SIMD2<Int>) -> Piece? {
        for i in pieces {
            if(i.getBoardPlace() == pos) {
                return i
            }
        }
        return nil
    }
    
    func removePiece(_ ID: Int) {
        let n = pieces[ID]
        n.delete()
        pieces[ID] = n
        
        self.pieces.remove(at: ID)
        
        var pA = [Piece]()
        var nPA = [Piece]()

        for i in pieces {
            pA.append(i)
        }
        
        for i in 0..<pA.count {
            let j = pA[i]
            j.setID(id: i)
            nPA.append(j)
        }
        pieces = nPA
    }
    
    func getRecentClickBlock(_ loc: SIMD2<Float>) -> SIMD2<Int> {
        let recentClickBlockTemp = SIMD2<Float>((loc.x-topRight.x)/(2*squareSize)+0.5, (loc.y-topRight.y)/(2*squareSize)+0.5)
        let recentClickBlockTemp2 = SIMD2<Int>(Int(ceil(recentClickBlockTemp[0])), Int(ceil(recentClickBlockTemp[1])))
        return recentClickBlockTemp2
    }
    
    func addRook(_ pos: SIMD2<Int>, _ color: Color) {
        pieces.append(PieceImpl([SIMD2<Int>(0, 1), SIMD2<Int>(0, -1), SIMD2<Int>(1, 0), SIMD2<Int>(-1, 0)], [1, 2, 3, 4, 5, 6, 7, 8], pos, false, scene, topRight, squareSize, ids, "rook", color))
        ids = 1+ids
    }
    
    func addBishop(_ pos: SIMD2<Int>, _ color: Color) {
        pieces.append(PieceImpl([SIMD2<Int>(-1, -1), SIMD2<Int>(-1, 1), SIMD2<Int>(1, -1), SIMD2<Int>(1, 1)], [1, 2, 3, 4, 5, 6, 7, 8], pos, false, scene, topRight, squareSize, ids, "bishop", color))
        ids = 1+ids
    }
    
    func addQueen(_ pos: SIMD2<Int>, _ color: Color) {
        pieces.append(PieceImpl([SIMD2<Int>(-1, -1), SIMD2<Int>(-1, 1), SIMD2<Int>(1, -1), SIMD2<Int>(1, 1), SIMD2<Int>(0, 1), SIMD2<Int>(0, -1), SIMD2<Int>(1, 0), SIMD2<Int>(-1, 0)], [1, 2, 3, 4, 5, 6, 7, 8], pos, false, scene, topRight, squareSize, ids, "queen", color))
        ids = 1+ids
    }
    
    func addKing(_ pos: SIMD2<Int>, _ color: Color) {
        pieces.append(PieceImpl([SIMD2<Int>(-1, -1), SIMD2<Int>(-1, 1), SIMD2<Int>(1, -1), SIMD2<Int>(1, 1), SIMD2<Int>(0, 1), SIMD2<Int>(0, -1), SIMD2<Int>(1, 0), SIMD2<Int>(-1, 0)], [1], pos, false, scene, topRight, squareSize, ids, "king", color))
        ids = 1+ids
    }
    
    func addKnight(_ pos: SIMD2<Int>, _ color: Color) {
        pieces.append(PieceImpl([SIMD2<Int>(8, 8)], [1, 2, 3, 4, 5, 6, 7, 8], pos, false, scene, topRight, squareSize, ids, "knight", color))
        ids = 1+ids
    }
    
    func addPawnW(_ pos: SIMD2<Int>) {
        pieces.append(PieceImpl([SIMD2<Int>(0, 1)], [1, 2], pos, false, scene, topRight, squareSize, ids, "pawn", Color.WHITE))
        ids = 1+ids
    }
    
    func addPawnB(_ pos: SIMD2<Int>) {
        pieces.append(PieceImpl([SIMD2<Int>(0, -1)], [1, 2], pos, false, scene, topRight, squareSize, ids, "pawn", Color.BLACK))
        ids = 1+ids
    }
    
    func addPiece(piece: Piece) {
        pieces.append(piece)
    }
    
    func getPieces() -> [Piece] {
        return pieces
    }
    
    func getScene() -> Scene {
      //  scene.rootNode = Node()
        let tempScene = scene
        for i in pieces {
            tempScene.addChild(i as! Node)
        }
        return tempScene
    }
    
    func getPiece(_ id: Int) -> Piece? {
        for i in pieces {
            if(i.getID() == id) {
                return i
            }
        }
        return nil
    }
}
