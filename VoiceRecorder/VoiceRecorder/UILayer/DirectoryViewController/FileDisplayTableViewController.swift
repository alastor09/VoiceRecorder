//
//  FileDisplayTableViewController.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 27/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import UIKit

class FileDisplayTableViewController: UITableViewController {

    var filePath: String?
    var fileDisplayViewModel: FileDisplayViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        fileDisplayViewModel = FileDisplayViewModel(filePath: self.filePath!)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fileDisplayViewModel?.fileDisplayData?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let modelObj = self.fileDisplayViewModel?.fileDisplayData?[indexPath.row]{
            switch modelObj.fileType {
            case .Directory:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            case .RecordedFile:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as! RecordedFileTableViewCell
                cell.configureView(fileMetadata: modelObj)
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell", for: indexPath)
            return cell
        }
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let modelObj = self.fileDisplayViewModel?.fileDisplayData?[indexPath.row]{
                self.fileDisplayViewModel?.removeFileWithMetaData(fileMetaData: modelObj, index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let modelObj = self.fileDisplayViewModel?.fileDisplayData?[indexPath.row]{
            switch modelObj.fileType {
            case .Directory:
                return 65
            case .RecordedFile:
                return 65
            }
        }
        else{
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "playSound", sender: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSound"{
            let destinationView: MediaPlayerViewController = segue.destination as! MediaPlayerViewController
            
            if let indexSelected = self.tableView.indexPathForSelectedRow {
                let playerData = self.fileDisplayViewModel?.fileDisplayData?[indexSelected.row]
                destinationView.playerData = playerData
            }
        }
    }

}
