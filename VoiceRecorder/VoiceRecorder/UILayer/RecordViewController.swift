//
//  ViewController.swift
//  VoiceRecorder
//
//  Created by Soan Saini on 26/2/17.
//  Copyright © 2017 Soan Saini. All rights reserved.
//

import UIKit

class RecordViewController : UIViewController {

    var recorderViewModel: RecordViewModel?

    @IBOutlet weak var memoryLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        recorderViewModel = RecordViewModel(delegateRecordViewController: self, memoryViewController: self)
    }

    @IBAction func recordButtonClicked(_ sender: Any) {
        
        if let recordingState = recorderViewModel?.recordingState{
            switch recordingState {
            case .Allowed, .Stopped, .Completed:
                recorderViewModel?.startRecording()
            case .NotStarted:
                recorderViewModel?.configureVoiceRecorder()
            case .Started:
                recorderViewModel?.stopRecording(success: true)
            default: break
            }
        }
    }
    
    func updateButtonTitle(titleString: String) {
        self.recordButton.setTitle(titleString, for: .normal)
        self.recordButton.setTitle(titleString, for: .highlighted)
        self.recordButton.setTitle(titleString, for: .disabled)
        self.recordButton.setTitle(titleString, for: .selected)
    }
}

extension RecordViewController : RecordViewDelegates{
    func didFinishRecording(){
        self.updateButtonTitle(titleString:RecordButtonTitle.Done.UIString())
    }
    
    func didStartRecording(){
        self.updateButtonTitle(titleString:RecordButtonTitle.OnGoing.UIString())
    }
    
    func recordingAllowed(){
        self.updateButtonTitle(titleString:RecordButtonTitle.NotStarted.UIString())
    }
    
    func recordingNotAllowed(){
        self.updateButtonTitle(titleString:RecordButtonTitle.GetAccess.UIString())
    }
    
    func didFailedRecording(){
        self.updateButtonTitle(titleString:RecordButtonTitle.Failed.UIString())
    }
}

extension RecordViewController : MemoryDelegate{
    func currentMemoryString(memoryString: String){
        self.memoryLabel.text = memoryString
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFiles"{
            let destinationView: FileDisplayTableViewController = segue.destination as! FileDisplayTableViewController
            destinationView.filePath = CommonUtilities.getDocumentsDirectory().relativePath
        }
    }
}

