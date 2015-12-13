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
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.addHomeBG()
      
      // Add subviews to the main view
      
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.profilePictureImageView)
      self.view.addSubview(self.backButton)
      
      // Adjust backButton appearance
      
      self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
      self.backButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
      self.backButton.clipsToBounds = true
      
      // Customize and add content to imageViews
      
      self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
      
      self.profilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.profilePictureImageView.image = UIImage.init(named: "planeLogo")!
      
      // Set constraints
      
      self.setConstraints()
        
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
                
                let user = PFUser.currentUser()!
                ParseExtensions.deleteUserFB(user)
                
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
  
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewBottomConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    let profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + (self.minorMargin * 2) + (self.screenFrame.width/6) + self.screenFrame.width/12)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, profilePictureImageViewCenterYConstraint])

    // Create and add constraints for backButton
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
  }
  
    @IBAction func testClicked(sender: AnyObject) {
         self.performSegueWithIdentifier("test", sender: nil)
        
    }
  func hideTestSelectionView(sender:UIButton) {
    
    if sender == self.backButton {
      self.performSegueWithIdentifier("backFromEditProfile", sender: self.backButton)
    }
    
  }
    
}
