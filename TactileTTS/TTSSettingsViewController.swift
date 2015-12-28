//
//  TTSSettingsViewController.swift
//  TactileTTS
//
//  Created by Administrator on 12/27/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit
import AVFoundation

class TTSSettingsViewController: UIViewController, AVSpeechSynthesizerDelegate  {
    
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBOutlet weak var pitchSlider: UISlider!
    
    @IBOutlet weak var testSpeechSettingsButton: UIButton!
    
    @IBAction func continueToOrientation(sender: AnyObject) {
        
        //write the speech settings to the standardUserDefaults
        userManager.rate = rateSlider.value
        userManager.pitch = pitchSlider.value
        
        //segue to the next view
        self.performSegueWithIdentifier("showOrientation", sender: nil)
    }
    
    @IBAction func testSpeechSettings(sender: AnyObject) {
        
        speakTheText("Merry had a little lamb. Its fleece was white as snow. And everywhere that merry went, the lamb was sure to go.")
    }
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private let userManager = UserManager.sharedInstance
    
    private let speechSettings = NSUserDefaults.standardUserDefaults()

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        self.testSpeechSettingsButton.enabled = true
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        
        self.testSpeechSettingsButton.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    private func speakTheText(theText: NSString) {
        
        let speechUtterance = AVSpeechUtterance(string: theText as String)
        
        speechUtterance.rate = rateSlider.value
        speechUtterance.pitchMultiplier = pitchSlider.value
        
        print("rate=\(rateSlider.value)")
        print("pitch=\(pitchSlider.value)")
        
        speechSynthesizer.speakUtterance(speechUtterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Speech Settings"
        
        //setup the speech delegate
        speechSynthesizer.delegate = self
        
        // rate values are pinned between AVSpeechUtteranceMinimumSpeechRate and AVSpeechUtteranceMaximumSpeechRate.
        // pitch [0.5 - 2] Default = 1
        // volume [0-1] Default = 1
        
        //setup the rate slider according to AVSpeechUtteranceMinimumSpeechRate and AVSpeechUtteranceMaximumSpeechRate
        rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        
        //read the speech variables and write them to the participant array
        userManager.rate = AVSpeechUtteranceDefaultSpeechRate
        userManager.pitch =  1.0
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //setup the sliders to reflect current values
        rateSlider.value = userManager.rate
        pitchSlider.value = userManager.pitch
        
        //give some instructions
        speakTheText("On this screen, you can adjust the speech settings. Currently, the settings are at the recommended level. The rate slider adjusts the speed at which the voice speaks. To test your settings, touch test settings. When you are done, touch the continue button.")
    }
}
