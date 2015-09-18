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
        tts.startStop()
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        tts.goForward()
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        tts.goBack()
    }
    
    var tts = TactileTTSModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tts.play(tvMaterial.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

