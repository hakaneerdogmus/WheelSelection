//
//  wheelSelectionApp.swift
//  wheelSelection
//
//  Created by Hakan ERDOĞMUŞ on 5.03.2024.
//

import SwiftUI

@main
struct wheelSelectionApp: App {

    @AppStorage("shouldPlaySound") private var shouldPlaySound: Bool = true
    @AppStorage("isSpeakResultActive") private var isSpeakResultActive: Bool = false
    @AppStorage("isDarkModEnabled") private var isDarkModEnabled: Bool = false
    @AppStorage("isVibration") private var isVibration: Bool = false
    

    var body: some Scene {
        WindowGroup {
            AnimationView(shouldPlaySound: $shouldPlaySound, isSpeakResultActive: $isSpeakResultActive, isDarkModEnabled: $isDarkModEnabled, isVibration: $isVibration)
                .preferredColorScheme(isDarkModEnabled ? .dark : .light)
                
        }
    }
}
