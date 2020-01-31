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

class OpenWorld: TemplateGame {
    
    override func fireLogic(viewController: ViewController) {

    }
    
    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    override func createScene() -> Scene {
        let scene = Scene()
        let room = CPattern(3)
        let rNode1 = room.createBoard(xTiles: 4, yTiles: 9, false, scene: scene)
        scene.addChild(rNode1)
        return scene
    }

    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            default:
                print(event.keyCode)
                return false
       }
    }

    override func updateScene(renderer: Renderer) {

    }
}

