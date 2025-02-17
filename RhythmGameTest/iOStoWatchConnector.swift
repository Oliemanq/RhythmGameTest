//
//  WatchConnector.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/2/25.
//

import Foundation
import WatchConnectivity
import SwiftData

class iOStoWatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    public var msg = ""
    public var show = false
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if (message["msg"] as! String == "ToggleIOS"){
            show.toggle()
            print("Toggled show " + String(show))
        }else{
            print(message)
            msg = message["msg"] as! String
            print(msg)
        }
        

        
        
    }
    
}
