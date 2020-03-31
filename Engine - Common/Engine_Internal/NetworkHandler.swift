//
//  NetworkHandler.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/7/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkHandler {
    var advertizer: NetworkAdvertizer
    var finder: NetworkFinder
    var delegate: NetworkDelegate!
    var connections: [String] = [String]()
    static var peerID = MCPeerID(displayName: Host.current().name!)
    
    init(serviceName: String, game: TemplateGame) {
        self.delegate = NetworkDelegate(serviceName: serviceName, game: game)
        self.advertizer = NetworkAdvertizer(serviceName: serviceName, delegate: delegate)
        self.finder = NetworkFinder(serviceName: serviceName, delegate: delegate)
    }
    
    func startHosting() {
        advertizer.startAdvertizing()
    }
    
    func stopHosting() {
        advertizer.stopAdvertizing()
    }
    
    func connect(to: String) {
        connections.append(to)
        finder.startFinding(name: to)
    }
    
    func disconnect(from: String) {
        connections.remove(at: connections.firstIndex(of: from)!)
    }
    
    func disconnectAll() {
        for i in connections {
            disconnect(from: i)
        }
    }
}

class NetworkDelegate: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    var session: NetworkSession!
    var lookingFor = "all"
    var game: TemplateGame!
    
    init(serviceName: String, game: TemplateGame) {
        super.init()
        self.session = NetworkSession(serviceName: serviceName, delegate: self)
        self.game = game
    }

    func peerCount() -> Int {
        return session.session.connectedPeers.count
    }
    
    func sendTest() {
        if(session.session.connectedPeers.count > 0) {
            try! self.session.session.send("helloder".data(using: .utf8)!, toPeers: session.session.connectedPeers, with: .reliable)
        }
    }
    
    func sendToAll(data: String) {
        if(session.session.connectedPeers.count > 0) {
            try! self.session.session.send(data.data(using: .utf8)!, toPeers: session.session.connectedPeers, with: .reliable)
        }
    }
    
    //delegate functions
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "\(peerID.displayName) sent an invitation")
        invitationHandler(true, self.session.session)
        
        let alert = NSAlert()
        alert.messageText = "Networking"
        alert.informativeText = "Successfully connected to \(peerID.displayName)!"
        alert.addButton(withTitle: "Done")
        let _ = alert.runModal()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if(self.lookingFor == "all" || self.lookingFor == peerID.displayName) {
            NSLog("%@", "foundPeer: \(peerID)")
            browser.invitePeer(peerID, to: session.session, withContext: nil, timeout: 30)
        }else {
            NSLog("%@", "foundUnwantedPeer: \(peerID)")
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        game.dataRecieved(data: data)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}
