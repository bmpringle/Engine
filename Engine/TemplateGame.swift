//
//  TemplateGame.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/2/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class TemplateGame {
    static var constants = Constants(bounds: SIMD4<Float>(100, 100, 100, 1))
    
    //set in ViewController.viewDidLoad before anything else, no need to change
    static var aspectRatio: Float = 16/10
    
    static func fireLogic(viewController: ViewController) {

    }
    
    static func createScene() -> Scene {
        return Scene()
    }

    static func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            default:
                print(event.keyCode)
                return false
       }
    }
    
    static func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    static func updateScene(renderer: Renderer) {

    }
}

