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
        center.addObserver(self, selector: "passResults:", name: ProtocolCompleted.Notification, object: nil)

    }
    
    func passResults(object: NSNotification) {
        
        print("Got Notification")
        
        //this is the phase two survey address
        let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_1LLecPJoJzTU0bH?resultString="
        let dataString = object.userInfo!["Response Result"] as! NSString
        
        let sendToURL = surveyString + (dataString as String)
        print(sendToURL)
        UIApplication.sharedApplication().openURL(NSURL(string:sendToURL)!)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

