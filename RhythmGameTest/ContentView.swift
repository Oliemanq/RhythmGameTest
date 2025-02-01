//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//

import SwiftUI
import WatchConnectivity
import MediaPlayer
import Darwin

let musicPlayer = MPMusicPlayerController.systemMusicPlayer
var songTitle = musicPlayer.nowPlayingItem?.title ?? "No song playing"


class MusicMonitor: ObservableObject {
    private let player = MPMusicPlayerController.systemMusicPlayer
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main) { (note) in
                self.updateCurrentSong()
                printTest(inp:("Song changed " + (self.player.nowPlayingItem?.title ?? "No song playing")))
        }
        
        player.beginGeneratingPlaybackNotifications()
        updateCurrentSong() // Get initial song
    }
    
    private func updateCurrentSong() {
        if let nowPlayingItem = player.nowPlayingItem {
            songTitle = nowPlayingItem.title ?? "No song playing" // Your next song logic here
        }
    }
    
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
}

struct ContentView: View {

    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var musicPerms = MPMediaLibrary.authorizationStatus() == .authorized
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    


    var body: some View {
        
        VStack {
            
            Text(songTitle)
            .underline()
            .frame(width: CGFloat(songTitle.count)*fontSize/1.4, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5.1)
            .opacity(musicPerms ? 1:0)
            .padding(.vertical, 10)

            
            
            //BUTTON 1________________________________________________
            Button("Reset song title"){
                showAlert1=true
            }.alert(songTitle, isPresented: $showAlert1) {
                Button("Cancel", role:.cancel) { }
                Button("Reset") {
                    songTitle = "No song playing"
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.6, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2.5))
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5.1)
            .opacity(musicPerms ? 1:0)
            
            //BUTTON 2_________________________________________________
            if(!musicPerms){
                Button("Request music access"){
                    showAlert2=true
                    requestMusicPermission()
                }
                .frame(width: CGFloat("request music access".count)*fontSize/2, height:UIScreen.main.bounds.size.height/20)
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)
                .background(Color.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.gray, lineWidth: 2))
                .shadow(color:.red,radius: 3)
                .offset(y: UIScreen.main.bounds.size.height/5)
            }else{
                Text("Music permission granted")
                    .frame(width: CGFloat("Music permission granted".count)*fontSize/2, height:UIScreen.main.bounds.size.height/20)
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .background(Color.clear)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.gray, lineWidth: 2))
                    .shadow(color:.green,radius: 3)
                    .offset(y: UIScreen.main.bounds.size.height/5)
            }
            
        }
    }
        
    func requestMusicPermission() {
        if MPMediaLibrary.authorizationStatus() == .denied {
            print("User has denied access to Apple Music. Direct them to Settings.")
        }else{
            MPMediaLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Access granted " + String(describing:musicPerms))
                case .denied, .restricted:
                    print("Access denied")
                case .notDetermined:
                    print("User hasn't chosen yet")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
}



#Preview {
    ContentView()
}

func printTest(inp: String){
    let input = inp;
    print(input);
}



