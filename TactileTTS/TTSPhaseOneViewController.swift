//
//  TTSPhaseOneViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 10/30/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit
import WebKit

var trainingToken: dispatch_once_t = 0

class TTSPhaseOneViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    var webView: WKWebView!
    var myTimer: NSTimer!
    
    let userManager = UserManager.sharedInstance
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
        //self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Part 1"

        // Do any additional setup after loading the view.
        
        
        //setup participant stored variables
        if userManager.participantGuidExists() {
            print("Got the GUID")
        } else {
            print("FirstTimer, setting GUID")
            userManager.generateParticipantGuid()
        }
        
        if userManager.participantGroupExists() {
            print("Got the Group")
        } else {
            print("Assigning Group")
            userManager.generateParticipantGroup()
        }
        
        if userManager.participantTrialExists() {
            print("Been here before, adding trial")
            userManager.generateParticipantTrial()
        } else {
            print("Setting Trial to 1")
            userManager.participantTrial = 1
        }
        
        //start phase one survey
        //this is the phase one survey address
        let surveyString = userManager.phaseOneUrl as String
        
        let dataString = "?participantGuid=\(userManager.participantGuid)&participantGroup=\(userManager.participantGroup)&participantTrial=\(userManager.participantTrial)"
        let url = NSURL(string: (surveyString + dataString))
        print(url)
        
        //load the page in the WKWebView
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        
        //this block will open a sendToURL in Safari
//        UIApplication.sharedApplication().openURL(NSURL(string:sendToURL)!)
//        let requestObj = NSURLRequest(URL: sendToURL!)
//        phaseOneWebView.loadRequest(requestObj)
        
        
        //NSTimer
        myTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "fireTimer", userInfo: nil, repeats: true)
        
        //terminate app
        
    }
    
    func fireTimer() {
        //print("tick")
        self.webView.evaluateJavaScript("document.getElementById('EndOfSurvey')") { (result, error) -> Void in
            print("\(result),\(error)")
            if error != nil {
                dispatch_once(&trainingToken, { () -> Void in
                    self.performSegueWithIdentifier("showSettings", sender: nil)
                    self.myTimer.invalidate()
                } )
            }
        }
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
