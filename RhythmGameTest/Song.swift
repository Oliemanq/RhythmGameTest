//
//  Song.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/3/25.
//

import Foundation
import SwiftUI

class Song{
    private var title = ""
    private var artist: String = ""
    private var bpm: Int = 0
    private var duration: Double = 0
    
    
    init(title: String, artist: String, bpm: Int, duration: Double){
        self.title = title
        self.artist = artist
        self.bpm = bpm
        self.duration = duration
    }
    
    public func getTitle() -> String{
        return title
    }
    
    public func getArtist() -> String{
        return artist
    }
    
    public func getBPM() -> Int{
        return bpm
    }
    public func getDuration() -> String {
        let form = NumberFormatter()
        form.minimumFractionDigits = 2
        form.maximumFractionDigits = 2
        let temp = duration/60
        var tempString: String = (form.string(for: temp) ?? "0.00")
        tempString.insert(":", at: tempString.index(tempString.endIndex, offsetBy: -2))
        tempString.remove(at: tempString.index(tempString.endIndex, offsetBy: -4))
        return tempString
    }
    
    public func setTitle(_ newTitle: String){
        title = newTitle
    }
    public func setArtist(_ newArtist: String){
        artist = newArtist
    }
    public func setBPM(_ newBPM: Int){
        bpm = newBPM
    }
    public func setDuration(_ newDuration: Double){
        duration = newDuration
    }
}
