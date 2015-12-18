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
        static let responseJsonString = "participantResponseKey"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var responseArray: [NSString] = []
    
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

    var participantResponseJson: NSString {
        get { return defaults.objectForKey(participantKeys.responseJsonString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: participantKeys.responseJsonString)}
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

    func appenduserManagerToResponseArray(){ //load some stored parameters into the responseArray
        responseArray.append("GUID=\(participantGuid)")
        print("Happy! Happy! Happy! ")
        responseArray.append("Group=\(String(participantGroup))")
        responseArray.append("Trial=\(String(participantTrial))")
    }
}
