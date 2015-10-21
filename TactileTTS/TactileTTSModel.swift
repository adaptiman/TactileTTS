//
//  TactileTTSModel.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 by David Sweeney. All rights reserved.
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
//    private var utteranceArray: [AnyObject] = []
    private var utteranceArray:[(utterance: String, utteranceLength: Int)] = []
    private enum ParseType { case ByParagraph, BySentence, ByWord }
    
    private var rate: Float! = 0.55
    private var pitch: Float! = 0.01
    private var volume: Float! = 1.0
    private var postUtteranceDelay: Double! = 0.005
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    
    override init() {
        //initializer for the TactileTTS class
        super.init()
        speechSynthesizer.delegate = self
    }
    
    //delegate functions
    //
    //
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        spokenTextLength = spokenTextLength + utterance.speechString.utf16.count + 1
        //print ("Spoken Characters: \(spokenTextLength)") //this is the number of chars with a 0 array
        
        //if the utterance finished, increment the currentUtterance to the next utterance
        currentUtterance = currentUtterance + 1
        
        if currentUtterance == totalUtterances {
            //do something when the entire text is done
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        print("currentUtterance: \(currentUtterance)")
        print("spokenTextLength: \(spokenTextLength)")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        currentCursorPosition = (spokenTextLength + characterRange.location)
    }
    
    //private speech synthesizer functions
    //
    //
    //
    
    private func getParagraphs(theText:NSString) -> [(utterance: String, utteranceLength: Int)] {
//        //load and calculate paragraphs
//        utteranceArray = theText.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "\n\n"))
        return(utteranceArray)
    }
    
    private func getSentences(theText:NSString) -> [(utterance: String, utteranceLength: Int)] {
        //load and calculate sentences
        
        let tempArray = theText.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".?!"))
        for i in 0..<tempArray.count - 1 {
            if i == 0 { //this fixes the funky componentsSeparatedByCharactersInSet parsing on the first element
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 2)]
            } else {
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 1)]
            }
            print("\(utteranceArray[i])")
        }
        return (utteranceArray)
    }
    
//    private func getWords(theText:NSString) -> (NSArray) {
//        //load and calculate words
//        utteranceArray = theText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        return()
//    }
    
    private func parse(theText: NSString, parseMethod: ParseType) -> [(utterance: String, utteranceLength: Int)] {
        switch parseMethod {
        case .ByParagraph:
            _ = getParagraphs(theText)
            print("Utterance level is: paragraph")
        case .BySentence:
            _ = getSentences(theText)
            print("Utterance level is: sentence")
        case .ByWord:
//            _ = getWords(theText)
            print("Utterance level is: word")
        }
        
        //calculate total utterances
        totalUtterances = utteranceArray.count
        print("Total utterances = \(totalUtterances)")

        //calculate total characters
        totalTextLength = utteranceArray.reduce(0){$0 + $1.utteranceLength}
        print("Total chars: \(totalTextLength)") //# of chars in all utterances
        
        return utteranceArray
    }
    
    private func speak() {
        
        //for utterance in utteranceArray {
        
        for i in currentUtterance..<utteranceArray.count {
            
            let speechUtterance = AVSpeechUtterance(string: utteranceArray[i].0)
            
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            speechUtterance.postUtteranceDelay = postUtteranceDelay
            
            speechSynthesizer.speakUtterance(speechUtterance)
        }
    }

    //public functions
    //
    //
    //
    
    func startExperiment(theText: NSString) {
        utteranceArray = parse(theText, parseMethod: .BySentence) as [(utterance: String, utteranceLength: Int)]
        currentUtterance = 0
        spokenTextLength = 1
        speak()
    }
    
    func pauseContinue() {
        if speechSynthesizer.speaking {
            if speechSynthesizer.paused {
                print("C,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
                speechSynthesizer.continueSpeaking()
            } else {
                speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                print("P,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            }
        }
    }
    
    func goForward() {
        print("F,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")

        if currentUtterance == totalUtterances - 1 {
            //do nothing
        } else {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            spokenTextLength = spokenTextLength + utteranceArray[currentUtterance].utteranceLength
            currentUtterance = currentUtterance + 1
            speak()
        }
    }
    
    func goBack() {
        print("B,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
   
        if currentUtterance == 0 {
            //do nothing
        } else {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            currentUtterance = currentUtterance - 1
            spokenTextLength = spokenTextLength - utteranceArray[currentUtterance].utteranceLength
            speak()
        }
    }
}
