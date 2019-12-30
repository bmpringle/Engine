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

typealias Game = OpenWorld

class ViewController: NSViewController {
    var mtkView: MTKView {
        return view as! MTKView
    }
    
    var renderer: Renderer!
    
    @objc func fireLogic() {
        Game.fireLogic(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.sampleCount = 4
        mtkView.colorPixelFormat = .bgra8Unorm_srgb
        mtkView.depthStencilPixelFormat = .depth32Float
        
        //Create render class
        renderer = Renderer(mtkView: mtkView)
        
        mtkView.delegate = renderer!
        
        Game.aspectRatio = Float(view.bounds.width/view.bounds.height)
        
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(fireLogic), userInfo: nil, repeats: true)
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return $0 }
            if Game.keyHandler(with: $0, viewController: self) {
              return nil
           } else {
              return $0
           }
        }
    }
}
