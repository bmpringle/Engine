//
//  NetworkHandler.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/3/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkAdvertizer {
    var advertizer: MCNearbyServiceAdvertiser!
    var serviceName: String!
    var advertizing: Bool
    
    init(serviceName: String, delegate: NetworkDelegate) {
        self.serviceName = serviceName
        self.advertizer = MCNearbyServiceAdvertiser(peer: NetworkHandler.peerID, discoveryInfo: nil, serviceType: serviceName)
        self.advertizer.delegate = delegate
        self.advertizing = false
    }
    
    func isAdvertizing() -> Bool {
        return advertizing
    }
    
    func startAdvertizing() {
        advertizer.startAdvertisingPeer()
        self.advertizing = true
    }
    
    func stopAdvertizing() {
        advertizer.stopAdvertisingPeer()
        self.advertizing = false
    }
}
