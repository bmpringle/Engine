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

extension ViewController {
    
    @objc func fireLogic() {
        currentGame.fireLogic(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swapGame(game: currentGame)
    }
    
    func swapGame(game: TemplateGame) {
        currentGame = game
        currentGame.aspectRatio = Float(view.bounds.width/view.bounds.height)
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.sampleCount = 8
        mtkView.colorPixelFormat = .bgra8Unorm_srgb
        mtkView.depthStencilPixelFormat = .depth32Float
        
        //Create render class
        renderer = Renderer(mtkView: mtkView, Game: currentGame)
        
        mtkView.delegate = renderer!
        
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(fireLogic), userInfo: nil, repeats: true)
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            guard let locWindow = self.view.window,
            NSApplication.shared.keyWindow === locWindow else { return $0 }
            switch($0.keyCode) {
                case 46:
                    self.swapGame(game: self.menuGame ?? self.currentGame)
                    return nil
                case 15:
                    self.swapGame(game: self.currentGame.defGame())
                    return nil
                default:
                    break
                }
            if self.currentGame.keyHandler(with: $0, viewController: self) {
              return nil
           } else {
              return $0
           }
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {event in
            return self.currentGame.mouseHandler(with: event, viewController: self)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(exiting), name: NSApplication.willTerminateNotification, object: nil)
    }
    
    @objc func exiting() {
        renderer.netHandler.stopHosting()
        renderer.netHandler.disconnectAll()
    }
}
