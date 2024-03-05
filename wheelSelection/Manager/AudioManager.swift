//
//  AudioManager.swift
//  selectionWheel
//
//  Created by Hakan ERDOĞMUŞ on 6.02.2024.
//


import AVFoundation

class AVAudioPlayerManager {
    static var shared = AVAudioPlayerManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    //Spund play
    func playSound(named soundName: String, withExtension ext: String = "mp3") {
        if let url = Bundle.main.url(forResource: soundName, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    //Sound stop
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
}


