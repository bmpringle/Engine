//
//  NetworkFinder.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/7/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkFinder {
    var serviceName: String!
    var browser: MCNearbyServiceBrowser!
    
    init(serviceName: String, delegate: NetworkDelegate) {
        self.serviceName = serviceName
        self.browser = MCNearbyServiceBrowser(peer: NetworkHandler.peerID, serviceType: serviceName)
        self.browser.delegate = delegate
    }
    
    func startFinding(name: String) {
        browser.startBrowsingForPeers()
        (browser.delegate as! NetworkDelegate).lookingFor = name
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        (browser.delegate as! NetworkDelegate).lookingFor = "all"
    }
}
