//
//  AnimationView.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 9.02.2024.
//

import SwiftUI

struct AnimationView: View {
    
    @State private var isAnimation: Bool = false
    
    @Binding var shouldPlaySound: Bool
    @Binding var isSpeakResultActive: Bool
    @Binding var isDarkModEnabled: Bool
    @Binding var isVibration: Bool
    
    var body: some View {
        if isAnimation {
            ContentView(shouldPlaySound: $shouldPlaySound, isSpeakResultActive: $isSpeakResultActive, isDarkModEnabled: $isDarkModEnabled, isVibration: $isVibration)
                
        } else {
            LottieView(filename: "wheelSpin", onAnimationComplete: {
                withAnimation {
                        isAnimation = true
                }
            })
                .background(Color.gray)
        }
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView(shouldPlaySound: .constant(false), isSpeakResultActive: .constant(false), isDarkModEnabled: .constant(false), isVibration: .constant(false))
    }
}
