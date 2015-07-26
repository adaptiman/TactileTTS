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
    //
    //
    //
    
    //private speech synthesizer functions
    //
    //
    //
    
    private func playTheSegment(theText: NSString) {
        if theText != "" {
            
            let speechUtterance = AVSpeechUtterance(string: theText as String)
            
            //          speechUtterance.rate = 0.25
            //          speechUtterance.pitchMultiplier = 0.01
            //          speechUtterance.volume = 1.00
            
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            
            
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
    
    private func getSentences(theText:NSString) -> (sentenceArray:NSArray, sentenceCount:Int) {
        var sentenceArray = theText.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ".?!"))
        let sentenceCount = sentenceArray.count
        return (sentenceArray,sentenceCount)
    }
    
    //TODO: Create review by sentence from left swipe
    
    //TODO: Create navigate forward by sentence from right swipe
    
    //public functions
    //
    //
    //
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<NSObject, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float { //if rate exists, chances are everything exists
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            return true
        }
        return false
    }
    
    func play(theText: NSString) {
        let (sentences,sentenceCount) = getSentences(theText)
        println("Total number of sentences = \(sentenceCount)")
        
        for sentence in sentences {
            println("\(sentence)")
        }
            
            
        playTheSegment(theText)
    }

    init() {  //initializer for the TactileTTS class

    }
}
