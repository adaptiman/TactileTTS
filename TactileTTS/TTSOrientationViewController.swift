//
//  TTSOrientationViewController.swift
//  TactileTTS
//
//  Created by Administrator on 12/19/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSOrientationViewController: UIViewController {

   
    @IBOutlet weak var tvOrientation: UITextView!
    
    @IBAction func continueToTrainingOrProtocol(sender: AnyObject) {
        
        ttsProtocol.stopSpeakingTheText()
        
        if self.userManager.participantGroup == 0 {
            print("Control Group")
            self.performSegueWithIdentifier("showControlProtocol", sender: nil)
        } else {
            print("Experimental Group")
            self.performSegueWithIdentifier("showTraining", sender: nil)
        }
    }
    
    var ttsProtocol = TTSModel()
    
    private let userManager = UserManager.sharedInstance
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Instructions"
        // Do any additional setup after loading the view, typically from a nib.
        
        //set the tvOrientation text
        tvOrientation.text = userManager.orientationText as String
        //tvOrientation.font = UIFont(name: "System", size: 70)
        
        //process the text object through the speech navigation model
        //ttsProtocol.speakTheText(tvMaterial.text)
        
        //disable the back navigation
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //speak the protocol text
        ttsProtocol.speakTheText(userManager.orientationText)
    }


}
