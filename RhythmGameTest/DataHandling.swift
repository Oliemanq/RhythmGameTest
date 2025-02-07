//
//  CSVHandling.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/6/25.
//
import Foundation
import SwiftData

@Model
class DataItem: Identifiable {
    
    var id: String
    var name: String
    var artist: String
    var duration: Duration
    var bpm: Int
    
    init(name: String, artist: String, duration: Duration, BPM: Int) {
        
        self.id = UUID().uuidString
        self.name = name
        self.artist = artist
        self.duration = duration
        self.bpm = BPM
        
        
    }
}
