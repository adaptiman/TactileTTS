//
//  TTSPhaseOneModel.swift
//  TactileTTS
//
//  Created by David Sweeney on 10/31/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import Foundation

class TTSPhaseOneModel
{
    
    private struct participantKeys {
        static let participantGuidString = "participantGuidKey"
        static let participantGroupInt = "participantGroupKey"
        static let participantTrialInt = "participantTrialKey"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
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
    
    
    func generateParticipantGuid() -> String {
        
        //generate a participant UUID that will be used to identify the participant
        participantGuid = NSUUID().UUIDString
         print("userID:\(participantGuid)")
        return participantGuid
    }
    
    
    func generateParticipantGroup() -> Int {
        
        //generate a participant group between 0 (control) and 1 (experimental)
        participantGroup = Int(arc4random_uniform(2))
        print("generateParticipantGroup=\(participantGroup)")
        return participantGroup
    }
    
    func generateParticipantTrial() -> Int {
        
        //generate a participant trial starting with 1 and incrementing
        
        
        participantTrial = participantTrial + 1
        print("generateParticipantGroup=\(participantGroup)")
        return participantGroup
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
}

