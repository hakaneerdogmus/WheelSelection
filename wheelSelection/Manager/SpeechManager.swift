//
//  SpeechManager.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 7.02.2024.
//

import Speech
import AVFoundation

class SpeechManager: ObservableObject {
    @Published var isAuthorized: Bool?
    @Published var text: String
    
    let synthesizer : AVSpeechSynthesizer
    
    init(isSpeakResultActive: Bool, text: String) {
        self.isAuthorized = isSpeakResultActive
        synthesizer = AVSpeechSynthesizer()
        self.text = text
    }
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
