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
        
        tts.runTheProtocol(tvMaterial.text)
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        center.addObserverForName(ProtocolCompleted.Notification, object: appDelegate, queue: queue) { notification in
            
            if let results = notification.userInfo?[ProtocolCompleted.Key] as? String {
                
                print("notification received: \(results)")
                UIApplication.sharedApplication().openURL(NSURL(string:"https://tamu.qualtrics.com/jfe/preview/SV_1LLecPJoJzTU0bH?resultstring=\(results)")!)
            
            }
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

