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

class OpenWorld {
    static var constants = Constants(bounds: SIMD4<Float>(100, 100, 100, 1))
    static var aspectRatio: Float = 16/10
    
    static func fireLogic(viewController: ViewController) {

    }
    
    static func createScene() -> Scene {
        let scene = Scene()
        let room = Room(3)
        let rNode1 = room.createRoom(xTiles: 4, yTiles: 9)
        scene.addChild(rNode1)
        return scene
    }

    static func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            default:
                print(event.keyCode)
                return false
       }
    }

    static func updateScene(renderer: Renderer) {

    }
}

