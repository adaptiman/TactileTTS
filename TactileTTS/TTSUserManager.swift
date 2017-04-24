//
//  userManager.swift
//  TactileTTS
//
//  Created by Administrator on 11/21/15.
//  Copyright © 2017 David Sweeney. All rights reserved.
//

import Foundation

class UserManager { //this is a Singleton pattern
    
    static let sharedInstance = UserManager()
    
    fileprivate init() {} //This prevents others from using the default '()' initializer for this class.
    
    fileprivate struct participantKeys {
        static let participantGuidString = "participantGuidKey"
        static let participantGroupInt = "participantGroupKey"
        static let participantTrialInt = "participantTrialKey"
        static let trainingTextString = "trainingTextKey"
        static let protocolTextString = "protocolTextKey"
        static let orientationTextString = "orientationTextKey"
        static let participantResponseJsonString = "participantResponseJsonKey"
        static let phaseOneUrlString = "phaseOneUrlKey"
        static let phaseTwoUrlString = "phaseTwoUrlKey"
//        static let pitchFloat = "pitchKey"
//        static let rateFloat = "rateKey"
    }
    
    fileprivate let defaults = UserDefaults.standard
    
    var responseArray: [NSString] = []
    
    let phaseOneUrl = "https://tamu.qualtrics.com/jfe/form/SV_a9Le0B1mZmgux5b"
    let phaseTwoUrl = "https://tamu.qualtrics.com/jfe/form/SV_1LLecPJoJzTU0bH"
    
    var participantGuid: String {
        get { return defaults.object(forKey: participantKeys.participantGuidString) as? String ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.participantGuidString)}
    }
    
    
    var participantGroup: Int {
        get { return (defaults.object(forKey: participantKeys.participantGroupInt) as? Int ?? nil)!}
        set { defaults.set(newValue, forKey: participantKeys.participantGroupInt)}
    }
    
    
    var participantTrial: Int {
        get { return (defaults.object(forKey: participantKeys.participantTrialInt) as? Int ?? nil)!}
        set { defaults.set(newValue, forKey: participantKeys.participantTrialInt)}
    }
    
    var trainingText: NSString {
        get { return defaults.object(forKey: participantKeys.trainingTextString) as? String as NSString? ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.trainingTextString)}
    }
    
    var protocolText: NSString {
        get { return defaults.object(forKey: participantKeys.protocolTextString) as? String as NSString? ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.protocolTextString)}
    }
    
    var orientationText: NSString {
        get { return defaults.object(forKey: participantKeys.orientationTextString) as? String as NSString? ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.orientationTextString)}
    }
    
    var participantResponseJson: NSString {
        get { return defaults.object(forKey: participantKeys.participantResponseJsonString) as? String as NSString? ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.participantResponseJsonString)}
    }
    
    var PhaseOneUrl: String {
        get { return defaults.object(forKey: participantKeys.phaseOneUrlString) as? String ?? ""}
        set { defaults.set(newValue, forKey: participantKeys.phaseOneUrlString)}
    }
    
//    var pitch: Float {
//        get { return (defaults.objectForKey(participantKeys.pitchFloat) as? Float ?? 1.0)!}
//        set { defaults.setObject(newValue, forKey: participantKeys.pitchFloat)}
//    }
//    
//    var rate: Float {
//        get { return (defaults.object(forKey: participantKeys.rateFloat) as? Float ?? 0.5)!}
//        set { defaults.set(newValue, forKey: participantKeys.rateFloat)}
//    }
    
    func generateParticipantGuid() -> String {
        
        //generate a participant UUID that will be used to identify the participant
        participantGuid = UUID().uuidString
        print("participantGuid=\(participantGuid)")
        return participantGuid
    }
    
    
    func generateParticipantGroup() -> Int {
        
        //generate a participant group between 0 (control) and 4 (experimentals)
        participantGroup = Int(arc4random_uniform(5))
//        participantGroup = 100
        print("generateParticipantGroup=\(participantGroup)")
        return participantGroup
    }
    
    func generateParticipantTrial() -> Int {
        
        //generate a participant trial starting with 1 and incrementing
        participantTrial = participantTrial + 1
        participantTrial = 1
        print("generateParticipantTrial=\(participantTrial)")
        return participantTrial
    }
    
    
    func participantGroupExists() -> Bool {
        
        //check to see if participant experimental group was previously generated and stored
        if let participantGroupInt = defaults.string(forKey: participantKeys.participantGroupInt) {
            print("participantGroupExists=\(participantGroupInt)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantGuidExists() -> Bool {
        
        //check to see if participant GUID was previously generated and stored
        if let participantGuidString = defaults.string(forKey: participantKeys.participantGuidString) {
            print("participantGuidExists=\(participantGuidString)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantTrialExists() -> Bool {
        
        //check to see if participant has taken the protocol before
        if let participantTrialInt = defaults.string(forKey: participantKeys.participantTrialInt) {
            print("participantTrialExists=\(participantTrialInt)")
            return true
        } else {
            return false
        }
    }
    
    func writeGestureData(_ code: String, currentCursorPosition: Int) {
        print(code + ",\(currentCursorPosition),\(Date().timeIntervalSince1970)")
        responseArray.append("\(code),\(currentCursorPosition),\(Date().timeIntervalSince1970)" as NSString)
    }
    
    func setupTheExperiment() {
        //setup participant stored variables
        if participantGuidExists() {
            print("Got the GUID")
        } else {
            print("FirstTimer, setting GUID")
            _ = generateParticipantGuid()
        }
        
        if participantGroupExists() {
            print("Got the Group")
        } else {
            print("Assigning Group")
            _ = generateParticipantGroup()
        }
        
        if participantTrialExists() {
            print("Been here before, adding trial")
            _ = generateParticipantTrial()
        } else {
            print("Setting Trial to 1")
            participantTrial = 1
        }
        
        //load the trainingText
        //        let trainingLocation = NSBundle.mainBundle().pathForResource("training", ofType: "txt")
//        let trainingLocation = Bundle.main.path(forResource: "training", ofType: "txt")
        let trainingLocation = Bundle.main.path(forResource: "filler", ofType: "txt")
        trainingText = try! NSString(contentsOfFile: trainingLocation!, encoding: String.Encoding.utf8.rawValue)
        
        //load the protocolText
        let protocolLocation = Bundle.main.path(forResource: "protocol", ofType: "txt")
        protocolText = try! NSString(contentsOfFile: protocolLocation!, encoding: String.Encoding.utf8.rawValue)
        
        //load the orientationText
        var orientationFileName: String = ""
        if participantGroup == 0 {
            orientationFileName = "orientationControl" as String
//            orientationFileName = "filler" as String
        } else {
//            orientationFileName = "orientationExperimental" as String
            orientationFileName = "filler" as String
        }
        
        let orientationLocation = Bundle.main.path(forResource: orientationFileName, ofType: "txt")
        orientationText = try! NSString(contentsOfFile: orientationLocation!, encoding: String.Encoding.utf8.rawValue)
    }
}
