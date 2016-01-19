//
//  TTSOrientationViewController.swift
//  TactileTTS
//
//  Created by Administrator on 12/19/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit
import AVFoundation

class TTSOrientationViewController: UIViewController, AVSpeechSynthesizerDelegate {

   
    @IBOutlet weak var tvOrientation: UITextView!
    
    @IBAction func continueToTrainingOrProtocol(sender: AnyObject) {
        
        if speechSynthesizer.speaking {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }
        
        if self.userManager.participantGroup == 0 {
            self.performSegueWithIdentifier("showControlProtocol", sender: nil)
        } else {
            self.performSegueWithIdentifier("showTraining", sender: nil)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {

        self.navigationItem.rightBarButtonItem?.enabled = true
    }

    
    private let userManager = UserManager.sharedInstance
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tvOrientation.setContentOffset(CGPoint.zero, animated: false)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Instructions"
        // Do any additional setup after loading the view, typically from a nib.
        
        //set the tvOrientation text
        tvOrientation.text = userManager.orientationText as String
        //tvOrientation.font = UIFont(name: "System", size: 70)
        
        //process the text object through the speech navigation model
        //ttsProtocol.speakTheText(tvMaterial.text)
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //speak the protocol text
        //ttsProtocol.speakTheText(userManager.orientationText)
        
        speechSynthesizer.delegate = self
        speakTheText(userManager.orientationText)
    }

    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private func speakTheText(theText: NSString) {
        
        let theUtterance = AVSpeechUtterance(string: theText as String)
        
        theUtterance.rate = userManager.rate
        theUtterance.pitchMultiplier = userManager.pitch
        
        speechSynthesizer.speakUtterance(theUtterance)
    }

}
