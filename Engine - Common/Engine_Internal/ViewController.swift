//
//  ViewController.swift
//  Engine Common
//
//  Created by Benjamin M. Pringle on 3/31/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

typealias Game = TitleScreen

#if os(iOS)
class ViewController {
    var mtkView: MTKView!
    
    var renderer: Renderer!
    
    var menuGame: TemplateGame! = nil
    var currentGame: TemplateGame = Game()
    
    init(mtkView: MTKView) {
        self.mtkView = mtkView
    }
}
#else
import Cocoa
class ViewController: NSViewController {
    var mtkView: MTKView {
        return view as! MTKView
    }
    
    var renderer: Renderer!
    
    var menuGame: TemplateGame! = nil
    var currentGame: TemplateGame = Game()
}
#endif
