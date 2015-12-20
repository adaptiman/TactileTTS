//
//  AppDelegate.swift
//  TactileTTS
//
//  Created by Administrator on 7/21/15.
//  Copyright (c) 2015 David Sweeney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let userManager = UserManager.sharedInstance
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        //load the trainingText
//        let trainingLocation = NSBundle.mainBundle().pathForResource("training", ofType: "txt")
        let trainingLocation = NSBundle.mainBundle().pathForResource("trainingshort", ofType: "txt")
        userManager.trainingText = try! NSString(contentsOfFile: trainingLocation!, encoding: NSUTF8StringEncoding)
        
        //load the protocolText
//        let protocolLocation = NSBundle.mainBundle().pathForResource("protocol", ofType: "txt")
        let protocolLocation = NSBundle.mainBundle().pathForResource("protocolshort", ofType: "txt")
        userManager.protocolText = try! NSString(contentsOfFile: protocolLocation!, encoding: NSUTF8StringEncoding)

        //load the orientationText
        let orientationLocation = NSBundle.mainBundle().pathForResource("orientation", ofType: "txt")
        userManager.orientationText = try! NSString(contentsOfFile: orientationLocation!, encoding: NSUTF8StringEncoding)
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        //NSLog("Calling Application Bundle ID: \(sourceApplication)")
        //NSLog("URL scheme: \(annotation)")
        //NSLog("URL query: \(url)")
        
        let urlString = "\(url)"
        
        if urlString == "tactiletts://startprotocol" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let protocolVC = storyboard.instantiateViewControllerWithIdentifier("protocolViewController")
            self.window?.rootViewController?.presentViewController(protocolVC, animated: true, completion: nil)
        }
        
        return true;
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

