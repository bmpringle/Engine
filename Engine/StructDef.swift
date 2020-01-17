//
//  Constants.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 12/28/19.
//  Copyright © 2019 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import simd

struct Constants {
    var bounds: SIMD4<Float>
}

struct PosAndColor {
    var pos: SIMD4<Float>
    var color: SIMD4<Float>
}

struct PosAndColorTexture {
    var pos: SIMD4<Float>
    var color: SIMD4<Float>
    var texCoords: SIMD2<Float>
}
