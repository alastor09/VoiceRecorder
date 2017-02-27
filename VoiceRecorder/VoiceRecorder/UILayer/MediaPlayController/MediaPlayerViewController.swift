//
//  MediaPlayerViewController.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 27/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import UIKit

class MediaPlayerViewController: UIViewController {

    var playerData: FileMetadata?
    var playerViewModel: MediaPlayerViewModel?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerViewModel = MediaPlayerViewModel(playerDelegate: self, fileData: playerData!)
        playerViewModel?.preparePlay()
        volumeSlider.value = 50
    }
    @IBAction func playButtonClicked(_ sender: Any) {
        if let playerSt = playerViewModel?.playerState{
            switch playerSt {
            case .Started:
                playerViewModel?.pauseSound()
                break
            default:
                playerViewModel?.playSound()
            }
        }
    }
    
    func updateButtonTitle(titleString: String) {
        self.playButton.setTitle(titleString, for: .normal)
        self.playButton.setTitle(titleString, for: .highlighted)
        self.playButton.setTitle(titleString, for: .disabled)
        self.playButton.setTitle(titleString, for: .selected)
    }
    @IBAction func sliderChanged(_ sender: Any) {
        let slider = sender as! UISlider
        playerViewModel?.changeVolumeLevel(level: slider.value)
    }
}

extension MediaPlayerViewController : PlayerDelegate {
    
    func currentPlayerState(state: PlayerState) {
        switch state {
        case .Error:
            self.updateButtonTitle(titleString:PlayButtonTitle.Error.UIString())
            break
        case .Ready:
            self.updateButtonTitle(titleString:PlayButtonTitle.Ready.UIString())
            break
        case .Paused:
            self.updateButtonTitle(titleString:PlayButtonTitle.Paused.UIString())
            break
        case .Stopped:
            self.updateButtonTitle(titleString:PlayButtonTitle.Stopped.UIString())
            break
        case .Started:
            self.updateButtonTitle(titleString:PlayButtonTitle.Started.UIString())
            break
        }
    }
    
    func playerTotalTime(totalTime: String) {
        self.timeLabel.text = totalTime
    }
}
