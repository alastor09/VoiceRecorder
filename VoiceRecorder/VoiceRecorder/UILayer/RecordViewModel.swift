//
//  RecordViewModel.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation
import AVFoundation

class RecordViewModel{
    
    var recordingState: RecordingState = RecordingState.NotStarted
    
    var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var delegate:RecordViewDelegates

    init(delegateViewController: RecordViewDelegates) {
        self.delegate = delegateViewController
        self.checkCurrentPermission()
    }
    
    func checkCurrentPermission() {
        switch recordingSession.recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            self.delegate.recordingAllowed()
            break
        case AVAudioSessionRecordPermission.denied:
            self.delegate.recordingNotAllowed()
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
                        self.delegate.recordingAllowed()
                    } else {
                        self.recordingState = .NotAllowed
                        self.delegate.recordingNotAllowed()
                    }
                }
            }
        } catch {
            self.recordingState = .NotAllowed
            self.delegate.recordingNotAllowed()
        }
    }
    
    func startRecording() {
        self.recordingState = .Started

        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            self.delegate.didStartRecording()
        } catch {

        }
        
    }
    
    func stopRecording(success: Bool) {
        self.recordingState = .Stopped
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            self.delegate.didFinishRecording()
        } else {
            self.delegate.didFailedRecording()
        }
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
