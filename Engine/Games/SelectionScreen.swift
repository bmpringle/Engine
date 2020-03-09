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
    
    var swapToChess = false
    
    override func fireLogic(viewController: ViewController) {
        viewController.menuGame = self
        if(swapToChess) {
            viewController.swapGame(game: Chess())
        }
    }
    
    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    override func createScene() -> Scene {
        let scene = Scene()
        let button1 = Button(children: nil, scene.getRootNode())
        button1.scale(20)
        button1.setX(-60)
        button1.setY(60)
        button1.setLength(30)
        button1.setWidth(20)
        button1.texture_in_use = true
        button1.fragment_function = "fragment_texture_shader"
        button1.texture_pressed = "ButtonPressedChess"
        button1.texture_unpressed = "ButtonUnpressedChess"
        scene.addChild(button1)
        if(button1.state == 1) {
            swapToChess = true
        }
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
