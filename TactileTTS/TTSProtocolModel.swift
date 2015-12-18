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
    static let Notification = "TTS Notifier"
    static let Key = "Response Result"
}

class TTSModel: UIResponder, AVSpeechSynthesizerDelegate, UIApplicationDelegate
{
//    private var responseArray: [NSString] = []
    private var utteranceWasInterruptedByNavigation: Bool = false
    private var totalUtterances: Int! = 0
    private var currentUtterance: Int! = 0
    private var totalTextLength: Int! = 0
    private var spokenTextLength: Int! = 1
    private var currentCursorPosition: Int! = 0
    private var utteranceArray:[(utterance: String, utteranceLength: Int)] = []
    private enum ParseType { case ByParagraph, BySentence, ByWord }
    private enum NavigationType { case Next, Backward, Forward, PauseOrPlay }
    
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private let userManager = UserManager.sharedInstance
    
    override init() {
        //initializer for the TactileTTS class
        super.init()
        speechSynthesizer.delegate = self
    }
    
    //delegate functions
    //
    //
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        
        utteranceWasInterruptedByNavigation = false
        
        spokenTextLength = utteranceArray[0..<currentUtterance].reduce(0){$0 + $1.utteranceLength}
        
        //print("currentUtterance: \(currentUtterance)")
        //print("spokenTextLength: \(spokenTextLength)")
        
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        currentCursorPosition = (spokenTextLength + characterRange.location)
    }
    

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
        if currentUtterance ==  totalUtterances - 1 { //the last utterance is finished
            endTheProtocol()
        
        } else {
        navigate(.Next)
        
        }
    }

    //private speech synthesizer functions
    //
    //
    //
    
    private func encodeResultsToJSON(theResponseArray: [NSString]) -> NSString {
        
        let data = try? NSJSONSerialization.dataWithJSONObject(theResponseArray, options: NSJSONWritingOptions())
        
        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        
        return responseString
    }
    
    private func getSentences(theText:NSString) -> [(utterance: String, utteranceLength: Int)] {
 
        //load and calculate sentences
        let tempArray = theText.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".?!"))
        
        for i in 0..<tempArray.count - 1 {
//            this fixes the funky componentsSeparatedByCharactersInSet parsing on the first element
            if i == 0 {
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 2)]
            } else {
                utteranceArray += [(utterance: tempArray[i], utteranceLength: tempArray[i].utf16.count + 1)]
            }
            
//            print("\(utteranceArray[i])")
        }
        
        return (utteranceArray)
    }

    private func parse(theText: NSString, parseMethod: ParseType) -> [(utterance: String, utteranceLength: Int)] {
        
        switch parseMethod {
        
        case .ByParagraph:
            print("Utterance level is: paragraph")
        
        case .BySentence:
            _ = getSentences(theText)
            print("Utterance level is: sentence")
            //responseArray.append("Utterance level is: sentence")
            
        case .ByWord:
            print("Utterance level is: word")
        }
        
        //calculate total utterances
        totalUtterances = utteranceArray.count
        print("Total utterances = \(totalUtterances)")
        //responseArray.append("Total utterances = \(totalUtterances)")

        //calculate total characters
        totalTextLength = utteranceArray.reduce(0){$0 + $1.utteranceLength}
        print("Total chars: \(totalTextLength)") //# of chars in all utterances
        //responseArray.append("Total chars: \(totalTextLength)")
        
        return utteranceArray
    }
    
    private func navigate(go: NavigationType) {

        switch go {
            
        case .Next:
            if !utteranceWasInterruptedByNavigation {
                if currentUtterance !=  totalUtterances - 1 { //not the last utterance
                    currentUtterance = currentUtterance + 1
                    speak(currentUtterance)
                }
            }
            
        case .Forward:
            print("F,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            userManager.responseArray.append("F,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            if currentUtterance !=  totalUtterances - 1 { //i.e. if it's NOT the last utterance
                speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                currentUtterance = currentUtterance + 1
                speak(currentUtterance)
            }
            
        case .Backward:
            print("B,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            userManager.responseArray.append("B,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
            if currentUtterance != 0 { //i.e. if it's NOT the first utterance
                speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                currentUtterance = currentUtterance - 1
                speak(currentUtterance)
            } else { //it IS the first utterance
                speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                speak(currentUtterance)

            }
            
        case .PauseOrPlay:
            if speechSynthesizer.speaking {
                if speechSynthesizer.paused {
                    print("C,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
                    userManager.responseArray.append("C,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
                    speechSynthesizer.continueSpeaking()
                } else {
                    speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                    print("P,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
                    userManager.responseArray.append("P,\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
                }
            }
        }
    }
    
    private func speak(utteranceIndex: Int) {
        
        speechSynthesizer.speakUtterance(AVSpeechUtterance(string: utteranceArray[utteranceIndex].utterance))
    }
    
//    private func getTheText() {  //this function retreives from a URL
//        let url = NSURL(string: "https://raw.githubusercontent.com/adaptiman/TactileTTS/master/TactileTTS/gettysburg.txt")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//             print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
//    }
    
    //public functions
    //
    //
    //
    
    
    func speakTheText(theText: NSString) {
        
        utteranceArray = parse(theText, parseMethod: .BySentence) as [(utterance: String, utteranceLength: Int)]
        
        speak(currentUtterance)
    }
    
    func endTheProtocol() {
        
        let jsonString = encodeResultsToJSON(userManager.responseArray)
        let encodedJsonResponse = jsonString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        //broadcast notification that all speech is done
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(ProtocolCompleted.Notification, object: self, userInfo: [ProtocolCompleted.Key: encodedJsonResponse!])
    }

    func pauseContinue() {
        
        navigate(.PauseOrPlay)
    }
    
    func goForward() {
        
        utteranceWasInterruptedByNavigation = true
        navigate(.Forward)
    }
    
    func goBack() {
        
        utteranceWasInterruptedByNavigation = true
        navigate(.Backward)

    }
}
