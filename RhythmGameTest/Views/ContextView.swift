//
//  ContextView.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/6/25.
//

import Foundation
import SwiftData
import SwiftUI

public struct ContextView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [DataItem]
    
    public var body: some View {
        List{
            ForEach(items) { item in
                let tempDur: Duration = .seconds(item.duration)
                let formattedDur = tempDur.formatted()
                VStack{
                    HStack{
                        Text(item.name)
                            .multilineTextAlignment(.center)
                        Text("|")
                            .padding(.all,0.5)
                        
                        Text(item.artist)
                            .multilineTextAlignment(.center)
                        Text("|")
                            .padding(.all,0.5)
                        
                        Text(String(formattedDur.suffix(formattedDur.count - 2)))
                            .multilineTextAlignment(.center)
                        Text("|")
                            .padding(.all,0.5)
                        
                        Text("BPM: " + String(item.bpm))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: UIScreen.main.bounds.width-20, height: 30)
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Button("Delete") {
                        self.context.delete(item)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width+10, height: UIScreen.main.bounds.height-50)
        
    }
}
