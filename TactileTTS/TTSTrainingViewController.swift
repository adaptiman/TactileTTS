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
    
    @IBOutlet var doubleSwipeLeft: UISwipeGestureRecognizer!
    
    @IBAction func doubleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        userManager.writeGestureData("TBP",currentCursorPosition: 0)
        speakTheText("Go back one paragraph.")
    }
    
    @IBOutlet var doubleSwipeRight: UISwipeGestureRecognizer!
    
    fileprivate let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Part 2 - Training"

        // Do any additional setup after loading the view.
        
        speechSynthesizer.delegate = self
        speakTheText(userManager.trainingText)
        
        //programmatically set numberOfTouchesRequired for doubleSwipeRight and doubleSwipeLeft to 2. Assigning greater than one touch at designtime in the storyboard causes a a known buffer overrun bug in UISwipeGestureRecognizer.  When a UISwipeGestureRecognizer's number of required touches is configured to be greater than 1 in a storyboard, the UISwipeGestureRecognizer fails to allocate a sufficiently large enough buffer to track the state of multiple (more than one) touches.  When more than one touch occurs the memory adjacent to the buffer is overwritten, leading to undefined behavior.
        
        //The workaround is to set the number of required touches for all swipe gesture recognizers in your storyboard to be 1.  If a swipe gesture recognizer requires more than one touch, modify its numberOfTouchesRequired property in code (in -viewDidLoad)
        
        self.doubleSwipeLeft.numberOfTouchesRequired = 2
        self.doubleSwipeRight.numberOfTouchesRequired = 2
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
