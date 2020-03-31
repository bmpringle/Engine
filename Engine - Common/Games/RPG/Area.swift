//
//  Area.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/21/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Area {
    
    var background: Background
    var objects = [Object]()
    var entities = [Entity]()
    var overlay: Overlay = Overlay()
    var player: Player
    
    func setPlayer(_ player: Player) {
        self.player = player
    }
    
    init(player: Player, backgroundTexture: String) {
        background = Background(backgroundTexture)
        self.player = player
    }
    
    func doLogic(viewController: ViewController) {
        for i in entities {
            i.doLogic()
        }
        overlay.doLogic(viewController: viewController, player: player)
    }
    
    func asNode(_ unit: Float, _ scene: Scene) -> Node {
        let area = Node()
        area.addChild(background.asNode(scene: scene, unit: unit))
        for i in objects {
            area.children[0].addChild(i.asNode())
        }
        for i in entities {
            area.children[0].addChild(i.asNode())
        }
        area.addChild(overlay.asNode())
        return area
    }
}
