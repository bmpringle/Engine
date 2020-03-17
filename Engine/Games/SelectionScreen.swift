//
//  SelectionScreen.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/8/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

import Foundation
import Metal
import MetalKit

class SelectionScreen: TemplateGame {
    
    var swapTo: TemplateGame.Type? = nil
    
    override func fireLogic(viewController: ViewController) {
        viewController.menuGame = self
        for i in (viewController.renderer.scene.getRootNode().children as! [Button]) {
            if(i.state.pressed == 1) {
                swapTo = i.state.action as! TemplateGame.Type? ?? nil
            }else {
                if(swapTo != nil && i.state.action == swapTo) {
                    let to = swapTo
                    swapTo = nil
                    viewController.swapGame(game: to!.init())
                }
            }
        }
    }
    
    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    func chessButton(scene: Scene) -> Button {
        let state = ButtonState()
        state.scale(20)
        state.setX(-15)
        state.setY(25)
        state.setLength(30)
        state.setWidth(20)
        state.texture_in_use = true
        state.fragment_function = "fragment_texture_shader"
        state.texture_pressed = "ButtonPressed"
        state.texture_unpressed = "ButtonUnpressed"
        state.addOverlay("ChessText")
        state.action = Chess.self
        return Button(children: nil, scene.getRootNode(), state: state)
    }
    
    func pongButton(scene: Scene) -> Button {
        let state = ButtonState()
        state.scale(20)
        state.setX(-15)
        state.setY(-25)
        state.setLength(30)
        state.setWidth(20)
        state.texture_in_use = true
        state.fragment_function = "fragment_texture_shader"
        state.texture_pressed = "ButtonPressed"
        state.texture_unpressed = "ButtonUnpressed"
        state.addOverlay("PongText")
        state.action = Pong.self
        return Button(children: nil, scene.getRootNode(), state: state)
    }
    
    override func createScene() -> Scene {
        let scene = Scene()
        scene.addChild(chessButton(scene: scene))
        scene.addChild(pongButton(scene: scene))
        return scene
    }

    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            case 18:
                viewController.swapGame(game: Pong())
                return true
            case 19:
                viewController.swapGame(game: Chess())
                return true
            case 20:
                viewController.swapGame(game: OpenWorld())
                return true
            default:
                print(event.keyCode)
                return false
       }
    }

    override func updateScene(renderer: Renderer) {

    }
}
