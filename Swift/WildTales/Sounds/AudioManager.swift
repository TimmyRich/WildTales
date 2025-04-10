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
            guard let url = Bundle.main.url(forResource: "music2", withExtension: "m4a") else {
                print("Background music file not found")
                return
            }
            
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
        let soundPath = soundName
        guard let url = Bundle.main.url(forResource: soundPath, withExtension: nil) else {
            print("Sound file not found: \(soundPath)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = soundVol
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
