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
            try recordingSession.setCategory(AVAudioSessionCategoryRecord)
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
        
        do{
            try AVAudioSession.sharedInstance().setActive(false)
        }
        catch{
            
        }
        
        if success {
            self.recordViewDelegate.didFinishRecording()
        } else {
            self.recordViewDelegate.didFailedRecording()
        }
        
    }
    
    //MARK: - Memory Calculations
    
    func  updateMemory() {
        if let memoryBytes = CommonUtilities.deviceRemainingFreeSpaceInBytes(){
            let memoryString = "Memory Available: \(CommonUtilities.fileSizeString(memoryBytes: memoryBytes)) "
            self.memoryDelegate.currentMemoryString(memoryString:memoryString)
        }
    }
}
