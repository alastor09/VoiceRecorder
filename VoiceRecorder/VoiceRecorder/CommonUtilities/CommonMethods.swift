//
//  CommonMethods.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import Foundation

class CommonUtilities {
   public class func deviceRemainingFreeSpaceInBytes() -> Double? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                return nil
        }
        return freeSize.doubleValue
    }
    
    
   public class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public class func getAllFilesInDocumentsDirectory() -> [FileMetadata]?{
        let documentDirectory = self.getDocumentsDirectory()
        let allItems = CommonUtilities.getAllFilesInDirectoryPath(path: documentDirectory.absoluteURL)
        return allItems
    }
    
    public class func getAllFilesInDirectoryPath(path: URL) -> [FileMetadata]?{
        let manager = FileManager.default
        var allItems: [String]?
        var folders: [FileMetadata]? = []
        do {
            allItems = try manager.contentsOfDirectory(atPath: path.relativePath)
            for stringPaths in allItems! {
                let url = URL(fileURLWithPath: path.appendingPathComponent(stringPaths).relativePath)
                folders?.append(FileMetadata(path: url))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return folders
    }
    
    public class func removeFile(filePath:String) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    public class func fileSizeString(memoryBytes: Double) -> String{
        let GbSpace = memoryBytes / GB
        let MbSpace = memoryBytes / MB
        
        var memoryString = ""
        
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
        
        return memoryString
    }
    
    public class func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        let ms = Int(interval * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
}
