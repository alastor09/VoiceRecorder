//
//  File.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation

protocol RecordViewDelegates {
    func didFinishRecording()
    func didFailedRecording()
    func didStartRecording()
    func recordingAllowed()
    func recordingNotAllowed()
    func levelMeterValue(lowPassResult: Double)
}

protocol MemoryDelegate {
    func currentMemoryString(memoryString: String)
}

protocol PlayerDelegate {
    func currentPlayerState(state: PlayerState)
    func playerTotalTime(totalTime:String)
}
