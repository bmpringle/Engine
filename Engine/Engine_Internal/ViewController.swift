//
//  ViewController.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/27/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Cocoa
import MetalKit
import simd
import Metal

typealias Game = Chess

class ViewController: NSViewController {
    var mtkView: MTKView {
        return view as! MTKView
    }
    
    var renderer: Renderer!
    var game = Game()
    
    @objc func fireLogic() {
        game.fireLogic(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.aspectRatio = Float(view.bounds.width/view.bounds.height)
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.sampleCount = 8
        mtkView.colorPixelFormat = .bgra8Unorm_srgb
        mtkView.depthStencilPixelFormat = .depth32Float
        
        //Create render class
        renderer = Renderer(mtkView: mtkView, Game: game)
        
        mtkView.delegate = renderer!
        
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(fireLogic), userInfo: nil, repeats: true)
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return $0 }
            if self.game.keyHandler(with: $0, viewController: self) {
              return nil
           } else {
              return $0
           }
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {event in
            return self.game.mouseHandler(with: event, viewController: self)
        }
    }
}
