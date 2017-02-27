//
//  FileDisplayViewModel.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 27/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation


class FileDisplayViewModel{
 
    var fileDisplayData: [FileMetadata]?
    
    init(filePath: String) {
        self.fileDisplayData = CommonUtilities.getAllFilesInDirectoryPath(path: URL(fileURLWithPath: filePath))
    }
}
