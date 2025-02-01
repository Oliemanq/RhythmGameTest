//
//  Untitled.swift
//  RhythmGameTest
//
//  Created by Oliver Heisel on 2/1/25.
//
import Foundation
import SwiftUI

class watchApp: ObservableObject{
    @Published var textInput: String = ""

    public func phoneToWatch(){
        textInput = "Hello from Phone"
    }
    public func watchToPhone(){
        textInput = "Hello from Watch"
    }
    public func watchToWatch(){
        textInput = "Watch to watch"
    }
    
}
