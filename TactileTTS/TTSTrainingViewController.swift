//
//  TTSTrainingViewController.swift
//  TactileTTS
//
//  Created by Administrator on 11/19/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit
import AVFoundation

class TTSTrainingViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBAction func continueToProtocol(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showExperimentalProtocol", sender: nil)
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        userManager.writeGestureData("TPC",currentCursorPosition: 0)
        speakTheText("Pause or continue.")
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TF",currentCursorPosition: 0)
        speakTheText("Go forward one sentence.")
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TB",currentCursorPosition: 0)
        speakTheText("Go back one sentence.")
    }

    @IBAction func doubleSwipeLeft(sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TFP",currentCursorPosition: 0)
        speakTheText("Go forward one paragraph.")
    }
    
    @IBAction func doubleSwipeRight(sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TBP",currentCursorPosition: 0)
        speakTheText("Go back one paragraph.")
    }
    
    private let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Training"

        // Do any additional setup after loading the view.
        
        speechSynthesizer.delegate = self
        speakTheText(userManager.trainingText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setViewControllers([self], animated: false)
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.enabled = true
        }
        
        self.navigationItem.rightBarButtonItem?.enabled = true
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.enabled = false
        }
    }

    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private func speakTheText(theText: NSString) {
        
        let theUtterance = AVSpeechUtterance(string: theText as String)
        
//        theUtterance.rate = userManager.rate
//        theUtterance.pitchMultiplier = userManager.pitch
        
        speechSynthesizer.speakUtterance(theUtterance)
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
