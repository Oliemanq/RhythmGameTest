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
        VStack{
            HStack{
                ForEach(items, id: \.id) { item in
                    var tempDur: Duration = .seconds(Double(item.duration))
                    
                    Text(item.name + " - ")
                    Text(item.artist + " | ")
                    Text(item.duration.formatted() + " - ")
                    Text("BPM: " + item.bpm)
                }
            }
        }
    }
}
