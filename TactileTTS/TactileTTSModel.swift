//
//  TactileTTSModel.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import Foundation
import AVFoundation

class TactileTTSModel: NSObject, AVSpeechSynthesizerDelegate
{
    private var totalUtterances: Int! = 0
    private var currentUtterance: Int! = 0
    private var totalTextLength: Int! = 0
    private var spokenTextLength: Int! = 0
    private var currentCursorPosition: Int! = 0

    private var paragraphs: [AnyObject] = []
    private var paragraphCount: Int! = 0
    private var sentences: [AnyObject] = []
    private var sentenceCount: Int! = 0
    private var words: [AnyObject] = []
    private var wordCount: Int! = 0

    
    private var rate: Float! = 0.2
    private var pitch: Float! = 0.01
    private var volume: Float! = 1.0
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    
    override init() {
        //initializer for the TactileTTS class
        super.init()
        speechSynthesizer.delegate = self
    }
    
    //delegate functions
    //
    //
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        spokenTextLength = spokenTextLength + count(utterance.speechString.utf16) + 1
        println ("Spoken Text Lengths: \(spokenTextLength)") //this is the number of chars with a 0 array
        
        if currentUtterance == totalUtterances {
            //do something when the utterance is done
        }
        
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        currentUtterance = currentUtterance + 1
        println("Current Utterance: \(currentUtterance)")
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        
        currentCursorPosition = (spokenTextLength + characterRange.location)
        
    }
    
    //private speech synthesizer functions
    //
    //
    //
    
    private func start(speechUtterance: NSObject) -> (Bool) {
        //TODO: build start function
        return true
    }

    private func pause(speechUtterance: NSObject) -> (Bool) {
        //TODO: build pause function
        return true
    }

    private func unpause(speechUtterance: NSObject) -> (Bool) {
        //TODO: build unpause function
        return true
    }

    private func stop(speechUtterance: NSObject) -> (Bool) {
        //TODO: build stop function
        return true
    }

    private func getParagraphs(theText:NSString) -> (paragraphs:NSArray, paragraphCount:Int) {
        //load and calculate paragraphs
        paragraphs = theText.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n\n"))
        paragraphCount = paragraphs.count
        //        println("Paragraph Array = \(paragraphs)")
        //        for paragraph in paragraphs {
        //            println(paragraph)
        //        }
        println("Utternance level is: paragraph")
        println("Total number of paragraphs = \(paragraphCount)")
        return(paragraphs,paragraphCount)
    }
    
    private func getSentences(theText:NSString) -> (sentences:NSArray, sentenceCount:Int) {
        //load and calculate sentences
        sentences = theText.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".?!"))
        
        sentences.removeAtIndex(sentences.count-1) //removes blank sentence at end of array
        sentenceCount = sentences.count
        //        for sentence in sentences {
        //            println(sentence)
        //        }
        
        println("Utternance level is: sentence")
        println("Total number of sentences = \(sentenceCount)")
        return (sentences,sentenceCount)
    }
    
    private func getWords(theText:NSString) -> (words:NSArray, wordCount:Int) {
        //load and calculate words
        words = theText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        wordCount = words.count
        //        for word in words {
        //            println(word)
        //        }
        //        for (var i = 0; i < words.count ; i++) {
        //            println("\(i):\(words[i])")
        //        }
        //        println("Word 29: \(words[29])")
        //        println("Word 30: \(words[30])")
        println("Utternance level is: word")
        println("Total number of words = \(wordCount)")
        return(words,wordCount)
    }
    
    
    //TODO: Create review by sentence from left swipe
    
    //TODO: Create navigate forward by sentence from right swipe
    
    //public functions
    //
    //
    //
    
    func play(theText: NSString) {  //this entire func gets executed before speech starts
        let (utteranceArray, _) = getSentences(theText) //this parses by sentence
        
        totalUtterances = utteranceArray.count
        currentUtterance = 0
        totalTextLength = 0
        spokenTextLength = 0
        
        for utterance in utteranceArray {
            
            let speechUtterance = AVSpeechUtterance(string: utterance as! String)
            
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            speechUtterance.postUtteranceDelay = 0.005 //pause between array elements
            
            totalTextLength = totalTextLength + count((utterance as! String).utf16) + 1 //+1 added to allow for space between utterances
            //println("Number of chars in utterance: \(totalTextLength)") //# of chars in each utterance
            speechSynthesizer.speakUtterance(speechUtterance)            

        }
        println("Total text length: \(totalTextLength)")
    }
    
    func startStop() {
        println("Tapped at Cursor Position: \(currentCursorPosition)")
    }
    
    func goForward() {
        println("Swiped right")
    }
    
    func goBack() {
        println("Swiped left")
    }
    
    //    private func playTheSegment(theText: NSString) {
    //        if theText != "" {
    //
    //            let speechUtterance = AVSpeechUtterance(string: theText as String)
    //
    //            speechUtterance.rate = rate
    //            speechUtterance.pitchMultiplier = pitch
    //            speechUtterance.volume = volume
    //
    //            if speechSynthesizer.speaking {
    //                if speechSynthesizer.paused {
    //                    speechSynthesizer.continueSpeaking()
    //                } else {
    //                    speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
    //                }
    //            } else {
    //                speechSynthesizer.speakUtterance(speechUtterance)
    //            }
    //        }
    //    }
}
