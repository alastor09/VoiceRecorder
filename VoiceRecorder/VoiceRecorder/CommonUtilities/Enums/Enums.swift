//
//  Enums.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation

enum RecordingState {
    case NotStarted
    case NotAllowed
    case Allowed
    case Started
    case Stopped
    case Completed
    case Failed
}

enum RecordButtonTitle: String{
    case NotStarted, GetAccess, OnGoing, Failed, Done
    func UIString() -> String {
        switch self {
        case .NotStarted:
            return "Record"
        case .GetAccess:
            return "Provide Access in Settings"
        case .OnGoing:
            return "Stop"
        case .Failed:
            return "Re-Record"
        case .Done:
            return "Record"
        }
    }
}

enum FileType{
    case Directory
    case RecordedFile
}

enum PlayerState{
    case Ready
    case Started
    case Stopped
    case Paused
    case Error
}

enum PlayButtonTitle: String{
    case NotStarted, Ready, Started, Paused, Stopped, Error
    func UIString() -> String {
        switch self {
        case .NotStarted:
            return "Waiting"
        case .Ready:
            return "Play"
        case .Started:
            return "Pause"
        case .Paused:
            return "Play"
        case .Stopped:
            return "Play"
        case .Error:
            return "Error"
        }
    }
}
