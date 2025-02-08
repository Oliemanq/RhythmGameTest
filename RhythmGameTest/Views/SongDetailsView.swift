//
//  SongDetailsView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/7/25.
//

import SwiftUI
import SwiftData
import MediaPlayer
import Darwin


struct SongDetailsView: View {
    @State private var showAlert = false
    @State private var musicPerms = true//FIX THIS MPMediaLibrary.authorizationStatus() == .authorized
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @State private var inBPMText: Int?
    @StateObject private var musicMonitor = MusicMonitor()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Query(sort: \DataItem.name) private var items: [DataItem]
    
    var height: CGFloat { UIScreen.main.bounds.height }
    var width: CGFloat { UIScreen.main.bounds.width }
    
    
    
    var body: some View {
        let song: Song = musicMonitor.curSong
        let darkMode: Bool = (colorScheme == .dark)
        VStack{
            Text(song.title)
                .underline()
                .multilineTextAlignment(.center)
                .frame(width: getWidth(wid: song.title, font: fontSize), height: getHeight(wid: song.title))
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: fontSize))
                .foregroundColor(darkMode ? .white : .secondary)
                .shadow(color:.gray,radius: 3)
                .opacity(musicPerms ? 1:0)
                .padding(.vertical, 10)
            
            Text(song.artist)
                .font(.system(size: fontSize))
                .foregroundColor(darkMode ? .white : .secondary)
                .shadow(color:.gray,radius: 3)
                .opacity(musicPerms ? 1:0)
                .padding(.vertical, 10)
            
            Text(song.duration.formatted())
                .font(.system(size: fontSize))
                .foregroundColor(darkMode ? .white : .secondary)
                .shadow(color:.gray,radius: 3)
                .opacity(musicPerms ? 1:0)
                .padding(.vertical, 10)
            
            
            Text(song.bpm.formatted())
                .font(.system(size: fontSize))
                .foregroundColor(darkMode ? .white : .secondary)
                .shadow(color:.gray,radius: 3)
                .opacity(musicPerms ? 1:0)
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    SongDetailsView()
}
