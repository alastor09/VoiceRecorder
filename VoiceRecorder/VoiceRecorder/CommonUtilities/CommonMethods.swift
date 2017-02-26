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
    
    public class func getAllFilesInDocumentsDirectory() -> [String]?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] 
        let manager = FileManager.default
        var allItems: [String]?
        do {
            allItems = try manager.contentsOfDirectory(atPath: documentDirectory)
            print(allItems)
        } catch  {
        }
        return allItems
    }
}
