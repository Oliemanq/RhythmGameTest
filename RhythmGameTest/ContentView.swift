//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

/*
 func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]){
 if WCSession.isSupported() {
 let session = WCSession.default
 session.delegate =
 session.activate()
 }
 }
 */

