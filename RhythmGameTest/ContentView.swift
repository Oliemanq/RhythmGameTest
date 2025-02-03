//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//
import SwiftUI
import SwiftData
import MediaPlayer
import Darwin
import WatchConnectivity

let musicPlayer = MPMusicPlayerController.systemMusicPlayer
var IOStoWatchConnector = iOStoWatchConnector()


class MusicMonitor: ObservableObject {
    private let player = MPMusicPlayerController.systemMusicPlayer
    @Published var songTitle: String = ""
    
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
                songTitle = nowPlayingItem.title ?? "No song playing" // Your next song logic here
            }
            
        }
    }
    deinit {
        player.endGeneratingPlaybackNotifications()
    }
}
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAlert = false
    @State private var musicPerms = MPMediaLibrary.authorizationStatus() == .authorized
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @StateObject private var musicMonitor = MusicMonitor()
    
    
    var body: some View {
        var fromWatch = IOStoWatchConnector.msg

        VStack {
            let songTitle = musicMonitor.songTitle
            
            //SONG TEXT_______________________________________________
            Text(songTitle)
                .underline()
                .multilineTextAlignment(.center)
                .frame(width: getWidth(wid: songTitle, font: fontSize), height: getHeight(wid: songTitle))
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)
                .shadow(color:.gray,radius: 3)
                .opacity(musicPerms ? 1:0)
                .padding(.vertical, 10)
                .offset(y:300)
            
            //BUTTON 1_________________________________________________
            if(!musicPerms){
                Button("Request music access"){
                    showAlert=true
                    requestMusicPermission()
                }
                    .frame(width: getWidth(wid: "Request music access", font: fontSize), height:getHeight(wid: "Request music access"))
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .background(Color.clear)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.gray, lineWidth: 2))
                    .shadow(color:.red,radius: 3)
                    .offset(y: -300)
            }else{
                Text("Music permission granted")
                    .frame(width: getWidth(wid: "Request music access", font: fontSize), height:getHeight(wid: "Request music access"))
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .background(Color.clear)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.gray, lineWidth: 2))
                    .shadow(color:.green,radius: 3)
                    .offset(y: -300)
            }
            
            Text(fromWatch)
                .underline()
                .multilineTextAlignment(.center)
                .frame(width: getWidth(wid: fromWatch, font: fontSize), height: getHeight(wid: fromWatch))
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: fontSize))
                .foregroundColor(.secondary)
                .shadow(color:.gray,radius: 3)
                .padding(.vertical, 10)
                .offset(y:100)
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
func getWidth(wid: String, font: CGFloat) -> CGFloat {
    if(wid.count > 25){
        return UIScreen.main.bounds.size.width * 0.8
    }else{
        return CGFloat(wid.count)*font/1.6
    }
}
func getHeight(wid: String) -> CGFloat {
    if (wid.count > 25){
        return UIScreen.main.bounds.size.height/10
    }else{
        return UIScreen.main.bounds.size.height/20
    }
}
