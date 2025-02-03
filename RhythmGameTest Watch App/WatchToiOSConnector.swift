//
//  WatchToiOSConnector.swift
//  RhythmGameTest Watch App
//
//  Created by Oliver Heisel on 2/2/25.
//

import Foundation
import WatchConnectivity

class WatchToiOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sendTextToiOS(_ textIn: String) {
        if session.isReachable {
            let data: [String: Any] = [
                "msg": textIn
            ]
            session.sendMessage(data, replyHandler: nil)
        }else{
            print("session unreachable")
        }
    }
}
