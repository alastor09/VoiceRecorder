//
//  RecordViewModel.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation
import AVFoundation

let MB: Double = (1024*1024)
let GB: Double = (MB*1024)

class RecordViewModel{
    
    var recordingState: RecordingState = RecordingState.NotStarted
    
    var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    
    var recordViewDelegate:RecordViewDelegates
    var memoryDelegate:MemoryDelegate

    init(delegateRecordViewController: RecordViewDelegates,memoryViewController: MemoryDelegate ) {
        self.recordViewDelegate = delegateRecordViewController
        self.memoryDelegate = memoryViewController
        self.checkCurrentPermission()
        self.updateMemory()
    }
    
    func checkCurrentPermission() {
        switch recordingSession.recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            self.recordViewDelegate.recordingAllowed()
            break
        case AVAudioSessionRecordPermission.denied:
            self.recordViewDelegate.recordingNotAllowed()
            break
        case AVAudioSessionRecordPermission.undetermined: break
        default: break
        }
    }
    
    func configureVoiceRecorder() {
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordingState = .Allowed
                        self.recordViewDelegate.recordingAllowed()
                    } else {
                        self.recordingState = .NotAllowed
                        self.recordViewDelegate.recordingNotAllowed()
                    }
                }
            }
        } catch {
            self.recordingState = .NotAllowed
            self.recordViewDelegate.recordingNotAllowed()
        }
    }
    
    func startRecording() {
        self.recordingState = .Started

        let audioFilename = CommonUtilities.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            self.recordViewDelegate.didStartRecording()
        } catch {

        }
        
    }
    
    func stopRecording(success: Bool) {
        self.recordingState = .Stopped
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            self.recordViewDelegate.didFinishRecording()
        } else {
            self.recordViewDelegate.didFailedRecording()
        }
        
    }
    
    //MARK: - Memory Calculations
    
    func  updateMemory() {
        if let memoryBytes = CommonUtilities.deviceRemainingFreeSpaceInBytes(){
            
            let GbSpace = memoryBytes / GB
            let MbSpace = memoryBytes / MB
            
            var memoryString = "Memory Available: "
            
            if GbSpace >= 1.0 {
                let space = String(format: "%.2f GB",GbSpace)
                memoryString.append("\(space)")
            }
            else if MbSpace >= 1.0 {
                let space = String(format: "%.2f MB",MbSpace)
                memoryString.append("\(space)")
            }
            else{
                let space = String(format: "%.2f Bytes",memoryBytes)
                memoryString.append("\(space)")
            }
            
            self.memoryDelegate.currentMemoryString(memoryString:memoryString)
        }
    }
}
