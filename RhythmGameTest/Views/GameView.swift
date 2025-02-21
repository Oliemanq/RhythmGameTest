//
//  GameView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/14/25.
//

import SwiftData
import SwiftUI
import Foundation
import EffectsLibrary

struct GameView: View {
    var IOStoWatchConnector = iOStoWatchConnector()
    @State var isPlaying: Bool = true
    @State var offset: CGSize = CGSize(width: 0, height: 250)
    @Environment(\.modelContext) private var context
    @Query(sort: \DataItem.name) private var items: [DataItem]
    
    
    var body: some View {
        let musicMonitor = MusicMonitor(modelContext: context)
        let song: Song = musicMonitor.curSong
        let beats = 60/(Double(song.bpm))
        
        let timer1 = Timer.publish(
            every: TimeInterval(beats),       // Second
            tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
            on: .main,      // Main Thread
            in: .common     // Common Loop
        ).autoconnect()
        ZStack{
            VStack {
                Button(action: {
                    print("Tapped")
                }) {
                    Text("Hit button")
                        .frame(width: UIScreen.main.bounds.width-25, height: 110)
                        .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 55, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 55, style: .continuous).stroke(.secondary, lineWidth: 1))
                    
                }
                .offset(x: 0, y: -200)
                
                Button("Play") {
                    print("BPM: " + String(song.bpm))
                    print("Beats: " + String(TimeInterval(beats)))
                    isPlaying.toggle()
                    print(isPlaying)
                }
                .frame(width: 60, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.secondary, lineWidth: 1))
                .scaleEffect(isPlaying ? 1.2 : 1)
                .offset(x: 0, y: 275)
                .padding(.all, 10)
                
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 30, height: 30)
                    .offset(x:-160, y:250)
                
                //Block 1
                Rectangle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(offset)
                    .padding(.all, 0)
                //Block 2
                Rectangle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(offset)
                    .padding(.all, 0)
                
                //Block 3
                Rectangle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(offset)
                    .padding(.all, 0)
                
                //Block 4
                Rectangle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(offset)
                    .padding(.all, 0)
                    
                
                
                
            }.onReceive(timer1) { (_) in
                
                withAnimation(.linear(duration: 0)) {
                    offset.height = 250
                    offset.width = 200
                }
                withAnimation(.linear(duration: TimeInterval(beats-0.1))) {
                    offset.height = 250
                    offset.width = -160
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.3))
        
    }
    
    
}

#Preview {
    GameView()
}


func timeSync(bpm: Int){
    for _ in 0..<bpm {
        //spawnBlock()
    }
}


