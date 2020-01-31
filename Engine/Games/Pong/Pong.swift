//
//  Pong.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/29/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

//Pong impl. using the engine
class Pong: TemplateGame {
    private var p1MV = 0
    private var p2MV = 0
    private var ballRadius: Float = 2
    
    override func fireLogic(viewController: ViewController) {
        if(gameOver || !gameStart) {
            
        }else{
            updateScene(renderer: viewController.mtkView.delegate as! Renderer)
        }
    }
    
    override func mouseHandler(with event: NSEvent, viewController: ViewController) -> NSEvent {
        return event
    }
    
    override func createScene() -> Scene {
        let vertices: [PosAndColor] = [
            PosAndColor(pos: SIMD4<Float>(-1, 20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            PosAndColor(pos: SIMD4<Float>(-1, -20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            PosAndColor(pos: SIMD4<Float>(1, -20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            
            PosAndColor(pos: SIMD4<Float>(-1, 20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            PosAndColor(pos: SIMD4<Float>(1, -20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            PosAndColor(pos: SIMD4<Float>(1, 20, 0, 1), color: SIMD4<Float>(1, 0, 0, 1))
        ]
        
        var circle: [PosAndColor] {
            let c = Circle(pointNumber: 30, aRatio: aspectRatio)
            c.setRadius(radius: ballRadius, aspectRatio)
            return c.getVertices()
        }
        
        let scene = Scene()
        let node1 = Node(vertices: vertices, children: nil, scene.getRootNode())
        let node2 = Node(vertices: vertices, children: nil, scene.getRootNode())
        let node3 = Node(vertices: circle, children: nil, scene.getRootNode())
        
        node1.move(xyz: SIMD3<Float>(-98, 0, 0))
        node2.move(xyz: SIMD3<Float>(98, 0, 0))
        scene.addChild(node1)
        scene.addChild(node2)
        scene.addChild(node3)
        return scene
    }

    override func keyHandler(with event: NSEvent, viewController: ViewController) -> Bool {
       // handle keyDown only if current window has focus, i.e. is keyWindow
       switch Int( event.keyCode) {
       case 13:
          //w
        p1MV = 5
        return true
       case 1:
        //s
        p1MV = -5
        return true
       case 126:
        //up
        p2MV = 5
        return true
       case 125:
        //down
        p2MV = -5
        return true
       case 36:
        //start
        if(!gameStart) {
            gameStart = true
            return true
        }else{
            return false
        }
       default:
        print(event.keyCode)
          return false
       }
    }
    
    private var speed: Float = 1/10
    private var angle = SIMD2<Float>(Float(Int.random(in: 1 ... 10)), Float(Int.random(in: 1 ... 10)))
    public var gameStart = false
    public var gameOver = false

    override func updateScene(renderer: Renderer) {
        
        //Move Ball
        renderer.scene.getRootNode().children[2].move(xyz: SIMD3<Float>(angle[0]*speed, angle[1]*speed, 0))
        
        //Do the calculations for the bounds of the objects
        let ballWorldMatrix = renderer.scene.getRootNode().children[2].getWorldMatrix()
        let xMiddle = ballWorldMatrix[0][3]
        let yMiddle = ballWorldMatrix[1][3]
        let xLeft = xMiddle-ballRadius
        let xRight = xMiddle+ballRadius
        let yTop = yMiddle+ballRadius
        let yBottom = yMiddle-ballRadius
        
        let p1WorldMatrix = renderer.scene.getRootNode().children[0].getWorldMatrix()
        let p2WorldMatrix = renderer.scene.getRootNode().children[1].getWorldMatrix()
        let p1Top = p1WorldMatrix[1][3]+20
        let p1Bottom = p1WorldMatrix[1][3]-20
        let p2Top = p2WorldMatrix[1][3]+20
        let p2Bottom = p2WorldMatrix[1][3]-20

        //Check if paddles can move
        switch(p1MV) {
            case 5:
                if(p1Top < 100) {
                    renderer.scene.getRootNode().children[0].move(xyz: SIMD3<Float>(0, Float(p1MV), 0))
                }
            break
            case -5:
                if(p1Bottom > -100) {
                    renderer.scene.getRootNode().children[0].move(xyz: SIMD3<Float>(0, Float(p1MV), 0))
                }
            break
            default:
                
            break
        }
        
        switch(p2MV) {
            case 5:
                if(p2Top < 100) {
                    renderer.scene.getRootNode().children[1].move(xyz: SIMD3<Float>(0, Float(p2MV), 0))
                }
            break
            case -5:
                if(p2Bottom > -100) {
                    renderer.scene.getRootNode().children[1].move(xyz: SIMD3<Float>(0, Float(p2MV), 0))
                }
            break
            default:
            break
        }
        
        //Reset Move Vars
        p1MV = 0
        p2MV = 0
        
        //Left bound calculations for ball, and bouncing off of paddle
        if(xLeft < -97) {
            if(yTop > p1Bottom && yBottom < p1Top) {
                angle[0] = -angle[0]
                speed = speed*1.15
            }else{
                renderer.scene.getRootNode().children = [Node]()
                gameOver = true
                print("Player 2 Won!")
            }
        }
        
        //Right bound calculations for ball, and bouncing off of paddle
        if(xRight > 97) {
            
            if(yTop > p2Bottom && yBottom < p2Top) {
                angle[0] = -angle[0]
                speed = speed*1.15
            }else{
                renderer.scene.getRootNode().children = [Node]()
                gameOver = true
                print("Player 1 Won!")
            }
        }
        
        //Top bound calculations and bouncing off ceiling
        if(yTop>97) {
            angle[1] = -angle[1]
        }
        
        //Bottom bound calculations and bouncing off floor
        if(yBottom < -97) {
            angle[1] = -angle[1]
        }
    }
}

