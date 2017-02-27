//
//  RecordedFileTableViewCell.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 27/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import UIKit

class RecordedFileTableViewCell: UITableViewCell {

    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var recordedCellModel: RecordedFileModel?

    func configureView(fileMetadata: FileMetadata)  {
        recordedCellModel = RecordedFileModel(fileMetadata: fileMetadata)
        self.fileName.text = recordedCellModel?.fileName
        self.sizeLabel.text = recordedCellModel?.fileDetailString
    }
}


class RecordedFileModel {
    var fileMetadata: FileMetadata
    var fileName: String
    var fileDetailString: String
    
    init(fileMetadata: FileMetadata) {
        self.fileMetadata = fileMetadata
        self.fileName = fileMetadata.fileName
        self.fileDetailString = "File Size : \(CommonUtilities.fileSizeString(memoryBytes: fileMetadata.size))"
    }
}
