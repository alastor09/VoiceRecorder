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
            return "Recording.."
        case .Failed:
            return "Re-Record"
        case .Done:
            return "Record"
        }
    }
}
