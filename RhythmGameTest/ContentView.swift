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
var text = "Hello World ";

struct ContentView: View {
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var musicPerms = false
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @State private var songTitle: String = "No song playing"
    
    
    
    var body: some View {
        
        VStack {
            Text(songTitle)
                .frame(width: UIScreen.main.bounds.width/1.6, height:UIScreen.main.bounds.size.height/20)
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)
                .background(Color.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.gray, lineWidth: 2))
                .shadow(color:.gray,radius: 3)
                .offset(y: UIScreen.main.bounds.size.height/5.1)
                .opacity(musicPerms ? 1 : 0)
                .onChange(of: songTitle, {
                    
                })
            
            //BUTTON 1________________________________________________
            Button("Display song title"){
                requestMusicPermission()
                fetchNowPlaying()
                showAlert1=true
            }.alert(songTitle, isPresented: $showAlert1) {
                Button("Reset") {
                    songTitle = "No song playing"
                }
                Button("Ok", role:.cancel) { }
            }
            .frame(width: UIScreen.main.bounds.width/1.6, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2))
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5.1)
            .opacity(musicPerms ? 1 : 0)
            
            //BUTTON 2_________________________________________________
            Button("Request music access"){
                showAlert2=true
                requestMusicPermission()
            }
            .frame(width: UIScreen.main.bounds.width/1.25, height:UIScreen.main.bounds.size.height/20)
            .font(.system(size: fontSize))
            .foregroundColor(.secondary)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.gray, lineWidth: 2))
            .shadow(color:.gray,radius: 3)
            .offset(y: UIScreen.main.bounds.size.height/5)
        }.onAppear(perform: fetchNowPlaying)
    }
    func requestMusicPermission() {
        if MPMediaLibrary.authorizationStatus() == .denied {
            print("User has denied access to Apple Music. Direct them to Settings.")
        }else{
            MPMediaLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Access granted")
                    musicPerms = true
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
    
    func fetchNowPlaying() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        print("ran "+songTitle)
        DispatchQueue.main.async {
            if let nowPlayingItem = musicPlayer.nowPlayingItem {
                songTitle = nowPlayingItem.title ?? "Unknown Title"
            } else {
                songTitle = "No Song Playing"
            }
        }
    }
}



#Preview {
    ContentView()
}

func printTest(){
    print("Action called");
}



