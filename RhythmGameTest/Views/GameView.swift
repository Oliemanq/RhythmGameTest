//
//  GameView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/14/25.
//

import SwiftData
import SwiftUI

struct GameView: View {
    var IOStoWatchConnector = iOStoWatchConnector()
    @State var isPlaying: Bool = false
    @State var offset: CGSize = .zero
    @Environment(\.modelContext) private var context
    @Query(sort: \DataItem.name) private var items: [DataItem]
    
    
    var body: some View {
        var isPlaying = IOStoWatchConnector.show
        let musicMonitor = MusicMonitor(modelContext: context)
        let song: Song = musicMonitor.curSong
        let bps = song.bpm/60
        
        
        let timer1 = Timer.publish(
            every: TimeInterval(bps),       // Second
            tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
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
                print(isPlaying)
                IOStoWatchConnector.show.toggle()
            }
            .frame(width: 60, height: 40)
            .scaleEffect(isPlaying ? 1.2 : 1)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.secondary, lineWidth: 1))
            .scaleEffect(isPlaying ? 1.2 : 1)
            .offset(x: 0, y: 275)
            
        }.onReceive(timer1) { (_) in
            let offset = CGSize(
                width: 200,
                height: 250
            )
            withAnimation(.linear(duration: 0)) {
                self.offset = offset
            }
            sleep(UInt32(bps/2))
            self.offset = CGSize(
                width: 0,
                height: 250
            )
            withAnimation(.linear(duration: 0)) {
                self.offset = offset
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black.opacity(0.3))
        
        
        
        
    }
}

#Preview {
    GameView()
}
