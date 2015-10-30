//
//  TTSProtocolViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSProtocolViewController: UIViewController {

    @IBOutlet weak var tvMaterial: UITextView!
    

    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        ttsProtocol.pauseContinue()
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        
        ttsProtocol.goBack()
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        
        ttsProtocol.goForward()
    }
    
    var ttsProtocol = TTSProtocolModel()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //generate a participant UUID that will be used to identify the participant
        let uuid = NSUUID().UUIDString
        print("userID:\(uuid)")
        
        
        
        //process the text object through the speech navigation model
        ttsProtocol.runTheProtocol(tvMaterial.text)
        
        //setup a notifier to fire when the protcol is done.
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "passResults:", name: ProtocolCompleted.Notification, object: nil)

    }
    
    func passResults(object: NSNotification) {
        
        print("Got Notification")
        
        let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_1LLecPJoJzTU0bH?resultstring="
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

