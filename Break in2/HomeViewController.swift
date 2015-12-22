//
//  HomeViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import QuartzCore
import Parse
import ParseUI
import SCLAlertView

class HomeViewController: UIViewController {
  
  // Declare and initialize types of careers
  
  var careerTypes:[String] = [String]()
  var careerTypeImages:[String:String] = [String:String]()
  var careersTestTypes:[String:[String]] = [String:[String]]()
  var careerColors:[String:UIColor] = [String:UIColor]()
  
  // Declare and initialize views and models
  
  let homeViewModel:JSONModel = JSONModel()
    
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  let calendarBackgroundView:UIView = UIView()
  let calendarView:CalendarView = CalendarView()
  let statsButton:UIButton = UIButton()
  let settingsButton:UIButton = UIButton()
  let logOutButton:UIButton = UIButton()
  let careersBackgroundView:UIView = UIView()
  let careersScrollView:UIScrollView = UIScrollView()
  var careerButtons:[CareerButton] = [CareerButton]()
  let scrollInfoLabel:UILabel = UILabel()
  
  var careersBackgroundViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var loginPageControllerViewHeight:CGFloat = 50
  
  var segueFromLoginView:Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Get app variables
    
    self.careerTypes = self.homeViewModel.getAppVariables("careerTypes") as! [String]
    self.careerTypeImages = self.homeViewModel.getAppVariables("careerTypeImages") as! [String:String]
    self.careersTestTypes = self.homeViewModel.getAppVariables("careersTestTypes") as! [String:[String]]
    
    let appColors:[UIColor] = self.homeViewModel.getAppColors()
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      self.careerColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }
    
    // Add background image to HomeViewController's view
    
    self.view.addHomeBG()
    
    // Add logoImageView and profilePictureImageView to HomeViewController view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.profilePictureImageView)
    self.view.addSubview(self.sloganImageView)
    self.view.addSubview(self.calendarBackgroundView)
    self.view.addSubview(self.statsButton)
    self.view.addSubview(self.settingsButton)
    self.view.addSubview(self.careersBackgroundView)
    self.calendarBackgroundView.addSubview(self.calendarView)
    self.careersBackgroundView.addSubview(self.logOutButton)
    self.careersBackgroundView.addSubview(self.careersScrollView)
    self.careersBackgroundView.addSubview(self.scrollInfoLabel)
    
    // Create testTypeViews for each testType
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      let careerButtonAtIndex:CareerButton = CareerButton()
      
      // Set careerButton properties
      
      careerButtonAtIndex.careerTitle = self.careerTypes[index]
      careerButtonAtIndex.careerImage = UIImage.init(named: self.careerTypeImages[self.careerTypes[index]]!)!
      careerButtonAtIndex.careerColorView.backgroundColor = self.careerColors[self.careerTypes[index]]
      
      // Call method to display careerButton content
      
      careerButtonAtIndex.displayButton()
      
      // Store each button in the careerButtons array
      
      self.careerButtons.append(careerButtonAtIndex)
      
      // Make each button perform a segue to the TestSelectionViewController
      
      self.careerButtons[index].addTarget(self, action: "hideCareersBackgroundView:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // Add careerButtons to careersScrollView
    
    for careerButtonAtIndex:CareerButton in self.careerButtons {
      
      self.careersScrollView.addSubview(careerButtonAtIndex)
      
    }
    
    // Customize and add content to imageViews
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    self.profilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.profilePictureImageView.image = UIImage.init(named: "planeLogo")!
    
    self.sloganImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.sloganImageView.image = UIImage.init(named: "asSlogan")
    
    self.statsButton.contentMode = UIViewContentMode.ScaleAspectFit
    self.statsButton.setImage(UIImage.init(named: "statistics"), forState: UIControlState.Normal)
    self.statsButton.alpha = 0
    
    self.settingsButton.contentMode = UIViewContentMode.ScaleAspectFit
    self.settingsButton.setImage(UIImage.init(named: "settings"), forState: UIControlState.Normal)
    self.settingsButton.alpha = 0
    
    self.logOutButton.backgroundColor = UIColor.turquoiseColor()
    self.logOutButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.logOutButton.setTitle("Log Out", forState: UIControlState.Normal)
    self.logOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Careers"
    
    // Add actions to buttons
    
    self.logOutButton.addTarget(self, action: "logoutBtnPressed:", forControlEvents: .TouchUpInside)
    self.settingsButton.addTarget(self, action: "hideCareersBackgroundView:", forControlEvents: .TouchUpInside)
    
    // Customize careersBackgroundView, deadlinesView and statsView
    
    self.careersBackgroundView.backgroundColor = UIColor.whiteColor()
    self.careersBackgroundView.layer.cornerRadius = self.minorMargin
    
    self.calendarBackgroundView.backgroundColor = UIColor.whiteColor()
    self.calendarBackgroundView.layer.cornerRadius = self.minorMargin
    self.calendarBackgroundView.alpha = 0
    self.calendarBackgroundView.clipsToBounds = true
    
    self.calendarView.backgroundColor = UIColor.whiteColor()
    self.calendarView.layer.cornerRadius = self.minorMargin
    self.calendarView.clipsToBounds = true
    
    // Customize careersScrollView
    
    self.careersScrollView.showsVerticalScrollIndicator = false
    
    // Set constraints
    
    self.setConstraints()
    
    // Display calendar
    
    self.calendarView.displayCalendar()
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "careerClicked" {
      let destinationVC:TestSelectionViewController = segue.destinationViewController as! TestSelectionViewController
      destinationVC.testTypes = self.careersTestTypes[sender!.careerTitle]!
    }
    if segue.identifier == "settingsClicked" {
      let destinationVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
      destinationVC.careerTypes = self.careerTypes
      destinationVC.careerTypeImages = self.careerTypeImages
    }
  }
  
    func didSelectDate(date: NSDate) {
        //print("(date.year)-(date.month)-(date.day)")
    }
    
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    if segueFromLoginView {
      self.logoImageViewBottomConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    }
    else {
      self.logoImageViewBottomConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin + (self.screenFrame.width/12))
    }
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, self.logoImageViewBottomConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    if self.segueFromLoginView {
      self.profilePictureImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    }
    else {
      self.profilePictureImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: (self.screenFrame.width + (self.logoImageView.frame.width/2)) * -1)
    }
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    let profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.screenFrame.height - (self.loginPageControllerViewHeight + self.menuButtonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([self.profilePictureImageViewCenterXConstraint, profilePictureImageViewCenterYConstraint])
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    if self.segueFromLoginView {
      self.sloganImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    }
    else {
      self.sloganImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: self.screenFrame.width + (self.logoImageView.frame.width/2))
    }
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([self.sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
    // Create and add constraints for calendarBackgroundView
    
    self.calendarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let calendarBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let calendarBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let calendarBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))
    
    self.calendarBackgroundView.addConstraint(calendarBackgroundViewHeightConstraint)
    self.view.addConstraints([calendarBackgroundViewTopConstraint, calendarBackgroundViewLeftConstraint, calendarBackgroundViewRightConstraint])

    // Create and add constraints for calendarView
    
    self.calendarView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarViewTopConstraint = NSLayoutConstraint.init(item: self.calendarView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let calendarViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let calendarViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let calendarViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    self.view.addConstraints([calendarViewTopConstraint, calendarViewLeftConstraint, calendarViewRightConstraint, calendarViewBottomConstraint])
    
    // Create and add constraints for settingsButton
    
    self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.settingsButton.addConstraints([settingsButtonHeightConstraint, settingsButtonWidthConstraint])
    self.view.addConstraints([settingsButtonLeftConstraint, settingsButtonTopConstraint])
    
    // Create and add constraints for statsButton
    
    self.statsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let statsButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let statsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let statsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let statsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.statsButton.addConstraints([statsButtonHeightConstraint, statsButtonWidthConstraint])
    self.view.addConstraints([statsButtonRightConstraint, statsButtonTopConstraint])
    
    // Create and add constraints for careersBackgroundView
    
    self.careersBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.menuButtonHeight * 4.5))
    
    let careersBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let careersBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.careersBackgroundViewBottomConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 8) + (self.menuButtonHeight * 4.5))
    
    self.careersBackgroundView.addConstraint(careersBackgroundViewHeightConstraint)
    self.view.addConstraints([careersBackgroundViewRightConstraint, careersBackgroundViewLeftConstraint, self.careersBackgroundViewBottomConstraint])
    
    // Create and add constraints for logOutButton
    
    self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
    
    let logOutButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let logOutButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    let logOutButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let logOutButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.logOutButton.addConstraint(logOutButtonHeightConstraint)
    self.view.addConstraints([logOutButtonLeftConstraint, logOutButtonBottomConstraint, logOutButtonRightConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight/2)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for careersScrollView
    
    self.careersScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let careersScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.logOutButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let careersScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let careersScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([careersScrollViewLeftConstraint, careersScrollViewBottomConstraint, careersScrollViewRightConstraint, careersScrollViewTopConstraint])
    
    // Create and add constraints for each careerButton and set content size for careersScrollView
    
    for var index:Int = 0 ; index < self.careerButtons.count ; index++ {
      
      self.careerButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let careerButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let careerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
      
      let careerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * (self.majorMargin + self.minorMargin)))
      
      if index == 0 {
        
        let careerButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(careerButtonTopConstraint)
        
      }
      else {
        
        let careerButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careerButtons[index - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
        
        self.view.addConstraint(careerButtonTopConstraint)
        
      }
      
      self.careerButtons[index].addConstraints([careerButtonWidthConstraint, careerButtonHeightConstraint])
      self.view.addConstraint(careerButtonLeftConstraint)
      
      if index == self.careerButtons.count - 1 {
        
        let careerButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraint(careerButtonBottomConstraint)
        
      }
      
    }
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if (PFUser.currentUser() != nil) {
      self.loadUser(PFUser.currentUser()!)
    }
    else {
      self.view.loginUser(self)
    }
    
    if self.segueFromLoginView {
      
      UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        
        self.logoImageViewBottomConstraint.constant = self.statusBarFrame.height + self.minorMargin + (self.screenFrame.width/12) - self.profilePictureImageView.frame.minY
        self.profilePictureImageViewCenterXConstraint.constant = (self.screenFrame.width + (self.logoImageView.frame.width/2)) * -1
        self.sloganImageViewCenterXConstraint.constant = self.screenFrame.width + (self.logoImageView.frame.width/2)
        self.view.layoutIfNeeded()
        
        }, completion: {(Bool) in
          
          self.showCareersBackgroundView()
          
      })
      
    }
    else {
      self.showCareersBackgroundView()
    }
    
    self.showCareersBackgroundView()
    
  }
  
    func loadUser(user: PFUser) {
    
    //
    
  }
  
  func logoutBtnPressed(sender: UIButton!){
    
    let alertView = SCLAlertView()
    //        alertView.addButton("Ok", target:self, selector:Selector("logOut"))
    //        alertView.addButton("Cancel") {
    //            alertView.clearAllNotice()
    //        }
    //        alertView.showCloseButton = false
    //        alertView.showViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
    //        alertView.showWarning("Logout", subTitle: "Are You Sure You Want To Exit?")
    
    alertView.addButton("Ok", target:self, selector:Selector("logOut"))
    alertView.showTitle(
      "Logout", // Title of view
      subTitle: "Are You Sure You Want To Exit?", // String of view
      duration: 0.0, // Duration to show before closing automatically, default: 0.0
      completeText: "Cancel", // Optional button value, default: ""
      style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
      colorStyle: 0x526B7B,//0xD0021B - RED
      colorTextButton: 0xFFFFFF
    )
    alertView.showCloseButton = false
    
    
  }
  
  func logOut(){
    
    PFUser.logOut()
    self.hideCareersBackgroundView(self.logOutButton)
    
  }
  
  func settingsBtnPressed(sender: UIButton!){
    
    self.performSegueWithIdentifier("settingsClicked", sender: nil)
    
  }
  
  func showCareersBackgroundView() {
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.settingsButton.alpha = 1
      self.statsButton.alpha = 1
      self.careersBackgroundViewBottomConstraint.constant = self.minorMargin
      if !self.segueFromLoginView {
        self.calendarBackgroundView.alpha = 1
      }
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        if self.segueFromLoginView {
          UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.calendarBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        }
        
    })
    
  }
  
  func hideCareersBackgroundView(sender: UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.calendarBackgroundView.alpha = 0
      self.settingsButton.alpha = 0
      self.statsButton.alpha = 0
      self.careersBackgroundViewBottomConstraint.constant = (self.minorMargin * 8) + (self.menuButtonHeight * 4.5)
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        if sender == self.settingsButton {
          self.performSegueWithIdentifier("settingsClicked", sender: sender)
        }
        else if sender == self.logOutButton {
          UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            if self.segueFromLoginView {
              self.logoImageViewBottomConstraint.constant = self.minorMargin * -1
            }
            else {
              self.logoImageViewBottomConstraint.constant = self.profilePictureImageView.frame.minY - self.minorMargin
            }
            self.profilePictureImageViewCenterXConstraint.constant = 0
            self.sloganImageViewCenterXConstraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {(Bool) in
              self.view.loginUser(self)
          })
        }
        else {
          self.performSegueWithIdentifier("careerClicked", sender: sender)
        }
        
    })
    
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