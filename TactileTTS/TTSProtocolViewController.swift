//
//  TTSProtocolViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSProtocolViewController: UIViewController {

    @IBAction func tap(sender: UITapGestureRecognizer) {
        ttsProtocol.pauseContinue()
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        ttsProtocol.goBack()
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        ttsProtocol.goForward()
    }
    
    
    @IBAction func swipeLeftTwoFinger(sender: UISwipeGestureRecognizer) {
        ttsProtocol.goForwardByParagraph()
    }
    
    
    @IBAction func swipeRightTwoFinger(sender: UISwipeGestureRecognizer) {
        ttsProtocol.goBackByParagraph()
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var ttsProtocol = TTSModel()
    
    private let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.title = "Text-to-Speech"
        // Do any additional setup after loading the view, typically from a nib.
        
        //process the text object through the speech navigation model
        //ttsProtocol.speakTheText(tvMaterial.text)
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //speak the protocol text
        ttsProtocol.speakTheText(userManager.protocolText)
        
        //setup a notifier to fire when the protcol is done.
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "protocolComplete:", name: ProtocolCompleted.Notification, object: nil)
        
        center.addObserver(self, selector: "updateProgress:", name: PercentCompleted.Notification, object: nil)

    }
    
    func protocolComplete(object: NSNotification) {
        
        print("protocolComplete")
        
        //write the response string to the participantKeys struct
        userManager.participantResponseJson = object.userInfo!["Response Result"] as! NSString
        
        
        //seque to Phase 2
        self.performSegueWithIdentifier("showPhaseTwo", sender: nil)
    }

    
    func updateProgress(object: NSNotification) {
        
        print("updating progress")
        
        //update the progress bar
        progressBar.progress = object.userInfo!["Percent Completed"] as! Float

    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

