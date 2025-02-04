//
//  MusicMonitor.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/3/25.
//
import MediaPlayer
import SwiftUI

class MusicMonitor: ObservableObject {
    private let player = MPMusicPlayerController.systemMusicPlayer
    @Published var curSong: Song = Song(title: "", artist: "", bpm: 0, duration: 0)
    
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main) { (note) in
                self.updateCurrentSong()
        }
        player.beginGeneratingPlaybackNotifications()
        updateCurrentSong() // Get initial song
    }
    private func updateCurrentSong() {
        if let nowPlayingItem = player.nowPlayingItem {
            withAnimation(.bouncy(duration: 0.5)){
                curSong = Song(title: nowPlayingItem.title ?? "No Title", artist: nowPlayingItem.artist ?? "No Artist", bpm: nowPlayingItem.beatsPerMinute, duration: nowPlayingItem.playbackDuration)
            }
            
        }
    }
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
}
