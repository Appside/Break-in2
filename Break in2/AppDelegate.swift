//
//  AppDelegate.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Parse
import Bolts
import ParseUI
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Start and setup Firebase
        FIRApp.configure()
        
        // [Optional] Parse also lets you store objects in a local datastore on the device itself
        Parse.enableLocalDatastore()
        
        // Initialize Parse
        Parse.setApplicationId("lyBSquMqLt6vuW5bL6ZB3TP37cGpDDZ3Vvqt13S5",
            clientKey: "kMneqHnKIjyIRg9qJlgRhLkh5hrzl7eAWxl8YHGm")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController;
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("homeVC")
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("navigationVC")
        }
        
        let screenFrame:CGRect = UIScreen.mainScreen().bounds
        
        self.window = UIWindow(frame: screenFrame)
        self.window?.rootViewController = startViewController;
        //self.window?.makeKeyAndVisible()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //return true
    }

    //function to launch facebook app or safari
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //track app usage
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        //FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
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

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation!.setDeviceTokenFromData(deviceToken)
        installation!.channels = ["global"]
        installation!.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    



}

