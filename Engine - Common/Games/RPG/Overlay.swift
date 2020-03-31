//
//  Overlay.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/21/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Overlay {
    var node = Node()
    
    func asNode() -> Node {
        return node
    }
    
    func doLogic(viewController: ViewController, player: Player) {
        if(player.msgToDisplay != "") {
            print("msg")
            displayMsg(msg: player.msgToDisplay, viewController: viewController)
        }
    }
    
    func displayMsg(msg: String, viewController: ViewController) {
        let cgimg = TextRasterizer.makeText(str: msg)
        if(node.children.count > 0) {
            let node = Node(vertices: Renderer.genericbox, children: nil, viewController.renderer.scene!.getRootNode())
            node.texture_in_use = true
            node.fragment_function = "texture_fragment_function"
            node.useCGImageForTexture = cgimg
            node.scaleX(50)
            node.scaleY(30)
            self.node.children[0] = node
        }else {
            let node = Node(vertices: Renderer.genericbox, children: nil, viewController.renderer.scene!.getRootNode())
            node.texture_in_use = true
            node.fragment_function = "texture_fragment_function"
            node.useCGImageForTexture = cgimg
            node.scaleX(50)
            node.scaleY(30)
            self.node.addChild(node)
        }
    }
}
