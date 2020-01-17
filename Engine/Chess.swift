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

class Chess {
    static var constants = Constants(bounds: SIMD4<Float>(100, 100, 100, 1))
    
    //set in ViewController.viewDidLoad before anything else, no need to change
    static var aspectRatio: Float = 1
    
    static func fireLogic(viewController: ViewController) {

    }
    
    static func createScene() -> Scene {
        let scene = Scene()
        scene.setClearColor(SIMD4<Double>(0.1, 0.1, 0.1, 1))
        let board = CPattern(8)
        board.setCol1(SIMD4<Float>(0, 0, 0, 1))
        board.setCol2(SIMD4<Float>(1, 1, 1, 1))
        let boardNode = board.createBoard(xTiles: 8, yTiles: 8, true, scene: scene)
        scene.addChild(boardNode)
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
