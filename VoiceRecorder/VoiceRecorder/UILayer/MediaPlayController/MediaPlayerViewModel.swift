//
//  MediaPlayerViewModel.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 27/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation
import AVFoundation

class MediaPlayerViewModel : NSObject{
    
    var playerDelegate:PlayerDelegate
    var playerData: FileMetadata
    var playerState: PlayerState = .Error

    var player:AVAudioPlayer = AVAudioPlayer()

    init(playerDelegate: PlayerDelegate, fileData: FileMetadata) {
        self.playerDelegate = playerDelegate
        self.playerData = fileData
    }
    
    func preparePlay() {
        do {
            player = try AVAudioPlayer(contentsOf: self.playerData.path)
            player.delegate = self
            player.prepareToPlay()
            playerState = .Ready
            playerDelegate.currentPlayerState(state: playerState)
            playerDelegate.playerTotalTime(totalTime: CommonUtilities.stringFromTimeInterval(interval:player.duration))
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    func playSound() {
        player.play()
        playerState = .Started
        playerDelegate.currentPlayerState(state: playerState)
    }
    
    func stopSound() {
        player.stop()
        playerState = .Stopped
        print(player.currentTime)
        player.currentTime = 0
        playerDelegate.currentPlayerState(state: playerState)
    }
    
    func pauseSound() {
        player.pause()
        playerState = .Paused
        playerDelegate.currentPlayerState(state: playerState)
    }
    
    func changeVolumeLevel(level: Float) {
        player.volume = level
    }
}

extension MediaPlayerViewModel: AVAudioPlayerDelegate{
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        self.stopSound()
    }
}

