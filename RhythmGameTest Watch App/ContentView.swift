//
//  ContentView.swift
//  RhythmGameTest Watch App
//
//  Created by Oliver Heisel on 1/30/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject var WatchApp = watchApp()
    var body: some View {
        
        VStack{
            Text(WatchApp.textInput)
            
            Button("Click me!") {
                WatchApp.watchToWatch()
                WatchApp.watchToPhone()
            }.handGestureShortcut(.primaryAction);
        }
    }
}



