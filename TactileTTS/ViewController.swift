//
//  ViewController.swift
//  TactileTTS
//
//  Created by Administrator on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tvMaterial: UITextView!
    
    @IBAction func StartStop(sender: UITapGestureRecognizer) {
        tts.playTTS(tvMaterial.text)
    }
    
    var tts = TactileTTSModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

