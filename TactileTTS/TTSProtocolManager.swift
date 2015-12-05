//
//  userManager.swift
//  TactileTTS
//
//  Created by Administrator on 11/21/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import Foundation

class ProtocolManager { //this is a Singleton pattern
    
    static let sharedInstance = ProtocolManager()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    private struct protocolKeys {
        static let participantGuidString = "participantGuidKey"
        static let participantGroupInt = "participantGroupKey"
        static let participantTrialInt = "participantTrialKey"
        static let trainingTextString = "trainingTextKey"
        static let protocolTextString = "protocolTextKey"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var trainingTextUrl: NSURL = NSURL(string: "https://raw.githubusercontent.com/adaptiman/TactileTTS/training_protocol/TactileTTS/gettysburg.txt")!
    private var protocolTextUrl: NSURL = NSURL(string: "https://raw.githubusercontent.com/adaptiman/TactileTTS/training_protocol/TactileTTS/gettysburg.txt")!
    
    
    var responseArray: [NSString] = []
    
    var participantGuid: NSString {
        get { return defaults.objectForKey(protocolKeys.participantGuidString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: protocolKeys.participantGuidString)}
    }
    
    
    var participantGroup: Int {
        get { return (defaults.objectForKey(protocolKeys.participantGroupInt) as? Int ?? nil)!}
        set { defaults.setObject(newValue, forKey: protocolKeys.participantGroupInt)}
    }
    
    
    var participantTrial: Int {
        get { return (defaults.objectForKey(protocolKeys.participantTrialInt) as? Int ?? nil)!}
        set { defaults.setObject(newValue, forKey: protocolKeys.participantTrialInt)}
    }
    
    var trainingText: NSString {
        get { return defaults.objectForKey(protocolKeys.trainingTextString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: protocolKeys.trainingTextString)}
    }

    var protocolText: NSString {
        get { return defaults.objectForKey(protocolKeys.protocolTextString) as? String ?? ""}
        set { defaults.setObject(newValue, forKey: protocolKeys.protocolTextString)}
    }
    
    func generateParticipantGuid() -> NSString {
        
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
        if let participantGroupInt = defaults.stringForKey(protocolKeys.participantGroupInt) {
            print("participantGroupExists=\(participantGroupInt)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantGuidExists() -> Bool {
        
        //check to see if participant GUID was previously generated and stored
        if let participantGuidString = defaults.stringForKey(protocolKeys.participantGuidString) {
            print("participantGuidExists=\(participantGuidString)")
            return true
        } else {
            return false
        }
    }
    
    
    func participantTrialExists() -> Bool {
        
        //check to see if participant has taken the protocol before
        if let participantTrialInt = defaults.stringForKey(protocolKeys.participantTrialInt) {
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
    
    func getTrainingText() -> NSString {
        
        //retrieve the training text from a URL
    
        let task = NSURLSession.sharedSession().dataTaskWithURL(trainingTextUrl,completionHandler: {(data, response, error) in
                self.trainingText =  NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print("=\(self.trainingText)")
 
            

        })
        task.resume()
        
        
        
        
        participantGuid = NSUUID().UUIDString
        print("participantGuid=\(participantGuid)")
        return trainingText
    }
}
