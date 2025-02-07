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


struct MainView: View {
    @State private var showAlert = false
    @State private var musicPerms = true//FIX THIS MPMediaLibrary.authorizationStatus() == .authorized
    @State private var fontSize = UIScreen.main.bounds.size.height/30
    @State private var inBPMText: Int?
    @StateObject private var musicMonitor = MusicMonitor()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) public var context
    var height: CGFloat { UIScreen.main.bounds.height }
    var width: CGFloat { UIScreen.main.bounds.width }
    
    
    
    var body: some View {
        let fromWatch = IOStoWatchConnector.msg
        var song: Song = musicMonitor.curSong
        let darkMode: Bool = (colorScheme == .dark)
        
        NavigationStack {
            ZStack {
                VStack{
                    //SONG TEXT_______________________________________________
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
                    
                    
                    TextField(
                        "Enter new bpm",
                        value: $inBPMText,
                        format:.number)
                        .font(.system(size: fontSize))
                        .foregroundColor(darkMode ? .white :.secondary)
                        .frame(width: getWidth(wid: "Change BPM", font: fontSize), height:getHeight(wid: "Change BPM"))
                        .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                    
                    Button("Change BPM"){
                        song.bpm = inBPMText ?? 0
                    }
                    .font(.system(size: fontSize))
                    .foregroundColor(darkMode ? .white :.secondary)
                    .frame(width: getWidth(wid: "Change BPM", font: fontSize), height:getHeight(wid: "Change BPM"))
                    .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))

                    
                    Button("Save song"){
                        if song.bpm != 0{
                            let item = DataItem(
                                name: song.title,
                                artist: song.artist,
                                duration: song.duration,
                                BPM: song.bpm
                            )
                            print(item.name)
                            context.insert(item)
                        }else{
                            showAlert = true
                        }
                    }
                    .font(.system(size: fontSize))
                    .foregroundColor(darkMode ? .white :.secondary)
                    .frame(width: getWidth(wid: "Save song", font: fontSize), height:getHeight(wid: "save song"))
                    .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                    .alert(
                        "Please enter a BPM",
                        isPresented: $showAlert){
                            Button("OK"){
                                self.showAlert = false
                            }
                        }
                    
                    NavigationLink(destination: ContextView()){
                        Text("Show saved songs")
                            .font(.system(size: fontSize))
                            .foregroundColor(darkMode ? .white :.secondary)
                            .frame(width: getWidth(wid: "Show saved songs", font: fontSize), height:getHeight(wid: "Show saved songs"))
                            .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                            .navigationBarBackButtonHidden(true)
                    }
                }.offset(y: 150)
                VStack{
                //BUTTON 1_________________________________________________
                if(!musicPerms){
                    Button("Request music access"){
                        showAlert=true
                        requestMusicPermission()
                    }
                    .frame(width: getWidth(wid: "Request music access", font: fontSize), height:getHeight(wid: "Request music access"))
                    .font(.system(size: fontSize))
                    .foregroundColor(darkMode ? .white : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .gray, lineWidth: 1))
                    .shadow(color:.red,radius: 3)
                    .offset(y: -300)
                }else{
                    Text("Music permission granted")
                        .frame(width: getWidth(wid: "Request music access", font: fontSize), height:getHeight(wid: "Request music access"))
                        .font(.system(size: fontSize))
                        .foregroundColor(darkMode ? .white : .secondary)
                        .background(darkMode ? Color(red: 30/255, green: 50/255, blue: 30/255) : Color(red: 225/255, green: 255/255, blue: 225/255), in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .gray, lineWidth: 1))
                        .shadow(color:.green,radius: 2)
                        .offset(y: -300)
                }
                //BUTTON 2____________________________________________________-
                    NavigationLink(destination: SecondaryView()) {
                        Text("Next screen")
                            .font(.system(size: fontSize))
                            .foregroundColor(darkMode ? .white :.secondary)
                            .frame(width: getWidth(wid: "Next screen", font: fontSize), height:getHeight(wid: "Next screen"))
                            .background(.ultraThinMaterial, in:RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(darkMode ? .white : .secondary, lineWidth: 1))
                            .navigationBarBackButtonHidden(true)
                    }.offset(y:-400)
                }.offset(y:200)
                
            }
            .frame(width: width, height: height)
            .background(LinearGradient(colors: [darkMode ? Color(red: 25/255, green: 10/255, blue: 10/255) : Color.white,
                                                darkMode ? Color(red: 255/255, green: 100/255, blue: 100/255) : Color.pink],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing))
                                
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
    }else if (wid.count < 11) && (CGFloat(wid.count)*font-95 > 0){
        return CGFloat(wid.count)*font-95
    }else{
        return CGFloat(wid.count)*font/1.7
    }
}
func getHeight(wid: String) -> CGFloat {
    if (wid.count > 25){
        return UIScreen.main.bounds.size.height/10
    }else{
        return UIScreen.main.bounds.size.height/20
    }
}


