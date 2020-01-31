//
//  Utilities.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 1/31/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Utilities {
    static func NumbersBetween(_ num1: Int, _ num2: Int) -> [Int] {
        if(num1 > num2) {
            return NumbersBetweenInternal(num2, num1)
        }else if(num2 > num1){
            return NumbersBetweenInternal(num1, num2)
        }else {
            return [Int]()
        }
    }
    
    private static func NumbersBetweenInternal(_ lower: Int, _ upper: Int) -> [Int] {
        var numbersBetween = [Int]()
        
        for i in lower..<upper {
            if(i == lower) {
                
            }else {
                numbersBetween.append(i)
            }
        }
        return numbersBetween
    }
}
