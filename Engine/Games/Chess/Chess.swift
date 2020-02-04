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

class Chess: TemplateGame {
    
    var board: Board = Board(8)
    var selectedID = -1
    
    override func fireLogic(viewController: ViewController) {
        updateScene(renderer: viewController.renderer)
    }
    
    override func createScene() -> Scene {
        return board.getScene()
    }
    
    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
       case 13:
        board.pieces.remove(at: board.pieces.count-1)
        return true
        default:
                print(event.keyCode)
                return false
       }
    }

    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        var loc = SIMD2<Float>(Float(event.locationInWindow.x/viewController.view.bounds.size.width), Float(event.locationInWindow.y/viewController.view.bounds.size.height))
        loc = (loc*200)-100
        let block = board.getRecentClickBlock(loc)
        guard let piece = board.getPiece(block) else {
            board.setNoneSelected()
            if(selectedID != -1) {
                board.tryMovePiece(selectedID, block, false)
                selectedID = -1
            }
            return event
        }
        if(selectedID != -1) {
            if(board.getPiece(selectedID)!.getColor() != piece.getColor()) {
                board.setNoneSelected()
                if(selectedID != -1) {
                    board.tryMovePiece(selectedID, block, false)
                    selectedID = -1
                }
                return event
            }
        }
        
        board.setSelected(piece)
        selectedID = piece.getID()
        return event
    }
    
    override func updateScene(renderer: Renderer) {
        for i in 0..<board.getPieces().count {
            if(board.getPieces()[i].getType() == "pawn") {
                if(board.getPieces()[i].getColor() == Color.BLACK) {
                    if(board.getPieces()[i].getBoardPlace()[1] == 1) {
                        let p = board.getPieces()[i]
                    //    p.type = "queen"
                        board.pieces[i] = p
                    }
                }else {
                    if(board.getPieces()[i].getBoardPlace()[1] == 8) {
                        let p = board.getPieces()[i]
                 //       p.type = "queen"
                        board.pieces[i] = p
                    }
                }
            }
        }
    }
}

