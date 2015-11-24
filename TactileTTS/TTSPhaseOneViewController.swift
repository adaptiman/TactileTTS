//
//  TTSPhaseOneViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 10/30/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSPhaseOneViewController: UIViewController {
    
    
//    var phaseOne = TTSPhaseOneModel()
    
    let globals = GlobalStuff.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //setup participant stored variables
        if globals.participantGuidExists() {
            print("Got the GUID")
        } else {
            print("FirstTimer, setting GUID")
            globals.generateParticipantGuid()
        }
        
        if globals.participantGroupExists() {
            print("Got the Group")
        } else {
            print("Assigning Group")
            globals.generateParticipantGroup()
        }
        
        if globals.participantTrialExists() {
            print("Been here before, adding trial")
            globals.generateParticipantTrial()
        } else {
            print("Setting Trial to 1")
            globals.participantTrial = 1
        }
        
        //start phase one survey
        //this is the phase one survey address
        let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_a9Le0B1mZmgux5b?"
        let dataString = "participantGuid=\(globals.participantGuid)&participantGroup=\(globals.participantGroup)&participantTrial=\(globals.participantTrial)"
        
        let sendToURL = surveyString + dataString
        print(sendToURL)
        UIApplication.sharedApplication().openURL(NSURL(string:sendToURL)!)
        
        //terminate app
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
