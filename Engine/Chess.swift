//
//  Chess.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/2/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class Chess {
    static var constants = Constants(bounds: SIMD4<Float>(100, 100, 100, 1))
    static var board: Board = Board(0)
     
    //set in ViewController.viewDidLoad before anything else, no need to change
    static var aspectRatio: Float = 1
    
    static var selectedID = -1
    
    static func fireLogic(viewController: ViewController) {
        updateScene(renderer: viewController.renderer, key: "none")
    }
    
    static func createScene() -> Scene {
        board = Board(8)
        //Rook
        board.addRook(SIMD2<Int>(4, 5))
        return board.getScene()
    }
    
    static func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            case 126:
                updateScene(renderer: viewController.mtkView.delegate as! Renderer, key: "Up")
                return true
            default:
                print(event.keyCode)
                return false
       }
    }

    static func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        print("hi")
        var loc = SIMD2<Float>(Float(event.locationInWindow.x/viewController.view.bounds.size.width), Float(event.locationInWindow.y/viewController.view.bounds.size.height))
        loc = (loc*200)-100
        print(loc)
        let block = board.getRecentClickBlock(loc)
        print(selectedID)
        guard let piece = board.getPiece(block) else {
            board.setNoneSelected()
            print("ru")
            if(selectedID != -1) {
                print("n")
                board.tryMovePiece(selectedID, block)
                selectedID = -1
            }
            return event
        }
        
        board.setSelected(piece)
        selectedID = piece.getID()
        return event
    }
    
    static func updateScene(renderer: Renderer, key: String) {
        if(key=="Up") {
            let pieces = board.getPieces()
            var newPieces = [Piece]()
            for i in pieces {
                i.move(xy: SIMD2<Int>(0, 1))
                newPieces.append(i)
            }
            board.pieces = newPieces
        }
    }
}

protocol Piece {
    func getMoveVectors() -> [SIMD2<Int>]
    func getBoardPlace() -> SIMD2<Int>
    func skipsPieces() -> Bool
    func setBoardPlace(place: SIMD2<Int>)
    func move(xy: SIMD2<Int>)
    func toggleSelected(_ f: Bool)
    func getID() -> Int
    func has1Magnitude() -> Bool
}

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
    }
    
    func getPiece(_ id: Int) -> Piece? {
        for i in pieces {
            if(i.getID() == id) {
                return i
            }
        }
        return nil
    }
    
    func tryMovePiece(_ id: Int, _ block: SIMD2<Int>) {
        guard let piece = getPiece(id) else {
            return
        }
        let magnitude = piece.has1Magnitude()
        let vectors = piece.getMoveVectors()
        let pos = piece.getBoardPlace()
        print("run")
        if(pos[0] == block[0]) {
            print("b")
            if(pos[1] > block[1]) {
                print("d")
                if(vectors.contains(SIMD2<Int>(0, 1))) {
                    print("g")
                    if(pos[1]-block[1]>1) {
                        if(!magnitude) {
                            let piece = pieces[id]
                            piece.setBoardPlace(place: block)
                            pieces[id] = piece
                        }
                    }else{
                        print("f")
                        let piece = pieces[id]
                        piece.setBoardPlace(place: block)
                        pieces[id] = piece
                    }
                }
            }else if(pos[1] < block[1]){
                if(vectors.contains(SIMD2<Int>(0, 1))) {
                    print("c")
                    if(block[1]-pos[1]>1) {
                        print("e.t")
                        if(!magnitude) {
                            let piece = pieces[id]
                            piece.setBoardPlace(place: block)
                            pieces[id] = piece
                        }
                    }else{
                        print("zed")
                        pieces[id].setBoardPlace(place: block)
                    }
                }
            }
        }else if(pos[1] == block[1]) {
            if(pos[0] > block[0]) {
                if(vectors.contains(SIMD2<Int>(-1, 0))) {
                    if(pos[0]-block[0]>1) {
                        if(!magnitude) {
                            let piece = pieces[id]
                            piece.setBoardPlace(place: block)
                            pieces[id] = piece
                        }
                    }else{
                        let piece = pieces[id]
                        piece.setBoardPlace(place: block)
                        pieces[id] = piece
                    }
                }
            }else if(pos[0] < block[0]){
                if(vectors.contains(SIMD2<Int>(1, 0))) {
                    if(block[0]-pos[0]>1) {
                        if(!magnitude) {
                            let piece = pieces[id]
                            piece.setBoardPlace(place: block)
                            pieces[id] = piece
                        }
                    }else{
                        let piece = pieces[id]
                        piece.setBoardPlace(place: block)
                        pieces[id] = piece
                    }
                }
            }
        }
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
    
    func getRecentClickBlock(_ loc: SIMD2<Float>) -> SIMD2<Int> {
        let recentClickBlockTemp = SIMD2<Float>((loc.x-topRight.x)/(2*squareSize)+0.5, (loc.y-topRight.y)/(2*squareSize)+0.5)
        let recentClickBlockTemp2 = SIMD2<Int>(Int(ceil(recentClickBlockTemp[0])), Int(ceil(recentClickBlockTemp[1])))
        return recentClickBlockTemp2
    }
    
    func addRook(_ pos: SIMD2<Int>) {
        pieces.append(PieceImpl([SIMD2<Int>(0, 1), SIMD2<Int>(0, -1), SIMD2<Int>(1, 0), SIMD2<Int>(-1, 0)], true, pos, false, scene, topRight, squareSize, ids))
        ids = 1+ids
    }
    
    func addPiece(piece: Piece) {
        pieces.append(piece)
    }
    
    func getPieces() -> [Piece] {
        return pieces
    }
    
    func getScene() -> Scene {
        let tempScene = scene
        for i in pieces {
            tempScene.addChild(i as! Node)
        }
        return tempScene
    }
}

class PieceImpl: Node, Piece {
    func getID() -> Int {
        return ID
    }
    
    var selected = false
    
    func toggleSelected(_ f: Bool) {
        selected = f
    }
    
    private var ID: Int
    private var moveVectors = [SIMD2<Int>]()
    private var non1Magnitude = true
    private var place: SIMD2<Int>
    private var canSkipPieces = false
    private var squareSize: Float = 0
    
    init(_ vectors: [SIMD2<Int>], _ magnitudeLimit: Bool, _ pos: SIMD2<Int>, _ canSkip: Bool, _ scene: Scene, _ tR: SIMD3<Float>, _ squareSize: Float, _ id: Int) {
        moveVectors = vectors
        non1Magnitude = magnitudeLimit
        place = pos
        canSkipPieces = canSkip
        self.ID = id
        super.init(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
        self.scale(squareSize)
        self.move(xyz: tR-SIMD3<Float>(5/2*squareSize, 5/2*squareSize, 0))
        self.move(xyz: SIMD3<Float>(Float(pos.x)*2*squareSize, Float(pos.y)*2*squareSize, 0))
        self.squareSize = squareSize
    }
    
    func has1Magnitude() -> Bool {
        return !non1Magnitude
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
    
    func setBoardPlace(place: SIMD2<Int>) {
        print("mv")
        self.move(xyz: SIMD3<Float>(-Float(self.place.x-place.x)*2*squareSize, -Float(self.place.y-place.y)*2*squareSize, 0))
        print(SIMD3<Float>(Float(self.place.x-place.x)*2*squareSize, Float(self.place.y-place.y)*2*squareSize, 0))
        self.place = place
    } 
}
