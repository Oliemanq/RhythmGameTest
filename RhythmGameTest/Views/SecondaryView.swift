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
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        let darkMode: Bool = (colorScheme == .dark)
        let textColor: Color = darkMode ? Color(red: 200/255, green: 255/255, blue: 200/255) : Color(red: 107/255, green: 144/255, blue: 128/255)
        ZStack{
            LinearGradient(colors: [Color(red: 164/255, green: 195/255, blue: 178/255),
                                    darkMode ? Color(red: 0/255, green: 15/255, blue: 0/255) : Color(red: 246/255, green: 255/255, blue: 248/255)],
                           startPoint: .topLeading,
                           endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            Text("Game selector")
                .foregroundColor(textColor)
                .font(.system(size: fontSize))
                .frame(width: getWidth(wid: "Game selector", font: fontSize), height: getHeight(wid: "Game selector"))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(textColor, lineWidth: 1))
                .font(.system(size: fontSize))
                .foregroundColor(darkMode ? Color(red: 50/255, green: 75/255, blue: 60/255) : .secondary)
                .offset(x: 0, y: -325)
            HStack{
                NavigationLink(destination: GameView()){
                    Text("Current Song")
                        .foregroundColor(textColor)
                        .font(.system(size: fontSize-15))
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(textColor, lineWidth: 1))
                        .font(.system(size: fontSize))
                        .foregroundColor(darkMode ? Color(red: 50/255, green: 75/255, blue: 60/255) : .secondary)
                        .padding(.trailing, 10)
                        .shadow(color:.green, radius: 0.2)
                }
                NavigationLink(destination: GameView()){
                    Text("Curated playlist")
                        .foregroundColor(textColor)
                        .font(.system(size: fontSize-15))
                        .multilineTextAlignment(.center)
                        .frame(width: 100, height: 100)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(textColor, lineWidth: 1))
                        .font(.system(size: fontSize))
                        .foregroundColor(darkMode ? Color(red: 50/255, green: 75/255, blue: 60/255) : .secondary)
                        .padding(.leading, 10)
                        .shadow(color:.green, radius: 0.2)
                }
            }.offset(y:200)
        }
    }
    
}

#Preview {
    SecondaryView()
}
