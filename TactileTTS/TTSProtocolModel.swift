//
//  TTSModel.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 by David Sweeney. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct ProtocolCompleted { //NSNotification object definition
    static let Notification = "TTS Response Result"
    static let Key = "Response Result"
}

struct PercentCompleted {
    static let Notification = "TTS Percent Completed"
    static let Key = "Percent Completed"
}

class TTSModel: UIResponder, AVSpeechSynthesizerDelegate, UIApplicationDelegate
{
    fileprivate var utteranceWasInterruptedByNavigation: Bool = false
    fileprivate var totalUtterances: Int = 0
    fileprivate var totalParagraphs: Int = 0
    fileprivate var currentUtterance: Int = 0
    fileprivate var currentParagraph: Int = 1
    fileprivate var totalTextLength: Int = 0
    fileprivate var spokenTextLength: Int = 1
    fileprivate var currentCursorPosition: Int = 0
    fileprivate var utteranceArray:[(utterance: String, utteranceLength: Int, utteranceStartsParagraph: Bool, paragraphNumber: Int)] = []
    fileprivate enum NavigationType { case next, backward, backwardByParagraph, forward, forwardByParagraph, pauseOrPlay }
    
    fileprivate let speechSynthesizer = AVSpeechSynthesizer()
    
    fileprivate let userManager = UserManager.sharedInstance
    
//    fileprivate let queue = DispatchQueue(label: "speechSynthesizerQueue")
    
    override init() {
        //initializer for the TactileTTS class
        super.init()
        speechSynthesizer.delegate = self
    }
    
    //delegate functions
    //
    //
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        utteranceWasInterruptedByNavigation = false
        
        spokenTextLength = utteranceArray[0..<currentUtterance].reduce(0){$0 + $1.utteranceLength}
        
        //broadcast notification that all speech is done
        let center = NotificationCenter.default
        center.post(name: Notification.Name(rawValue: PercentCompleted.Notification), object: self, userInfo: [PercentCompleted.Key: (Double(spokenTextLength)/Double(totalTextLength))])
        
        //update the current paragraph
        currentParagraph = utteranceArray[currentUtterance].paragraphNumber
        
        //print("speaking location=\(currentParagraph),\(currentUtterance)")
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        currentCursorPosition = (spokenTextLength + characterRange.location)
    }
    

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        if currentUtterance ==  totalUtterances - 1 { //the last utterance is finished
            endTheProtocol()
        
        } else {
        navigate(.next)
        
        }
    }
    
    //private speech synthesizer functions
    //
    //
    //
    
    fileprivate func encodeResultsToJSON(_ theResponseArray: [NSString]) -> NSString {
        
        let data = try? JSONSerialization.data(withJSONObject: theResponseArray, options: JSONSerialization.WritingOptions())
        
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        
        return responseString
    }
    
    
    fileprivate func parse(_ theText: NSString) -> [(utterance: String, utteranceLength: Int, utteranceStartsParagraph: Bool, paragraphNumber: Int)] {
        
        //load and calculate sentences
        var tempArray = theText.components(separatedBy: CharacterSet(charactersIn: ".?!"))
        
        for i in 0..<tempArray.count - 1 {
            
            //this fixes the componentsSeparatedByCharactersInSet parsing on the first element, which doesn't have a space like the others
            if i == 0 {
                totalParagraphs += 1
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 2, utteranceStartsParagraph: true, paragraphNumber: totalParagraphs)]
                totalUtterances += 1
                
            } else {
                
                if tempArray[i].contains("\r") {
                    
                    totalParagraphs += 1
                    
                    //replace the paragraph chars with a space
                    tempArray[i] = tempArray[i].replacingOccurrences(of: "\r\n\r\n", with: " ", options: NSString.CompareOptions.literal, range: nil)
                    
                    //add the modified string to the utterance array and indicate a paragraph
                    utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 1, utteranceStartsParagraph: true, paragraphNumber: totalParagraphs)]
                    totalUtterances += 1
                    
                } else { //this sentence does not start a paragraph
                    
                    utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 1, utteranceStartsParagraph: false, paragraphNumber: totalParagraphs)]
                    totalUtterances += 1
                }
            }
            
            //print("\(utteranceArray[i])")
        }
        
        //display some metrics
        
        //calculate total characters
        totalTextLength = utteranceArray.reduce(0){$0 + $1.utteranceLength}
        print("Total chars: \(totalTextLength)") //# of chars in all utterances
        print("Total utterances= \(totalUtterances)")
        print("Total paragraphs = \(totalParagraphs)")
        
        return utteranceArray
    }
    
    
    fileprivate func navigate(_ go: NavigationType) {
        
        switch go {
            
        case .next:
            if !utteranceWasInterruptedByNavigation {
                if currentUtterance !=  totalUtterances - 1 { //not the last utterance
                    currentUtterance += 1
                    speak(currentUtterance)
                }
            }
            
        case .forward:
            userManager.writeGestureData("F",currentCursorPosition: currentCursorPosition)
            if currentUtterance !=  totalUtterances - 1 { //i.e. if it's NOT the last utterance
                currentUtterance += 1
                speak(currentUtterance)
            }
            
        case .forwardByParagraph:
            //write the data point
            userManager.writeGestureData("FP",currentCursorPosition: currentCursorPosition)

            if utteranceArray[currentUtterance].paragraphNumber != totalParagraphs { //i.e. if it's NOT the last paragraph
                currentUtterance += 1
                while !utteranceArray[currentUtterance].utteranceStartsParagraph {
                    currentUtterance += 1
                }
                speak(currentUtterance)
            }
            else { //it IS the last paragraph
                speak(currentUtterance)
            }

        case .backward:
            userManager.writeGestureData("B",currentCursorPosition: currentCursorPosition)
            if currentUtterance != 0 { //i.e. if it's NOT the first utterance
                currentUtterance -= 1
                speak(currentUtterance)
            } else { //it IS the first utterance
                speak(currentUtterance)
                
            }
            
        case .backwardByParagraph:
            //write the data point
            userManager.writeGestureData("BP",currentCursorPosition: currentCursorPosition)
            if utteranceArray[currentUtterance].paragraphNumber != 1 { //i.e. if it's NOT the first paragraph
                currentUtterance -= 1
                while !utteranceArray[currentUtterance].utteranceStartsParagraph {
                    currentUtterance -= 1
                }
                speak(currentUtterance)
            } else { //it IS the first paragraph
                currentUtterance = 0
                speak(currentUtterance)
            }

        case .pauseOrPlay:
            speak(-1)
        }
    }
    
    
    fileprivate func speak(_ utteranceIndex: Int) {
        
        //all speechSynthesizer functions should be run from this function
        // utteranceIndex = -1 means pauseOrPlay
        
        if utteranceIndex == -1 {
            if speechSynthesizer.isSpeaking {
                if speechSynthesizer.isPaused {
                    userManager.writeGestureData("C",currentCursorPosition: self.currentCursorPosition)
                    speechSynthesizer.continueSpeaking()
                } else {
                    speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
                    userManager.writeGestureData("P",currentCursorPosition: self.currentCursorPosition)
                }
            }
            
        } else {

            let theUtterance = AVSpeechUtterance(string: utteranceArray[utteranceIndex].utterance)
        
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
            speechSynthesizer.speak(theUtterance)
        }
    }
    
    
    fileprivate func endTheProtocol() {
        
        let jsonString = encodeResultsToJSON(userManager.responseArray)
        let encodedJsonResponse = jsonString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        //broadcast notification that all speech is done
        let center = NotificationCenter.default
        center.post(name: Notification.Name(rawValue: ProtocolCompleted.Notification), object: self, userInfo: [ProtocolCompleted.Key: encodedJsonResponse!])
    }
    
    
    //public functions
    //
    //
    //
    
    func speakTheText(_ theText: NSString) {
        
        //this is the start of the audio
        userManager.writeGestureData("S",currentCursorPosition: currentCursorPosition)
        
        utteranceArray = parse(theText) as [(utterance: String, utteranceLength: Int, utteranceStartsParagraph: Bool, paragraphNumber: Int)]
        
        speak(currentUtterance)
    }
    
    func pauseContinue() {
        
        navigate(.pauseOrPlay)
    }
    
    func goForward() {
        
        if userManager.participantGroup != 0 {
            utteranceWasInterruptedByNavigation = true
            navigate(.forward)
        }
    }
    
    func goBack() {
        
        if userManager.participantGroup != 0 {
            utteranceWasInterruptedByNavigation = true
            navigate(.backward)
        }
    }
    
    func goForwardByParagraph() {
        
        if userManager.participantGroup != 0 {
            utteranceWasInterruptedByNavigation = true
            navigate(.forwardByParagraph)
        }
    }
    
    func goBackByParagraph() {
        
        if userManager.participantGroup != 0 {
            utteranceWasInterruptedByNavigation = true
            navigate(.backwardByParagraph)
        }
    }
}
