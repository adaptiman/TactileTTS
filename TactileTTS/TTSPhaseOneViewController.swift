//
//  TTSPhaseOneViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 10/30/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSPhaseOneViewController: UIViewController {
    
    
    var phaseOne = TTSPhaseOneModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //setup participant stored variables
        if phaseOne.participantGuidExists() {
            print("Got the GUID")
        } else {
            print("FirstTimer, setting GUID")
            phaseOne.generateParticipantGuid()
        }
        
        if phaseOne.participantGroupExists() {
            print("Got the Group")
        } else {
            print("Assigning Group")
            phaseOne.generateParticipantGroup()
        }
        
        if phaseOne.participantTrialExists() {
            print("Been here before, adding trial")
            phaseOne.generateParticipantTrial()
        } else {
            print("Setting Trial to 1")
            phaseOne.participantTrial = 1
        }
        
        //start phase one survey
        //this is the phase one survey address
        let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_a9Le0B1mZmgux5b?"
        let dataString = "participantGuid=\(phaseOne.participantGuid)&participantGroup=\(phaseOne.participantGroup)&participantTrial=\(phaseOne.participantTrial)"
        
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
