//
//  LogicBuffer.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 2/4/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class LogicBuffer<T> {
    private var buffer: T!
    
    func setBuffer(_ any: T) {
        buffer = any
    }
    
    func getBuffer() -> T {
        return buffer
    }
}
