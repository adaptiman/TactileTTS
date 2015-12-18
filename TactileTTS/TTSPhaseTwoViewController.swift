//
//  TTSPhaseTwoViewController.swift
//  TactileTTS
//
//  Created by Administrator on 12/17/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit
import WebKit

class TTSPhaseTwoViewController: UIViewController {

    
    var webView: WKWebView!
    
    let userManager = UserManager.sharedInstance
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
        //self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Part 2"
        
        // Do any additional setup after loading the view.
        
        //start phase two survey
        //this is the phase one survey address
        let surveyString = "https://tamu.qualtrics.com/jfe/form/SV_a9Le0B1mZmgux5b?"
        
        //this is the preview address
        //let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_a9Le0B1mZmgux5b?"
        let dataString = "participantGuid=\(userManager.participantGuid)&participantGroup=\(userManager.participantGroup)&participantTrial=\(userManager.participantTrial)"
        let url = NSURL(string: (surveyString + dataString))
        print(url)
        
        //load the page in the WKWebView
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        
        
        
//        //this is the phase two survey address
//        let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_1LLecPJoJzTU0bH?resultString="
//        let dataString = object.userInfo!["Response Result"] as! NSString
//        
//        let sendToURL = surveyString + (dataString as String)
//        print(sendToURL)
//        UIApplication.sharedApplication().openURL(NSURL(string:sendToURL)!)
        

        
    }

    
}
