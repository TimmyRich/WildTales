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

    // call to when start background music
    static func startBackgroundMusic() {
        if backgroundPlayer == nil {
            guard let url = Bundle.main.url(forResource: "music1", withExtension: "m4a") else { //music1.m4a file
                print("Background music file not found")
                return
            }
            
            do { //try to play that file with AVAudioPlayer
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

    //for specifics sounds wiht string, volme as float from 0-1
    static func playSound(soundName: String, soundVol: Float) {
        let soundPath = soundName
        guard let url = Bundle.main.url(forResource: soundPath, withExtension: nil) else {
            print("Sound file not found: \(soundPath)") // if it deosnt erxit
            return
        }

        do { //attempt to play sound
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = soundVol
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
