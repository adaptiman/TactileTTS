//
//  userManager.swift
//  TactileTTS
//
//  Created by Administrator on 11/21/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import Foundation

class UserManager { //this is a Singleton pattern
    
    static let sharedInstance = UserManager()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    private struct participantKeys {
        static let participantGuidString = "participantGuidKey"
        static let participantGroupInt = "participantGroupKey"
        static let participantTrialInt = "participantTrialKey"
        static let trainingTextString = "trainingTextKey"
        static let protocolTextString = "protocolTextKey"
        static let orientationTextString = "orientationTextKey"
        static let participantResponseJsonString = "participantResponseJsonKey"
        static let phaseOneUrlString = "phaseOneUrlKey"
        static let phaseTwoUrlString = "phaseTwoUrlKey"
        static let pitchFloat = "pitchKey"
        static let rateFloat = "rateKey"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var responseArray: [NSString] = []
    
    let phaseOneUrl = "https://tamu.qualtrics.com/jfe/form/SV_a9Le0B1mZmgux5b"
    let phaseTwoUrl = "https://tamu.qualtrics.com/jfe/form/SV_1LLecPJoJzTU0bH"
    
    var participantGuid: String {
        get { return defaults.objectForKey(participantKeys.participantGuidString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.participantGuidString)}
    }
    
    
    var participantGroup: Int {
        get { return (defaults.objectForKey(participantKeys.participantGroupInt) as? Int ?? nil)!}
        set { defaults.setObject(newValue, forKey: participantKeys.participantGroupInt)}
    }
    
    
    var participantTrial: Int {
        get { return (defaults.objectForKey(participantKeys.participantTrialInt) as? Int ?? nil)!}
        set { defaults.setObject(newValue, forKey: participantKeys.participantTrialInt)}
    }
    
    var trainingText: NSString {
        get { return defaults.objectForKey(participantKeys.trainingTextString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.trainingTextString)}
    }
    
    var protocolText: NSString {
        get { return defaults.objectForKey(participantKeys.protocolTextString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.protocolTextString)}
    }
    
    var orientationText: NSString {
        get { return defaults.objectForKey(participantKeys.orientationTextString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.orientationTextString)}
    }
    
    var participantResponseJson: NSString {
        get { return defaults.objectForKey(participantKeys.participantResponseJsonString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.participantResponseJsonString)}
    }
    
    var PhaseOneUrl: String {
        get { return defaults.objectForKey(participantKeys.phaseOneUrlString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.phaseOneUrlString)}
    }
    
    var pitch: Float {
        get { return (defaults.objectForKey(participantKeys.pitchFloat) as? Float ?? nil)!}
        set { defaults.setObject(newValue, forKey: participantKeys.pitchFloat)}
    }
    
    var rate: Float {
        get { return (defaults.objectForKey(participantKeys.rateFloat) as? Float ?? nil)!}
        set { defaults.setObject(newValue, forKey: participantKeys.rateFloat)}
    }
    
    func generateParticipantGuid() -> String {
        
        //generate a participant UUID that will be used to identify the participant
        participantGuid = NSUUID().UUIDString
        print("participantGuid=\(participantGuid)")
        return participantGuid
    }
    
    
    func generateParticipantGroup() -> Int {
        
        //generate a participant group between 0 (control) and 4 (experimentals)
        participantGroup = Int(arc4random_uniform(5))
        print("generateParticipantGroup=\(participantGroup)")
        return participantGroup
    }
    
    func generateParticipantTrial() -> Int {
        
        //generate a participant trial starting with 1 and incrementing
        participantTrial = participantTrial + 1
        print("generateParticipantTrial=\(participantTrial)")
        return participantTrial
    }
    
    
    func participantGroupExists() -> Bool {
        
        //check to see if participant experimental group was previously generated and stored
        if let participantGroupInt = defaults.stringForKey(participantKeys.participantGroupInt) {
            print("participantGroupExists=\(participantGroupInt)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantGuidExists() -> Bool {
        
        //check to see if participant GUID was previously generated and stored
        if let participantGuidString = defaults.stringForKey(participantKeys.participantGuidString) {
            print("participantGuidExists=\(participantGuidString)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantTrialExists() -> Bool {
        
        //check to see if participant has taken the protocol before
        if let participantTrialInt = defaults.stringForKey(participantKeys.participantTrialInt) {
            print("participantTrialExists=\(participantTrialInt)")
            return true
        } else {
            return false
        }
    }
    
    func writeGestureData(code: String, currentCursorPosition: Int) {
        print(code + ",\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
        responseArray.append(code + ",\(currentCursorPosition),\(NSDate().timeIntervalSince1970)")
    }
    
    func setupTheExperiment() {
        //setup participant stored variables
        if participantGuidExists() {
            print("Got the GUID")
        } else {
            print("FirstTimer, setting GUID")
            generateParticipantGuid()
        }
        
        if participantGroupExists() {
            print("Got the Group")
        } else {
            print("Assigning Group")
            generateParticipantGroup()
        }
        
        if participantTrialExists() {
            print("Been here before, adding trial")
            generateParticipantTrial()
        } else {
            print("Setting Trial to 1")
            participantTrial = 1
        }
        
        //load the trainingText
        //        let trainingLocation = NSBundle.mainBundle().pathForResource("training", ofType: "txt")
        let trainingLocation = NSBundle.mainBundle().pathForResource("training", ofType: "txt")
        trainingText = try! NSString(contentsOfFile: trainingLocation!, encoding: NSUTF8StringEncoding)
        
        //load the protocolText
        //        let protocolLocation = NSBundle.mainBundle().pathForResource("protocol", ofType: "txt")
        let protocolLocation = NSBundle.mainBundle().pathForResource("protocolch10", ofType: "txt")
        protocolText = try! NSString(contentsOfFile: protocolLocation!, encoding: NSUTF8StringEncoding)
        
        //load the orientationText
        var orientationFileName: String = ""
        if participantGroup == 0 {
            orientationFileName = "orientationControl" as String
        } else {
            orientationFileName = "orientationExperimental" as String
        }
        
        let orientationLocation = NSBundle.mainBundle().pathForResource(orientationFileName, ofType: "txt")
        orientationText = try! NSString(contentsOfFile: orientationLocation!, encoding: NSUTF8StringEncoding)
    }
}