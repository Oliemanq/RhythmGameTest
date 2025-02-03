//
//  SecondaryView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/3/25.
//

import SwiftUI
import MediaPlayer
import Darwin
import WatchConnectivity

struct SecondaryView: View {
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    
    var body: some View {
        Text("Game screen")
            .underline()
            .multilineTextAlignment(.center)
            .frame(width: getWidth(wid: "Game screen", font: fontSize), height: getHeight(wid: "Game screen"))
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .shadow(color:.gray,radius: 3)
            .offset(x: 0, y: -325)
        
    }
    
}

#Preview {
    SecondaryView()
}
