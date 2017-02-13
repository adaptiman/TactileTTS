//
//  TTSTrainingViewController.swift
//  TactileTTS
//
//  Created by Administrator on 11/19/15.
//  Copyright © 2017 David Sweeney. All rights reserved.
//

import UIKit
import AVFoundation

class TTSTrainingViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBAction func continueToProtocol(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showExperimentalProtocol", sender: nil)
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        userManager.writeGestureData("TPC",currentCursorPosition: 0)
        speakTheText("Pause or continue.")
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TF",currentCursorPosition: 0)
        speakTheText("Go forward one sentence.")
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TB",currentCursorPosition: 0)
        speakTheText("Go back one sentence.")
    }

    @IBAction func doubleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TFP",currentCursorPosition: 0)
        speakTheText("Go forward one paragraph.")
    }
    
    @IBAction func doubleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TBP",currentCursorPosition: 0)
        speakTheText("Go back one paragraph.")
    }
    
    fileprivate let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Training"

        // Do any additional setup after loading the view.
        
        speechSynthesizer.delegate = self
        speakTheText(userManager.trainingText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setViewControllers([self], animated: false)
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.isEnabled = true
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.isEnabled = false
        }
    }

    
    fileprivate let speechSynthesizer = AVSpeechSynthesizer()
    
    fileprivate func speakTheText(_ theText: NSString) {
        
        let theUtterance = AVSpeechUtterance(string: theText as String)
        
//        theUtterance.rate = userManager.rate
//        theUtterance.pitchMultiplier = userManager.pitch
        
        speechSynthesizer.speak(theUtterance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
