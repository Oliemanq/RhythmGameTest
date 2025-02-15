//
//  GameView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/14/25.
//

import SwiftUI



struct GameView: View {
    let timer1 = Timer.publish(
        every: 1,       // Second
            tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
            on: .main,      // Main Thread
            in: .common     // Common Loop
        ).autoconnect()
    let timer2 = Timer.publish(
            every: 0.1,       // Second
            tolerance: 0.1, // Gives tolerance so that SwiftUI makes optimization
            on: .main,      // Main Thread
            in: .common     // Common Loop
        ).autoconnect()

        @State var offset: CGSize = .zero
        @State var isPlaying: Bool = false

        var body: some View {
            VStack {
                
                Rectangle()
                    .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                    .opacity(isPlaying ? 1 : 0)
                    .frame(width: 20, height: 20, alignment: .center)
                    .offset(offset)
                    
                Button("Play") {
                    self.isPlaying.toggle()
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
            }
            .onReceive(timer2) { (_) in
                let offset = CGSize(
                    width: -150,
                    height: 250
                )
                withAnimation(.linear(duration: 0.5)) {
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
