//
//  EditProfileViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addHomeBG() //add BG image
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() != nil) {
            self.loadUser()
        }
        else {
            self.view.loginUser(self)
        }
    }
    
    @IBAction func deleteFBTapped(sender: AnyObject) {
        
        self.noticeInfo("Please wait...", autoClear: true, autoClearTime: 2)
        
        let facebookRequest: FBSDKGraphRequest! = FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, HTTPMethod: "DELETE")
        
        facebookRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if(error == nil && result != nil){
                
                self.noticeTop("Facebook account successfully deactivated", autoClear: true, autoClearTime: 3)
                self.view.loginUser(self)
                
            } else {
                if let error: NSError = error {
                    if let errorString = error.userInfo["error"] as? String {
                        self.noticeOnlyText("Please try again")
                    }
                } else {
                    self.noticeOnlyText("Please try again")
                }
            }
        }
        
    }

    func loadUser() {
        
        let user = PFUser.currentUser()!
        
    }
    
}
