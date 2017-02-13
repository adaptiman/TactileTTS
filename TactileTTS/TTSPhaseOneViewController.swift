//
//  TTSPhaseOneViewController.swift
//  TactileTTS
//
//  Created by David Sweeney on 10/30/15.
//  Copyright © 2017 David Sweeney. All rights reserved.
//

import UIKit
import WebKit

var trainingToken: Int = 0

class TTSPhaseOneViewController: UIViewController {
    
    private static var __once: ((_ obj: TTSPhaseOneViewController) -> Void) = { (obj: TTSPhaseOneViewController) -> Void in
        obj.myTimer.invalidate()
        obj.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBOutlet var containerView: UIView!
    
    @IBAction func continueToOrientation(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showOrientation", sender: nil)
        
    }
    var webView: WKWebView!
    var myTimer: Timer!
    
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
        
        //start phase one survey
        //this is the phase one survey address
        let surveyString = userManager.phaseOneUrl as String
        
        let dataString = "?participantGuid=\(userManager.participantGuid)&participantGroup=\(userManager.participantGroup)&participantTrial=\(userManager.participantTrial)"
        let url = URL(string: (surveyString + dataString))
        //print(url)
        
        //load the page in the WKWebView
        let req = URLRequest(url:url!)
        self.webView!.load(req)
        
        //this block will open a sendToURL in Safari
        //        UIApplication.sharedApplication().openURL(NSURL(string:sendToURL)!)
        //        let requestObj = NSURLRequest(URL: sendToURL!)
        //        phaseOneWebView.loadRequest(requestObj)
        
        
        //NSTimer
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TTSPhaseOneViewController.fireTimer), userInfo: nil, repeats: true)
        
        //terminate app
        
    }
    
    func fireTimer() {
        //print("tick!")
        self.webView.evaluateJavaScript("document.getElementById('EndOfSurvey')") { (result, error) -> Void in
            //print("\(result),\(error)")
            if error != nil {
                _ = TTSPhaseOneViewController.__once(self)
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
