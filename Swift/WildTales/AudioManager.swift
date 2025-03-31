//
//  AudioManager.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import AVFoundation

class AudioManager {
    static var player: AVAudioPlayer?
    static var backgroundPlayer: AVAudioPlayer?

    static func startBackgroundMusic() {
        if backgroundPlayer == nil {
            guard let path = Bundle.main.path(forResource: "music2.m4a", ofType: nil) else {
                print("Background music file not found")
                return
            }
            let url = URL(fileURLWithPath: path)
            
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundPlayer?.volume = 0.3
                backgroundPlayer?.play()
            } catch {
                print("Error playing background music: \(error.localizedDescription)")
            }
        } else {
            backgroundPlayer?.play()
        }
    }

    static func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }

    static func playSound(soundName: String, soundVol: Float) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            print("Sound path not created")
            return
        }

        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = soundVol
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
