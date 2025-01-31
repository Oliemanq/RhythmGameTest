//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//

import SwiftUI
import WatchConnectivity
import MediaPlayer
var text = "Hello World ";



struct ContentView: View {
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @State private var songTitle: String = "No song playing"
    
    
    var body: some View {
        VStack {
            Button(text+"1"){
                showAlert1=true
            }.alert(songTitle, isPresented: $showAlert1){}
            .frame(width: UIScreen.main.bounds.width/2, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2))
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5.1)
            
            
            Button(text+"2"){
                showAlert2=true
                fontSize = UIScreen.main.bounds.size.height/30
            }
            .alert("Hello World!", isPresented: $showAlert2){
                Button("trigger", role: .cancel){
                    fontSize -= 5
                }
            }
            .frame(width: UIScreen.main.bounds.width/2, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2))
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5)
        }
        .padding()
        .onAppear {
                    fetchNowPlaying()
                }
    }
    func fetchNowPlaying(){
        
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        if let nowPlayingItem = musicPlayer.nowPlayingItem {
            songTitle = nowPlayingItem.title ?? "Unknown Title"
        } else {
            songTitle = "No Song Playing"
        }
    }
}

#Preview {
    ContentView()
}

func printTest(){
    print("Action called");
}



