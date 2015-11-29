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
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        speakTheText("Pause continue.")
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        speakTheText("Go forward one sentence.")
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        speakTheText("Go back one sentence.")
    }

    @IBAction func doubleSwipeLeft(sender: UISwipeGestureRecognizer) {
        speakTheText("Go forward one paragraph.")
    }
    
    @IBAction func doubleSwipeRight(sender: UISwipeGestureRecognizer) {
        speakTheText("Go back one paragraph.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Navigation Training"

        // Do any additional setup after loading the view.
        speechSynthesizer.delegate = self
        
        
        var trainingInstructions = "This screen provides an opportunity for you to practice navigating the text. You may be able to access the training easier by turning your device sideways. "
        trainingInstructions.appendContentsOf("There are five types of navigation. Tapping the screen alternaytes the pausing and starting the speech. Swiping right with a single finger navigates back one sentence. Swiping left navigates forward one sentence. By swiping with two fingers, you will navigate by paragraph. Try these gestures now. When you are finished, tap the continue button at the top of the view.")
        
        
        speakTheText(trainingInstructions)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setViewControllers([self], animated: false)
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.enabled = true
        }
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        
        for gesture in view.gestureRecognizers! {
            gesture.enabled = false
        }
    }

    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private func speakTheText(theText: NSString) {
        speechSynthesizer.speakUtterance(AVSpeechUtterance(string: theText as String))
        
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
