//
//  TTSTrainingViewController.swift
//  TactileTTS
//
//  Created by Administrator on 11/19/15.
//  Copyright © 2015 David Sweeney. All rights reserved.
//

import UIKit

class TTSTrainingViewController: UIViewController {
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
    }

    @IBAction func doubleSwipeLeft(sender: UISwipeGestureRecognizer) {
    }
    
    @IBAction func doubleSwipeRight(sender: UISwipeGestureRecognizer) {
    }
    
    var ttsTraining = TTSModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Navigation Training"

        // Do any additional setup after loading the view.
        
        var trainingInstructions = "This screen provides an opportunity for you to practice navigating the text. "
        trainingInstructions.appendContentsOf("There are five types of navigation. Tapping the screen alternates the pausing and starting the speech. Swiping right with a single finger navigates back one sentence. Swiping left navigates forward one sentence. By swiping with two fingers, you will navigate by paragraph. Try these gestures now. When you are finished, tap the continue button at the bottom of the view.")
        
        
        ttsTraining.speakTheText(trainingInstructions)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setViewControllers([self], animated: false)
        
        
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
