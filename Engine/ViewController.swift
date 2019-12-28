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

class ViewController: NSViewController {
    var mtkView: MTKView {
        return view as! MTKView
    }
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.sampleCount = 4
        mtkView.colorPixelFormat = .bgra8Unorm_srgb
        mtkView.depthStencilPixelFormat = .depth32Float
        
        //Create render class
        renderer = Renderer(mtkView: mtkView)
        
        mtkView.delegate = renderer!
    }
}

