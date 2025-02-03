//
//  ContentView.swift
//  RhythmGameTest Watch App
//
//  Created by Oliver Heisel on 1/30/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject var watchToiOSConnector = WatchToiOSConnector()
    @State var textFrom = ""
    @State var textTo = ""
    var body: some View {
        
        VStack{
            Text(textFrom)
            
            TextField("Enter text to send", text: $textTo)
            
            Button("Watch to phone") {
                watchToiOSConnector.sendTextToiOS(textTo)
            }.handGestureShortcut(.primaryAction);
            
        }
    }
}
