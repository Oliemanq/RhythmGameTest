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
    @State private var fontSize = UIScreen.main.bounds.size.height/22.5
    
    var body: some View {
        let textColor: Color = Color(red: 107/255, green: 144/255, blue: 128/255)
        ZStack{
            
            LinearGradient(colors: [Color(red: 164/255, green: 195/255, blue: 178/255),
                                    Color(red: 246/255, green: 255/255, blue: 248/255)],
                           startPoint: .topLeading,
                           endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            Text("Game screen")
                .foregroundColor(textColor)
                .font(.system(size: fontSize))
                .frame(width: getWidth(wid: "Game screen", font: fontSize), height: getHeight(wid: "Game screen"))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)
                .shadow(color:.gray,radius: 3)
                .offset(x: 0, y: -325)
        }
    }
    
}

#Preview {
    SecondaryView()
}
