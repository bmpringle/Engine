//
//  Aliases.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/31/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
typealias NSUIEvent = UIEvent
typealias NSUIImage = UIImage
#else
import AppKit
typealias NSUIEvent = NSEvent
typealias NSUIImage = NSImage
#endif
