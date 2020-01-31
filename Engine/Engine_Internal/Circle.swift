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
    var aRatioStrd: Float
    
    init(pointNumber: Int, aRatio: Float) {
        self.pointNumber = pointNumber
        aRatioStrd = aRatio
        calculateCircle()
    }
    
    func setRadius(radius: Float, _ ratio: Float) {
        self.radius = radius
        self.aRatioStrd = ratio
        calculateCircle()
    }
    
    func setPointNumber(number: Int, _ ratio: Float) {
        self.pointNumber = number
        self.aRatioStrd = ratio
        calculateCircle()
    }
    
    func getVertices() -> [PosAndColor] {
        return xyzw
    }
    
    func setColor(_ color: SIMD4<Float>, _ ratio: Float) {
        self.color = color
        self.aRatioStrd = ratio
        calculateCircle()
    }
    
    func calculateCircle() {
        var radiansTriangle = radians_from_degrees(360)/Float(pointNumber)
        
        let radiansInc = radiansTriangle
        var prevX = radius
        var prevY: Float = 0
        
        for i in 0..<pointNumber {
            let x = cos(radiansTriangle)*radius
            let y = aRatioStrd*sin(radiansTriangle)*radius
            
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
