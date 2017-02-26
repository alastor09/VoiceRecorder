//
//  FileMetadata.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation

class FileMetadata {
    var path: URL
    var fileName: String
    var fileExtension: String
    var fileType: FileType
    var size: Double
    init(path:URL) {
        self.path = path
        self.fileName = path.lastPathComponent
        self.fileExtension = path.pathExtension
        do{
            let attr = try FileManager.default.attributesOfItem(atPath: path.absoluteString)
            self.size = Double(attr[FileAttributeKey.size] as! UInt64)
        }
        catch{
            self.size = 0.0
        }
        if self.fileExtension == "m4a"{
            fileType = .RecordedFile
        }
        else{
            fileType = .Directory
        }
    }
}
