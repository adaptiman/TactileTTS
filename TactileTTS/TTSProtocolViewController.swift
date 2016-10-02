//
//  TTSProtocolViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2016 David Sweeney. All rights reserved.
//

import UIKit

class TTSProtocolViewController: UIViewController {

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        ttsProtocol.pauseContinue()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        ttsProtocol.goBack()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        ttsProtocol.goForward()
    }
    
    
    @IBAction func swipeLeftTwoFinger(_ sender: UISwipeGestureRecognizer) {
        ttsProtocol.goForwardByParagraph()
    }
    
    
    @IBAction func swipeRightTwoFinger(_ sender: UISwipeGestureRecognizer) {
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
    
    fileprivate let userManager = UserManager.sharedInstance
    
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
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(TTSProtocolViewController.protocolComplete(_:)), name: NSNotification.Name(rawValue: ProtocolCompleted.Notification), object: nil)
        
        //setup a notifier to update the progress of the text
        center.addObserver(self, selector: #selector(TTSProtocolViewController.updateProgress(_:)), name: NSNotification.Name(rawValue: PercentCompleted.Notification), object: nil)
        
        //hide the extraneous navigation icons for the control group
        if userManager.participantGroup == 0 {
            backBySentenceImage.isHidden = true
            backBySentenceLabel.isHidden = true
            backByParagraphImage.isHidden = true
            backByParagraphLabel.isHidden = true
            forwardBySentenceImage.isHidden = true
            forwardBySentenceLabel.isHidden = true
            forwardByParagraphImage.isHidden = true
            forwardByParagraphLabel.isHidden = true
        }

    }
    
    func protocolComplete(_ object: Notification) {
        
        //print("protocolComplete")
        
        //write the response string to the participantKeys struct
        userManager.participantResponseJson = (object as NSNotification).userInfo!["Response Result"] as! NSString
        
        
        //seque to Phase 2
        self.performSegue(withIdentifier: "showPhaseTwo", sender: nil)
    }

    
    func updateProgress(_ object: Notification) {
        
        //print("updating progress")
        
        let progressDouble = (object as NSNotification).userInfo!["Percent Completed"] as! Double
        
        //update the progress bar and label
        progressBar.progress = Float(progressDouble)
        let progressPercent = (progressDouble) * 100
        progressLabel.text = (NSString(format: "%.0f", progressPercent) as String) + "%"
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

