//
//  NetworkSession.swift
//  Engine
//
//  Created by Benjamin M. Pringle on 3/7/20.
//  Copyright © 2020 Benjamin M. Pringle. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkSession {
    var serviceName: String!
    var delegate: NetworkDelegate!
    
    lazy var session: MCSession = {
        let session = MCSession(peer: NetworkHandler.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = delegate
        return session
    }()
    
    init(serviceName: String, delegate: NetworkDelegate) {
        self.serviceName = serviceName
        self.delegate = delegate
    }
}
