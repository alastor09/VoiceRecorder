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

    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var levelMeter: UISlider!
    @IBOutlet weak var memoryLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        recorderViewModel = RecordViewModel(delegateRecordViewController: self, memoryViewController: self)
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fileNameTextField.text = ""
    }
    
    @IBAction func recordButtonClicked(_ sender: Any) {
        
        if let recordingState = recorderViewModel?.recordingState{
            switch recordingState {
            case .Allowed, .Stopped, .Completed:
                if let fileName = self.fileNameTextField.text, !fileName.isEmpty{
                    recorderViewModel?.fileName = fileName
                    recorderViewModel?.startRecording()
                }
                else{
                    return
                }
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
        self.fileNameTextField.text = ""
        self.fileNameTextField.isEnabled = true
        self.levelMeter.value = 0
    }
    
    func didStartRecording(){
        self.updateButtonTitle(titleString:RecordButtonTitle.OnGoing.UIString())
        self.fileNameTextField.isEnabled = false
    }
    
    func recordingAllowed(){
        self.updateButtonTitle(titleString:RecordButtonTitle.NotStarted.UIString())
        self.fileNameTextField.isEnabled = true
        self.levelMeter.value = 0
    }
    
    func recordingNotAllowed(){
        self.updateButtonTitle(titleString:RecordButtonTitle.GetAccess.UIString())
        self.fileNameTextField.isEnabled = false
        self.levelMeter.value = 0
    }
    
    func didFailedRecording(){
        self.updateButtonTitle(titleString:RecordButtonTitle.Failed.UIString())
        self.fileNameTextField.isEnabled = false
        self.levelMeter.value = 0
    }
    func levelMeterValue(lowPassResult: Double){
        self.levelMeter.value = Float(lowPassResult)
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


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
