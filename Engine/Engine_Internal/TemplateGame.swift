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
    var constants = Constants(bounds: SIMD4<Float>(100, 100, 100, 1))
    var name = "game"
    
    //set in ViewController.viewDidLoad before anything else, no need to change
    var aspectRatio: Float = 16/10
    
    func fireLogic(viewController: ViewController) {

    }
    
    func createScene() -> Scene {
        return Scene()
    }

    func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       switch Int(event.keyCode) {
            default:
                print(event.keyCode)
                return false
       }
    }
    
    func dataRecieved(data: Data) {
        print("recieved \(data)")
    }
    
    func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    func updateScene(renderer: Renderer) {

    }
}

