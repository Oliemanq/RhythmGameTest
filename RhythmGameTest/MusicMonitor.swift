//
//  MusicMonitor.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/3/25.
//
import MediaPlayer
import SwiftUI
import Foundation
import SwiftData

class MusicMonitor: ObservableObject {
    private let player = MPMusicPlayerController.systemMusicPlayer
    @Published var curSong: Song = Song(title: "", artist: "", bpm: 0, duration: .seconds(0))
    private var songMatch: Bool = false
    
    private let modelContext: ModelContext
    private var items: [DataItem]
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Fetch items using the context
        let descriptor = FetchDescriptor<DataItem>(sortBy: [SortDescriptor(\.name)])
        self.items = (try? modelContext.fetch(descriptor)) ?? []
        
        // Rest of your init code
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main) { [weak self] (note) in
                self?.updateCurrentSong()
        }
        
        player.beginGeneratingPlaybackNotifications()
        updateCurrentSong()
    }
    
    private func updateCurrentSong() {
        if let nowPlayingItem = player.nowPlayingItem {
            for item in self.items{
                if item.name == nowPlayingItem.title{
                    let tempDuration = item.duration
                    curSong = Song(title: item.name,
                                   artist: item.artist,
                                   bpm: item.bpm,
                                   duration: .seconds(Int(tempDuration)))
                    songMatch = true
                }
            }
            if !songMatch{
                let tempDuration = nowPlayingItem.playbackDuration
                curSong = Song(title: nowPlayingItem.title ?? "No Title",
                               artist: nowPlayingItem.artist ?? "No Artist",
                               bpm: nowPlayingItem.beatsPerMinute,
                               duration: .seconds(Int(tempDuration)))
            }
            
        }
    }
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
}

struct Song{
    var title: String
    var artist: String
    var bpm: Int
    var duration: Duration
}
