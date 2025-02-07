//
//  RhythmGameTestApp.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 1/30/25.
//

import SwiftUI
import SwiftData


@main
struct RhythmGameTestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: DataItem.self)
    }
}
