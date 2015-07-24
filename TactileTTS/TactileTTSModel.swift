//
//  TactileTTSModel.swift
//  TactileTTS
//
//  Created by Administrator on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import Foundation
import AVFoundation

class TactileTTSModel
{

    private var totalUtterances: Int = 0
    private var currentUtterance: Int = 0
    private var totalTextLength: Int = 0
    private var spokenTextLength: Int = 0
    
    private var rate: Float!
    private var pitch: Float!
    private var volume: Float!
    
    private let speechSynthesizer = AVSpeechSynthesizer()

    //housekeeping functions
    
    private func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<NSObject, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    private func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            return true
        }
        return false
    }
    
    //private speech synthesizer functions
    //
    //
    //
    
    //public functions
    //
    //
    //
    
    func playTTS(theText: String) {
        if theText != "" {
            
            let speechUtterance = AVSpeechUtterance(string: theText)
            if speechSynthesizer.speaking {
                if speechSynthesizer.paused {
                    speechSynthesizer.continueSpeaking()
                } else {
                    speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
                }
            } else {
                speechSynthesizer.speakUtterance(speechUtterance)
            }
        }
    }

        
        
        
        
    init() {  //initializer for the TactileTTS class
        
        if !loadSettings() {
            registerDefaultSettings()
        }
    }
}
