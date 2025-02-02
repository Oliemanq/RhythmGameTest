//
//  ContentView.swift
//  RhythmGameTest Watch App
//
//  Created by Oliver Heisel on 1/30/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack{
            Text(UserDefaults.standard.string(forKey: "textOnWatch") ?? "No message")
            
            Button("Watch to phone") {
                watchToPhone()
            }.handGestureShortcut(.primaryAction);
            
            Button("Watch to watch"){
                watchToWatch()
            }
        }
    }
}

func watchToPhone(){
    print("Ran watchToPhone")
    UserDefaults.standard.set("Hello from Watch", forKey: "textOnPhone")
}
func watchToWatch(){
    print("ran watchToWatch")
    UserDefaults.standard.set("Hello from Phone", forKey: "textOnWatch")
}



