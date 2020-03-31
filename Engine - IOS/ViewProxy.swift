import MetalKit
import simd
import Metal

extension ViewController {
    
    convenience init(mtkView: MTKView, _ f: Any) {
        swapGame(game: currentGame)
        self.init(mtkView: mtkView)
    }
    
    
    
    @objc func fireLogic() {
        currentGame.fireLogic(viewController: self)
    }
    
    func swapGame(game: TemplateGame) {
        currentGame = game
        currentGame.aspectRatio = Float(mtkView.bounds.width/mtkView.bounds.height)
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.sampleCount = 8
        mtkView.colorPixelFormat = .bgra8Unorm_srgb
        mtkView.depthStencilPixelFormat = .depth32Float
        
        //Create render class
        renderer = Renderer(mtkView: mtkView, Game: currentGame)
        
        mtkView.delegate = renderer!
        
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(fireLogic), userInfo: nil, repeats: true)
        
       /* NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(exiting), name: NSApplication.willTerminateNotification, object: nil)*/
    }
    
    @objc func exiting() {
        renderer.netHandler.stopHosting()
        renderer.netHandler.disconnectAll()
    }
}
