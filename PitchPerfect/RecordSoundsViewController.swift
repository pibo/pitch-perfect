//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Felipe Ribeiro on 31/08/2018.
//  Copyright © 2018 Felipe Ribeiro. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            playSoundsViewController.recordedAudioURL = sender as! URL
        }
    }
    
    func getRecordingURL(filename: String, ext: String = "wav") -> URL? {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = [dir, "\(filename).\(ext)"]
        return URL(string: path.joined(separator: "/"))
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        
        // Get the AVAudioSession instance.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        // Start recording audio.
        try! audioRecorder = AVAudioRecorder(url: getRecordingURL(filename: "recordedVoice")!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        
        // Stop recording audio.
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: recorder.url)
        } else {
            print("Recording failed")
        }
    }
    
    func configureUI(isRecording: Bool) {
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        
        if isRecording {
            recordingLabel.text = "Recording in Progress…"
            recordingLabel.textColor = UIColor.orange
        } else {
            recordingLabel.text = "Tap to Record"
            recordingLabel.textColor = UIColor.black
        }
    }
}

