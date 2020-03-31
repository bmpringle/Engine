//
//  TextRasterizer.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/26/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import Metal
import MetalKit

class TextRasterizer {
    public static func makeText(str: String) -> CGImage {
        var data = Data()
        for i in str {
             data.append(makeDataFromCatalog(str: i.uppercased()))
        }
        return (NSUIImage(data: data)?.cgImage(forProposedRect: nil, context: nil, hints: nil))!
    }
    
    public static func makeDataFromCatalog(str: String) -> Data {
        return NSUIImage(named: NSUIImage.Name(str))!.tiffRepresentation!
    }
}
