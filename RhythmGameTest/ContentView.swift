//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//

import SwiftUI
import WatchConnectivity
var text = "Hello, World!";



struct ContentView: View {
    @State private var showAlert = false
    @State private var fontSize = 28.0
    
    var body: some View {
        VStack {
            Button(text){
                showAlert=true
                fontSize += 5
            }
            .alert("Hello World!", isPresented: $showAlert){
                Button("trigger", role: .cancel){
                    fontSize -= 5
                }
            }
            .frame(width: 250, height: 60)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2))
            .shadow(color:.gray,radius: 3)
        }
        .offset(y: 100)
        .padding()
    }
}

#Preview {
    ContentView()
}

func printTest(){
    print("Action called");
}
