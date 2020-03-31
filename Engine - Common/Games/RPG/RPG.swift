//
//  OpenWorld.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/29/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class RPG: TemplateGame {
    
    var loadedArea: Area
    var player: Player
    let UNIT: Float = 2
    
    override func fireLogic(viewController: ViewController) {
        loadedArea.doLogic(viewController: viewController)
        updateScene(renderer: viewController.renderer)
    }
    
    override func mouseHandler(with event: NSUIEvent, viewController: ViewController) -> NSUIEvent {
        return event
    }
    
    required init() {
        player = Player()
        player.msgToDisplay = "abc"
        loadedArea = Area(player: player, backgroundTexture: "Title")
    }
    
    override func createScene() -> Scene {
        let scene = Scene()
        scene.addChild(loadedArea.asNode(UNIT, scene))
        return scene
    }

    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            default:
                print(event.keyCode)
                return false
       }
    }
    
    override func defGame() -> TemplateGame {
        return RPG()
    }
    
    func updateScene(renderer: Renderer) {
        renderer.scene.getRootNode().children[0] = loadedArea.asNode(UNIT, renderer.scene)
    }
}

