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
    
    @Attribute(.unique)var id: String
    var name: String
    var artist: String
    var duration: Double
    var bpm: Int
    
    init(name: String, artist: String, duration: Duration, bpm: Int) {
        
        self.id = UUID().uuidString
        self.name = name
        self.artist = artist
        self.duration = Double(duration.components.seconds)
        self.bpm = bpm
        
        
    }
}
