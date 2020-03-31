//
//  Player.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/21/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation

class Player: Entity {
    var hp = 100
    var def = 100
    var str = 10
    var int = 10
    var luc = 0
    var statusPoints = 10
    var msgToDisplay = ""
    
    func spendPoint(on: String) {
        switch(on) {
        case "hp":
            hp=hp+10
            break
        case "def":
            def=def+5
            break
        case "str":
            str=str+2
            break
        case "int":
            int=int+1
            break
        case "luc":
            displayMsg(msg: "Sorry, but you can't increase luc like that!")
            return
        default:
            displayMsg(msg: "Sorry, but \(on) isn't a stat, so you can't spend stat points on it!")
            return
        }
        statusPoints = statusPoints - 1;
    }
    
    func displayMsg(msg: String) {
        msgToDisplay = msg
    }
}
