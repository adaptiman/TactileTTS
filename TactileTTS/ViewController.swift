//
//  ViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvMaterial: UITextView!
    

    @IBAction func tap(sender: UITapGestureRecognizer) {
        
        tts.pauseContinue()
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        
        tts.goBack()
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        
        tts.goForward()
    }
    
    var tts = TactileTTSModel()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //process the text object through the speech navigation model
        tts.runTheProtocol(tvMaterial.text)
        
        //setup a notifier to fire when the protcol is done.
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "passResults:", name: ProtocolCompleted.Notification, object: nil)

    }
    
    func passResults(object: NSNotification) {
        
        print("Got Notification \(object.userInfo)")
        
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

