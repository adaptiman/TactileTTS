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
    
    @IBOutlet weak var progressLabel: UILabel!
    
    
    //navigation images/labels outlets
    @IBOutlet weak var backBySentenceImage: UIImageView!
    @IBOutlet weak var backBySentenceLabel: UILabel!
    @IBOutlet weak var forwardBySentenceImage: UIImageView!
    @IBOutlet weak var forwardBySentenceLabel: UILabel!
    @IBOutlet weak var backByParagraphImage: UIImageView!
    @IBOutlet weak var backByParagraphLabel: UILabel!
    @IBOutlet weak var forwardByParagraphImage: UIImageView!
    @IBOutlet weak var forwardByParagraphLabel: UILabel!
    
    var ttsProtocol = TTSModel()
    
    private let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.title = "Comparing the States and Communities"
        // Do any additional setup after loading the view, typically from a nib.
        
        //process the text object through the speech navigation model
        //ttsProtocol.speakTheText(tvMaterial.text)
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //speak the protocol text
        ttsProtocol.speakTheText(userManager.protocolText)
        
        //setup a notifier to fire when the protcol is done
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "protocolComplete:", name: ProtocolCompleted.Notification, object: nil)
        
        //setup a notifier to update the progress of the text
        center.addObserver(self, selector: "updateProgress:", name: PercentCompleted.Notification, object: nil)
        
        //hide the extraneous navigation icons for the control group
        if userManager.participantGroup == 0 {
            backBySentenceImage.hidden = true
            backBySentenceLabel.hidden = true
            backByParagraphImage.hidden = true
            backByParagraphLabel.hidden = true
            forwardBySentenceImage.hidden = true
            forwardBySentenceLabel.hidden = true
            forwardByParagraphImage.hidden = true
            forwardByParagraphLabel.hidden = true
        }

    }
    
    func protocolComplete(object: NSNotification) {
        
        //print("protocolComplete")
        
        //write the response string to the participantKeys struct
        userManager.participantResponseJson = object.userInfo!["Response Result"] as! NSString
        
        
        //seque to Phase 2
        self.performSegueWithIdentifier("showPhaseTwo", sender: nil)
    }

    
    func updateProgress(object: NSNotification) {
        
        //print("updating progress")
        
        let progressFloat = object.userInfo!["Percent Completed"] as! Float
        
        //update the progress bar and label
        progressBar.progress = progressFloat
        let progressPercent = progressFloat * 100
        progressLabel.text = (NSString(format: "%.0f", progressPercent) as String) + "%"
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

