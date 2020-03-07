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
    var move: Color = Color.WHITE
    
    override init() {
        super.init()
        name = "chess"
    }
    
    override func fireLogic(viewController: ViewController) {
        updateScene(renderer: viewController.renderer)
        viewController.renderer.netHandler.startHosting()
    }
    
    override func createScene() -> Scene {
        return board.getScene()
    }
    
    override func dataRecieved(data: Data) {
        let stringData = String(data: data, encoding: .utf8)
        let strings = stringData?.split(separator: "|")
        let block = SIMD2<Int>(Int(String(strings![1]))!, Int(String(strings![2]))!)
        let id = Int(String(strings![0]))!
        selectedID = id
        board.setNoneSelected()
        let success = board.tryMovePiece(selectedID, block, false)
       if(success) {
           if(move == Color.BLACK) {
               move = Color.WHITE
           }else {
               move = Color.BLACK
           }
       }
       selectedID = -1
        return
    }
    
    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
        case 13:
            viewController.renderer.netHandler.delegate.sendTest()
            return true
       case 46:
            
            let alert = NSAlert()
            alert.messageText = "Networking"
            alert.informativeText = "Enter the hostname of the opponent you want to connnect to:"
            alert.addButton(withTitle: "Done")
            let textfield = NSTextField(frame: NSRect(x: 0.0, y: 0.0, width: 80.0, height: 24.0))
            textfield.alignment = .center
            alert.accessoryView = textfield
            var hostname = ""
            let _ = alert.runModal()
                
            if(textfield.accessibilityValue()! != "") {
                hostname = textfield.accessibilityValue()!
            }else{
                return keyHandler(with: event, viewController: viewController)
            }
            
            viewController.renderer.netHandler.finder.startFinding(name: hostname)
            return true
        default:
            print(event.keyCode)
            return false
       }
    }
    func sendDataToPeers(data: String, viewController: ViewController) {
        viewController.renderer.netHandler.delegate.sendToAll(data: data)
    }
    
    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        var loc = SIMD2<Float>(Float(event.locationInWindow.x/viewController.view.bounds.size.width), Float(event.locationInWindow.y/viewController.view.bounds.size.height))
        loc = (loc*200)-100
        let block = board.getRecentClickBlock(loc)
        guard let piece = board.getPiece(block) else {
            board.setNoneSelected()
            if(selectedID != -1) {
                let success = board.tryMovePiece(selectedID, block, false)
                if(success) {
                    sendDataToPeers(data: "\(selectedID)|\(block[0])|\(block[1])", viewController: viewController)
                    if(move == Color.BLACK) {
                        move = Color.WHITE
                    }else {
                        move = Color.BLACK
                    }
                }
                selectedID = -1
            }
            return event
        }
        if(selectedID != -1) {
            if(board.getPiece(selectedID)!.getColor() != piece.getColor()) {
                board.setNoneSelected()
                if(selectedID != -1) {
                    let success = board.tryMovePiece(selectedID, block, false)
                    if(success) {
                        sendDataToPeers(data: "\(selectedID)|\(block[0])|\(block[1])", viewController: viewController)
                        if(move == Color.BLACK) {
                            move = Color.WHITE
                        }else {
                            move = Color.BLACK
                        }
                    }
                    selectedID = -1
                }
                return event
            }
        }
        
        if(piece.getColor() == move) {
            board.setSelected(piece)
            selectedID = piece.getID()
        }
        return event
    }
    
    override func updateScene(renderer: Renderer) {
        for i in 0..<board.getPieces().count {
            if(board.getPieces()[i].getType() == "pawn") {
                if(board.getPieces()[i].getBoardPlace()[1] == 1 || board.getPieces()[i].getBoardPlace()[1] == 8) {
                    let p = board.getPieces()[i]
                    p.setType("queen")
                    p.addMagnitude(2)
                    p.addMagnitude(3)
                    p.addMagnitude(4)
                    p.addMagnitude(5)
                    p.addMagnitude(6)
                    p.addMagnitude(7)
                    p.addMagnitude(8)
                    p.setMoveVectors([SIMD2<Int>(-1, -1), SIMD2<Int>(-1, 1), SIMD2<Int>(1, -1), SIMD2<Int>(1, 1), SIMD2<Int>(0, 1), SIMD2<Int>(0, -1), SIMD2<Int>(1, 0), SIMD2<Int>(-1, 0)])
                    if(p.getColor() == Color.BLACK) {
                        (p as! PieceImpl).setTextureName("blackqueen")
                    }else {
                        (p as! PieceImpl).setTextureName("whitequeen")
                    }
                }
            }
        }
    
       /* let bWin = board.hasWon(Color.BLACK)
        let wWin = board.hasWon(Color.WHITE)
        if(bWin) {
            print("Black Wins")
        }else if(wWin) {
            print("White Wins")
        }else if(wWin && bWin) {
            print("How the hell does that even work")
        }*/
        
    }
}

