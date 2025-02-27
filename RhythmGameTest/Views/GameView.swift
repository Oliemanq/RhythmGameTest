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

var score: Int = 0

struct GameView: View {
    var IOStoWatchConnector = iOStoWatchConnector()
    @State var isPlaying: Bool = false
    @State var blockPositions: [CGFloat] = [400, 400, 400, 400] // X positions, initialized off-screen
    @State var blockSpawnBeats: [Int] = [-1, -1, -1, -1] // Track when each block was spawned
    @State var beatCount: Int = 0
    @State private var startTime: Date?
    @State private var displayLink: CADisplayLink?
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @Query(sort: \DataItem.name) private var items: [DataItem]
    
    // Constants for layout
    let hitZoneX: CGFloat = 60 // Position of hit zone from left
    let blockY: CGFloat = 250  // Y position of blocks
    let screenWidth = UIScreen.main.bounds.width
    let blockWidth: CGFloat = 20
    let beatsToReachHitZone: Int = 2 // Number of beats it takes for a block to reach the hit zone

    
    var body: some View {
        let darkMode: Bool = (colorScheme == .dark)
        let musicMonitor = MusicMonitor(modelContext: context)
        let song: Song = musicMonitor.curSong
        let beatDuration = 60.0 / Double(max(song.bpm, 60))// Minimum BPM of 60 to avoid div by zero
        
        ZStack {
            // Background
            LinearGradient(colors: [Color(red: 164/255, green: 195/255, blue: 178/255),
                                    darkMode ? Color(red: 0/255, green: 15/255, blue: 0/255) : Color(red: 246/255, green: 255/255, blue: 248/255)],
                           startPoint: .topLeading,
                           endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Debug info at top
                Text("Song: \(song.title) | BPM: \(song.bpm) | Beat: \(beatCount)")
                    .font(.title)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                    .frame(width: UIScreen.main.bounds.width - 80)
                    .foregroundColor(.green)
                    
                Text("Score: \(score)")
                    .font(.title)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                    .frame(width: UIScreen.main.bounds.width - 80)
                
                Spacer()
                
                // Game area
                ZStack {
                    // Hit zone marker
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 30, height: 30)
                        .overlay(Rectangle().stroke(.white, lineWidth: 1.5))
                        .position(x: hitZoneX, y: blockY)
                    
                    // Blocks
                    ForEach(0..<4, id: \.self) { index in
                        Rectangle()
                            .fill(LinearGradient(colors: [.teal, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: blockWidth, height: blockWidth)
                            .overlay(Rectangle().stroke(.black, lineWidth: 0.5))
                            .position(x: blockPositions[index], y: blockY)
                            .opacity(blockPositions[index] < 400 ? 1 : 0)
                    }
                }
                .frame(height: 300) // Fixed height for game area
                
                Spacer()
                
                // Controls at bottom
                VStack(spacing: 20) {
                    Button(action: {
                        checkHits()
                    }) {
                        Text("Hit!")
                            .font(.title)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 80)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                    }
                    
                    Button(isPlaying ? "Pause" : "Play") {
                        isPlaying.toggle()
                        if isPlaying {
                            setupGame(song: song, beatDuration: beatDuration)
                        } else {
                            stopGame()
                        }
                    }
                    .padding()
                    .frame(width: 120)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            // Initialize blocks to starting positions
            resetBlocks()
        }
        .onDisappear {
            stopGame()
        }
    }
    
    // Setup the game with precise timing
    func setupGame(song: Song, beatDuration: Double) {
        resetBlocks()
        startTime = Date()
        beatCount = 0
        
        // Use CADisplayLink for smoother animation
        let target = DisplayLinkTarget {
            updateGame(song: song, beatDuration: beatDuration)
        }
        
        displayLink = CADisplayLink(target: target, selector: #selector(DisplayLinkTarget.update))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: .main, forMode: .common)
    }
    
    // Stop the game and cleanup
    func stopGame() {
        displayLink?.invalidate()
        displayLink = nil
        startTime = nil
        resetBlocks()
        beatCount = 0
    }
    
    // Update game state based on elapsed time
    func updateGame(song: Song, beatDuration: Double) {
        guard let startTime = startTime, isPlaying else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        let newBeatCount = Int(elapsedTime / beatDuration)
        
        // Only process when the beat changes
        if newBeatCount > beatCount {
            beatCount = newBeatCount
            
            // Spawn a new block on every beat
            spawnBlock(atBeat: beatCount)
        }
        
        // Update positions for all active blocks
        for i in 0..<blockPositions.count {
            if blockSpawnBeats[i] >= 0 {
                // Calculate how far the block should have moved since spawn
                let beatsElapsed = elapsedTime / beatDuration - Double(blockSpawnBeats[i])
                
                // Position calculation:
                // - Start at right edge
                // - Block should reach hit zone exactly on the nth beat (beatsToReachHitZone)
                // - Continue past hit zone after that
                
                // Total distance from spawn to hit zone
                let distanceToHitZone = screenWidth - hitZoneX
                
                // Progress from 0 to 1 (and beyond) based on beats elapsed versus target
                let progress = CGFloat(beatsElapsed / Double(beatsToReachHitZone))
                
                // Calculate position:
                // - At progress 0: position = screenWidth
                // - At progress 1: position = hitZoneX
                blockPositions[i] = screenWidth - (progress * distanceToHitZone)
                
                // If block has gone too far left, reset it
                if blockPositions[i] < -blockWidth {
                    blockPositions[i] = 400
                    blockSpawnBeats[i] = -1
                }
            }
        }
    }
    
    // Check if any blocks are in the hit zone
    func checkHits() {
        for i in 0..<blockPositions.count {
            if abs(blockPositions[i] - hitZoneX) < 20 {
                addScore()
                // Reset this block
                blockPositions[i] = 400
                blockSpawnBeats[i] = -1
            }
        }
    }
    
    // Reset all blocks to off-screen right
    func resetBlocks() {
        for i in 0..<blockPositions.count {
            blockPositions[i] = 400
            blockSpawnBeats[i] = -1
        }
    }
    
    // Find inactive block and spawn it
    func spawnBlock(atBeat: Int) {
        for i in 0..<blockPositions.count {
            if blockPositions[i] >= 400 {
                blockPositions[i] = screenWidth + blockWidth
                blockSpawnBeats[i] = atBeat
                break
            }
        }
    }
    
    func addScore(){
        score += 1
    }
}

// Helper class for CADisplayLink
class DisplayLinkTarget {
    private let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    @objc func update() {
        callback()
    }
}

#Preview {
    GameView()
}
