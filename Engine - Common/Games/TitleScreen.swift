//
//  TitleScreen.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/7/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

import Foundation
import Metal
import MetalKit

class TitleScreen: TemplateGame {
    
    override func fireLogic(viewController: ViewController) {
        
    }
    
    override func mouseHandler(with event: NSUIEvent, viewController: ViewController) -> NSUIEvent {
        return event
    }
    
    override func createScene() -> Scene {
        let scene = Scene()
        let title = Node(vertices: Renderer.genericbox, children: nil, scene.getRootNode())
        title.fragment_function = "fragment_texture_shader"
        title.texture_in_use = true
        title.setTextureName("Title")
        title.move(xyz: SIMD3<Float>(-1/2, -1/2, 0))
        title.scale(100)
        scene.addChild(title)
        return scene
    }

    override func keyHandler(with event: NSUIEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            case 36:
                viewController.swapGame(game: SelectionScreen())
                return true
            default:
                print(event.keyCode)
                return false
       }
    }

    func updateScene(renderer: Renderer) {

    }
}
