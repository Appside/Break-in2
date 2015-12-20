//
//  SettingsViewController.swift
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

class SettingsViewController: UIViewController, UIScrollViewDelegate {
  
  // Declare and initialize types of settings
  
  let settings:[String] = ["Upgrade", "Help","About","Feedback"]
  var careerTypes:[String] = [String]()
  var careerTypeImages:[String:String] = [String:String]()
  
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  let settingsMenuView:UIView = UIView()
  let chooseCareersView:UIView = UIView()
  let facebookLogoutButton:FacebookButton = FacebookButton()
  let scrollInfoLabel:UILabel = UILabel()
  let settingsScrollView:UIScrollView = UIScrollView()
  var settingsButtons:[CareerButton] = [CareerButton]()
  let chooseCareersPageControllerView:PageControllerView = PageControllerView()
  let chooseCareersInfoLabel:UILabel = UILabel()
  let chooseCareersScrollView:UIScrollView = UIScrollView()
  var chooseCareerViews:[ChooseCareerView] = [ChooseCareerView]()
  
  var settingsMenuViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var chooseCareersPageControllerViewHeight:CGFloat = 50
  
  // Declare and initialize tracking variables
  
  var currentChooseCareersScrollViewPage:Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addHomeBG()
    
    // Add subviews to the main view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.backButton)
    self.view.addSubview(self.settingsMenuView)
    self.view.addSubview(self.chooseCareersView)
    
    self.settingsMenuView.addSubview(self.facebookLogoutButton)
    self.settingsMenuView.addSubview(self.scrollInfoLabel)
    self.settingsMenuView.addSubview(self.settingsScrollView)
    
    self.chooseCareersView.addSubview(self.chooseCareersPageControllerView)
    self.chooseCareersView.addSubview(self.chooseCareersInfoLabel)
    self.chooseCareersView.addSubview(self.chooseCareersScrollView)
    
    // Adjust backButton appearance
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    // Customize and add content to imageViews
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    // Customize settingMenuView and chooseCareersView
    
    self.settingsMenuView.backgroundColor = UIColor.whiteColor()
    self.settingsMenuView.layer.cornerRadius = self.minorMargin
    
    self.chooseCareersView.backgroundColor = UIColor.whiteColor()
    self.chooseCareersView.layer.cornerRadius = self.minorMargin
    self.chooseCareersView.clipsToBounds = true
    self.chooseCareersView.alpha = 0
    
    // Customize facebookLogoutButton
    
    self.facebookLogoutButton.facebookButtonTitle = "Deactivate"
    self.facebookLogoutButton.displayButton()
    self.facebookLogoutButton.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    // Customize scrollInfoLabel and chooseCareersInfoLabel
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Settings"
    
    self.chooseCareersInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.chooseCareersInfoLabel.textAlignment = NSTextAlignment.Center
    self.chooseCareersInfoLabel.textColor = UIColor.lightGrayColor()
    self.chooseCareersInfoLabel.numberOfLines = 0
    self.chooseCareersInfoLabel.text = "Select The Careers You Are Interested In"
    
    // Customize settingsScrollView and chooseCareersScrollView
    
    self.settingsScrollView.showsVerticalScrollIndicator = false
    
    self.chooseCareersScrollView.pagingEnabled = true
    self.chooseCareersScrollView.showsHorizontalScrollIndicator = true
    self.chooseCareersScrollView.delegate = self
    
    // Customize chooseCareersPageControllerView
    
    self.chooseCareersPageControllerView.minorMargin = self.minorMargin
    self.chooseCareersPageControllerView.numberOfPages = self.careerTypes.count
    
    // Create settingsButtons for each setting
    
    for var index:Int = 0 ; index < self.settings.count ; index++ {
      
      let settingsButtonAtIndex:CareerButton = CareerButton()
      
      // Set settingsButton properties
      
      settingsButtonAtIndex.careerTitle = self.settings[index]
      settingsButtonAtIndex.borderWidth = self.borderWidth
      
      // Call method to display careerButton content and add to settingsScrollView
      
      self.settingsScrollView.addSubview(settingsButtonAtIndex)
      settingsButtonAtIndex.displayButton()
      
      // Store each button in the careerButtons array
      
      self.settingsButtons.append(settingsButtonAtIndex)
      
      // Make each button perform a segue to the TestSelectionViewController
      
      settingsButtonAtIndex.addTarget(self, action: "hideSettingsMenuView:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      // Create each chooseCareerView
      
      let chooseCareerViewAtIndex:ChooseCareerView = ChooseCareerView()
      
      // Set chooseCareerView properties
      
      chooseCareerViewAtIndex.careerTitle = self.careerTypes[index]
      chooseCareerViewAtIndex.careerImage = UIImage.init(named: self.careerTypeImages[self.careerTypes[index]]!)!
      
      chooseCareerViewAtIndex.majorMargin = self.majorMargin
      chooseCareerViewAtIndex.minorMargin = self.minorMargin
      
      let chooseCareersViewHeight = self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.statusBarFrame.height + self.backButtonHeight)
      chooseCareerViewAtIndex.height =  chooseCareersViewHeight - (self.chooseCareersPageControllerViewHeight * 2)
      
      chooseCareerViewAtIndex.clipsToBounds = true
      
      // Call method to display chooseCareerView
      
      chooseCareerViewAtIndex.displayView()
      
      // Add each chooseCareerView to chooseCareersScrollView
      
      self.chooseCareersScrollView.addSubview(chooseCareerViewAtIndex)
      
      // Store each chooseCareerView into the chooseCareerViews array
      
      self.chooseCareerViews.append(chooseCareerViewAtIndex)
      
    }

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
    
    self.showSettingsMenuView()
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
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for backButton
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
    // Create and add constraints for settingsMenuView
    
    self.settingsMenuView.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsMenuViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.menuButtonHeight * 4.5))
    
    let settingsMenuViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let settingsMenuViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.settingsMenuViewBottomConstraint = NSLayoutConstraint.init(item: self.settingsMenuView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 8) + (self.menuButtonHeight * 4.5))
    
    self.settingsMenuView.addConstraint(settingsMenuViewHeightConstraint)
    self.view.addConstraints([settingsMenuViewRightConstraint, settingsMenuViewLeftConstraint, self.settingsMenuViewBottomConstraint])
    
    // Create and add constraints for chooseCareersView
    
    self.chooseCareersView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersViewTopConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let chooseCareersViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let chooseCareersViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))
    
    self.chooseCareersView.addConstraint(chooseCareersViewHeightConstraint)
    self.view.addConstraints([chooseCareersViewTopConstraint, chooseCareersViewLeftConstraint, chooseCareersViewRightConstraint])
    
    // Create and add constraints for facebookLogoutButton
    
    self.facebookLogoutButton.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLogoutButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    let facebookLogoutButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let facebookLogoutButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let facebookLogoutButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.facebookLogoutButton.addConstraint(facebookLogoutButtonHeightConstraint)
    self.view.addConstraints([facebookLogoutButtonLeftConstraint, facebookLogoutButtonRightConstraint, facebookLogoutButtonBottomConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight/2)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for settingsScrollView
    
    self.settingsScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.facebookLogoutButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let settingsScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsMenuView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let settingsScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([settingsScrollViewLeftConstraint, settingsScrollViewBottomConstraint, settingsScrollViewRightConstraint, settingsScrollViewTopConstraint])
    
    // Create and add constraints for each settingsButton and set content size for settingsScrollView
    
    for var index:Int = 0 ; index < self.settingsButtons.count ; index++ {
      
      self.settingsButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
      
      let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * (self.majorMargin + self.minorMargin)))
      
      if index == 0 {
        
        let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(settingsButtonTopConstraint)
        
      }
      else {
        
        let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsButtons[index - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
        
        self.view.addConstraint(settingsButtonTopConstraint)
        
      }
      
      self.settingsButtons[index].addConstraints([settingsButtonWidthConstraint, settingsButtonHeightConstraint])
      self.view.addConstraint(settingsButtonLeftConstraint)
      
      if index == self.settingsButtons.count - 1 {
        
        let settingsButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButtons[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraint(settingsButtonBottomConstraint)
        
      }
      
    }
    
    // Create and add constraints for chooseCareersPageControllerView
    
    self.chooseCareersPageControllerView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersPageControllerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersPageControllerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let chooseCareersPageControllerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersPageControllerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let chooseCareersPageControllerViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersPageControllerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let chooseCareersPageControllerViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersPageControllerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.chooseCareersPageControllerViewHeight)
    
    self.chooseCareersPageControllerView.addConstraint(chooseCareersPageControllerViewHeightConstraint)
    self.view.addConstraints([chooseCareersPageControllerViewTopConstraint, chooseCareersPageControllerViewLeftConstraint, chooseCareersPageControllerViewRightConstraint])
    
    // Create and add constraints for chooseCareersInfoLabel
    
    self.chooseCareersInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersPageControllerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let chooseCareersInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let chooseCareersInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let chooseCareersInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.chooseCareersPageControllerViewHeight - self.minorMargin)
    
    self.chooseCareersInfoLabel.addConstraint(chooseCareersInfoLabelHeightConstraint)
    self.view.addConstraints([chooseCareersInfoLabelTopConstraint, chooseCareersInfoLabelLeftConstraint, chooseCareersInfoLabelRightConstraint])
    
    // Create and add constraints for chooseCareersScrollView
    
    self.chooseCareersScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let chooseCareersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let chooseCareersScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.view.addConstraints([chooseCareersScrollViewLeftConstraint, chooseCareersScrollViewBottomConstraint, chooseCareersScrollViewRightConstraint, chooseCareersScrollViewTopConstraint])
    
    // Create and add constraints for each chooseCareerView and set content size for chooseCareersScrollView
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      self.chooseCareerViews[index].translatesAutoresizingMaskIntoConstraints = false
      
      let chooseCareerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let chooseCareerViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      
      let chooseCareerViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * self.majorMargin))
      
      if index == 0 {
        
        let chooseCareerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareerViewLeftConstraint)
        
      }
      else {
        
        let chooseCareerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareerViews[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareerViewLeftConstraint)
        
      }
      
      self.chooseCareerViews[index].addConstraint(chooseCareerViewWidthConstraint)
      self.view.addConstraints([chooseCareerViewTopConstraint, chooseCareerViewBottomConstraint])
      
      if index == self.chooseCareerViews.count - 1 {
        
        let chooseCareersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.chooseCareerViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.chooseCareersScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(chooseCareersScrollViewRightConstraint)
        
      }
      
    }

  }
  
  @IBAction func testClicked(sender: AnyObject) {
    self.performSegueWithIdentifier("test", sender: nil)
    
  }
  
  func showSettingsMenuView() {
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.backButton.alpha = 1
      self.settingsMenuViewBottomConstraint.constant = self.minorMargin
      self.chooseCareersView.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }

  func hideSettingsMenuView(sender:UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.chooseCareersView.alpha = 0
      self.backButton.alpha = 0
      self.settingsMenuViewBottomConstraint.constant = (self.minorMargin * 8) + (self.menuButtonHeight * 4.5)
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        if sender == self.backButton {
          self.performSegueWithIdentifier("backFromEditProfile", sender: self.backButton)
        }
        else if sender == self.facebookLogoutButton {
          self.deleteFBTapped(self.facebookLogoutButton)
        }
        
    })
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "backFromEditProfile" {
      let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
      destinationVC.segueFromLoginView = false
    }
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    self.currentChooseCareersScrollViewPage = Int(self.chooseCareersScrollView.contentOffset.x / self.chooseCareersScrollView.frame.size.width)
    self.chooseCareersPageControllerView.updatePageController(self.currentChooseCareersScrollViewPage)

  }
  
}
