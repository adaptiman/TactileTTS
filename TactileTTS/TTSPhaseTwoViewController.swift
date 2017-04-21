//
//  TTSPhaseTwoViewController.swift
//  TactileTTS
//
//  Created by Administrator on 12/17/15.
//  Copyright © 2017 David Sweeney. All rights reserved.
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
        self.title = "Part 3"
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // Do any additional setup after loading the view.
        
        //start phase two survey
        
        //this is the phase two survey address
        let surveyString = userManager.phaseTwoUrl as String
        
        //this is the preview	 address
        //let surveyString = "https://tamu.qualtrics.com/jfe/preview/SV_1LLecPJoJzTU0bH?"
        
        //this is the response string
//        let dataString = "?participantGuid=\(userManager.participantGuid)&participantGroup=\(userManager.participantGroup)&participantTrial=\(userManager.participantTrial)&rate=\(userManager.rate)&pitch=\(userManager.pitch)&resultString=\(userManager.participantResponseJson as String)"
        let dataString = "?participantGuid=\(userManager.participantGuid)&participantGroup=\(userManager.participantGroup)&participantTrial=\(userManager.participantTrial)&resultString=\(userManager.participantResponseJson as String)"
        
        let url = URL(string: (surveyString + (dataString as String)))
        print(url ?? surveyString)
        
        //load the page in the WKWebView
        let req = URLRequest(url:url!)
        self.webView!.load(req)
    }

    
}
