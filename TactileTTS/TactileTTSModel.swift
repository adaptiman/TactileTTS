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
    private var spokenTextLength: Int! = 1
    private var currentCursorPosition: Int! = 0
    private var utteranceArray:[(utterance: String, utteranceLength: Int)] = []
    private enum ParseType { case ByParagraph, BySentence, ByWord }
    private enum NavigationType { case Next, Backward, Forward, PausePlay }
    
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
        navigate(.Next)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        spokenTextLength = utteranceArray[0..<currentUtterance].reduce(0){$0 + $1.utteranceLength}
        
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
//            this fixes the funky componentsSeparatedByCharactersInSet parsing on the first
//            element, which does NOT have a space attached to the front of the string and
//            adds a space at the end of the string. In all other cases, the function
//            adds a space at the beginning of the string (from the space between the
//            sentences)
            if i == 0 {
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 2)]
            } else {
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 1)]
            }
//            print("\(utteranceArray[i])")
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
//            _ = getParagraphs(theText)
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
    
    private func navigate(navigate: NavigationType ) {
            
        switch navigate {
            
        case .Next:
            currentUtterance = currentUtterance + 1
            speak(currentUtterance)
            
        case .Forward:
            print("F,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            if currentUtterance !=  totalUtterances - 1 { //i.e. if it's NOT the last utterance
                speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                currentUtterance = currentUtterance + 1
                speak(currentUtterance)
            }
        case .Backward:
            print("B,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            if currentUtterance != 0 { //i.e. if it's NOT the first utterance
                speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                currentUtterance = currentUtterance - 1
                speak(currentUtterance)
            }
            
        case .PausePlay:
            print("PausePlay")
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
    }
    
    
    private func speak(utteranceIndex: Int) {
        speechSynthesizer.speakUtterance(AVSpeechUtterance(string: utteranceArray[utteranceIndex].utterance))
    }
    
    
    //public functions
    //
    //
    //
    
    func speakTheText(theText: NSString) {
        
        utteranceArray = parse(theText, parseMethod: .BySentence) as [(utterance: String, utteranceLength: Int)]

        speak(currentUtterance)
    }
    
    func pauseContinue() {
        navigate(.PausePlay)
    }
    
    func goForward() {
        navigate(.Forward)
    }
    
    func goBack() {
        navigate(.Backward)

    }
}
