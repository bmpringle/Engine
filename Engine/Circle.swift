//
//  Circle.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/28/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import simd

public class Circle {
    var radius: Float = 1
    var xyzw: [PosAndColor] = [PosAndColor]()
    var pointNumber: Int
    var color: SIMD4<Float> = SIMD4<Float>(1, 1, 1, 1)
    init(pointNumber: Int) {
        self.pointNumber = pointNumber
        calculateCircle()
    }
    
    func setRadius(radius: Float) {
        self.radius = radius
        calculateCircle()
    }
    
    func setPointNumber(number: Int) {
        self.pointNumber = number
        calculateCircle()
    }
    
    func getVertices() -> [PosAndColor] {
        return xyzw
    }
    
    func setColor(_ color: SIMD4<Float> ) {
        self.color = color
        calculateCircle()
    }
    
    func calculateCircle() {
        var radiansTriangle = radians_from_degrees(360)/Float(pointNumber)
        
        let radiansInc = radiansTriangle
        var prevX = radius
        var prevY: Float = 0
        
        for i in 0..<pointNumber {
            let x = cos(radiansTriangle)*radius
            let y = Game.aspectRatio*sin(radiansTriangle)*radius
            
            radiansTriangle = radiansTriangle + radiansInc
            xyzw.append(PosAndColor(pos: SIMD4<Float>(0, 0, 0, 1), color: color))
            xyzw.append(PosAndColor(pos: SIMD4<Float>(prevX, prevY, 0, 1), color: color))
            xyzw.append(PosAndColor(pos: SIMD4<Float>(x, y, 0, 1), color: color))
            
            prevX = x
            prevY = y
        }
    }
    
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}
