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
    @State var offset: CGSize = .zero
    @Environment(\.modelContext) private var context
    @Query(sort: \DataItem.name) private var items: [DataItem]
    
    
    var body: some View {
        let musicMonitor = MusicMonitor(modelContext: context)
        let song: Song = musicMonitor.curSong
        let beats = 60/(Double(song.bpm))
        var hit: Bool = false
        
        let timer1 = Timer.publish(
            every: TimeInterval(beats),       // Second
            tolerance: 0, // Gives tolerance so that SwiftUI makes optimization
            on: .main,      // Main Thread
            in: .common     // Common Loop
        ).autoconnect()
        
        VStack {
            
            Rectangle()
                .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                .opacity(isPlaying ? 1 : 0)
                .frame(width: 20, height: 20, alignment: .center)
                .offset(offset)
            
            Button("Play") {
                print("BPM: " + String(song.bpm))
                print("Beats: " + String(beats))
                isPlaying.toggle()
                print(isPlaying)
            }
            .frame(width: 60, height: 40)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.secondary, lineWidth: 1))
            .scaleEffect(isPlaying ? 1.2 : 1)
            .offset(x: 0, y: 275)
            
        }.onReceive(timer1) { (_) in
            hit = false
            
            withAnimation(.linear(duration: 0)) {
                offset.height = 250
                offset.width = 200
            }
            withAnimation(.linear(duration: TimeInterval(beats))) {
                offset.height = 250
                offset.width = -180
            }
            hit = true
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.3))
        
        
        
        
    }
}

#Preview {
    GameView()
}
