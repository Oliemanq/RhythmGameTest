//
//  ContentView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//
import SwiftUI
import MediaPlayer
import Darwin
import WatchConnectivity

let musicPlayer = MPMusicPlayerController.systemMusicPlayer
var IOStoWatchConnector = iOStoWatchConnector()

struct MainView: View {
    @State private var showAlert = false
    @State private var musicPerms = MPMediaLibrary.authorizationStatus() == .authorized
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @StateObject private var musicMonitor = MusicMonitor()
    
    var body: some View {
        let fromWatch = IOStoWatchConnector.msg
        let song: Song = musicMonitor.curSong
        
        ZStack {
            VStack {
                //SONG TEXT_______________________________________________
                Text(song.getTitle())
                    .underline()
                    .multilineTextAlignment(.center)
                    .frame(width: getWidth(wid: song.getTitle(), font: fontSize), height: getHeight(wid: song.getTitle()))
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .shadow(color:.gray,radius: 3)
                    .opacity(musicPerms ? 1:0)
                    .padding(.vertical, 10)
                    .offset(y:300)
                
                Text(song.getArtist())
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .shadow(color:.gray,radius: 3)
                    .opacity(musicPerms ? 1:0)
                    .padding(.vertical, 10)
                
                Text(song.getDuration())
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .shadow(color:.gray,radius: 3)
                    .opacity(musicPerms ? 1:0)
                    .padding(.vertical, 10)
                
                Text(String(song.getBPM()))
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .shadow(color:.gray,radius: 3)
                    .opacity(musicPerms ? 1:0)
                    .padding(.vertical, 10)
                
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
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.gray, lineWidth: 1))
                    .shadow(color:.red,radius: 3)
                    .offset(y: -300)
                }else{
                    Text("Music permission granted")
                        .frame(width: getWidth(wid: "Request music access", font: fontSize), height:getHeight(wid: "Request music access"))
                        .font(.system(size: fontSize))
                        .foregroundColor(.secondary)
                        .background(Color(red: 225/255, green: 255/255, blue: 225/255), in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.gray, lineWidth: 1))
                        .shadow(color:.green,radius: 2)
                        .offset(y: -300)
                }
                //BUTTON 2____________________________________________________-
                Text("Next screen")
                    .font(.system(size: fontSize))
                    .foregroundColor(.secondary)
                    .frame(width: getWidth(wid: "Next screen", font: fontSize), height:getHeight(wid: "Next screen"))
                    .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(.secondary, lineWidth: 1))
                    .offset(y: -400)
                    

                //TEXT FROM WATCH_______________________________________________
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
            LinearGradient(colors: [.white,.pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
                .zIndex(-2)
            
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
    MainView()
}

func printTest(inp: String){
    let input = inp;
    print(input);
}
func getWidth(wid: String, font: CGFloat) -> CGFloat {
    if(wid.count > 25){
        return UIScreen.main.bounds.size.width * 0.8
    }else{
        return CGFloat(wid.count)*font/1.75
    }
}
func getHeight(wid: String) -> CGFloat {
    if (wid.count > 25){
        return UIScreen.main.bounds.size.height/10
    }else{
        return UIScreen.main.bounds.size.height/20
    }
}
