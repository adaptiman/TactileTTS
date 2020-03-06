//
//  TTSProtocolViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2017 David Sweeney. All rights reserved.
//

import UIKit

class TTSProtocolViewController: UIViewController, UIGestureRecognizerDelegate {

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
    
    @IBOutlet var doubleSwipeLeft: UISwipeGestureRecognizer!
    
    @IBAction func swipeRightTwoFinger(_ sender: UISwipeGestureRecognizer) {
        ttsProtocol.goBackByParagraph()
    }
    
    @IBOutlet var doubleSwipeRight: UISwipeGestureRecognizer!
    
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
        self.title = "Part 2 - Audio Text"
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
        
        //programmatically set numberOfTouchesRequired for doubleSwipeRight and doubleSwipeLeft to 2. Assigning greater than one touch at designtime in the storyboard causes a a known buffer overrun bug in UISwipeGestureRecognizer.  When a UISwipeGestureRecognizer's number of required touches is configured to be greater than 1 in a storyboard, the UISwipeGestureRecognizer fails to allocate a sufficiently large enough buffer to track the state of multiple (more than one) touches.  When more than one touch occurs the memory adjacent to the buffer is overwritten, leading to undefined behavior.
        
        //The workaround is to set the number of required touches for all swipe gesture recognizers in your storyboard to be 1.  If a swipe gesture recognizer requires more than one touch, modify its numberOfTouchesRequired property in code (in -viewDidLoad)
        
        self.doubleSwipeLeft.numberOfTouchesRequired = 2
        self.doubleSwipeRight.numberOfTouchesRequired = 2


    }
    
    @objc func protocolComplete(_ object: Notification) {
        
        //print("protocolComplete")
        
        //write the response string to the participantKeys struct
        userManager.participantResponseJson = (object as NSNotification).userInfo!["Response Result"] as! NSString
        
        
        //seque to Phase 2
        self.performSegue(withIdentifier: "showPhaseTwo", sender: nil)
    }

    
    @objc func updateProgress(_ object: Notification) {
        
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

