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

class HomeViewController: UIViewController, CalendarViewDelegate {
  
  // Declare and initialize types of careers
  
  let careerTypes:[String] = ["Investment Banking", "Engineering", "Trading", "Sangeet"]
  let careerTypeImages:[String:String] = ["Investment Banking":"briefcase", "Engineering":"engineeringLogo", "Trading":"tradeIcon", "Sangeet":"briefcase"]
  let careersTestTypes:[String:[String]] = ["Investment Banking":["Numerical Reasoning","Logical Reasoning","Verbal Reasoning"], "Engineering":["Numerical Reasoning"], "Trading":["Logical Reasoning"], "Sangeet":["Verbal Reasoning","Logical Reasoning"]]
  
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  let statsView:UIView = UIView()
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
  
  let borderWidth:CGFloat = 3
  
  let buttonHeight:CGFloat = 50
  var loginPageControllerViewHeight:CGFloat = 50
  
  var segueFromLoginView:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Add background image to HomeViewController's view
    
    self.view.addHomeBG()
    
    // Add logoImageView and profilePictureImageView to HomeViewController view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.profilePictureImageView)
    self.view.addSubview(self.sloganImageView)
    self.view.addSubview(self.statsView)
    self.view.addSubview(self.statsButton)
    self.view.addSubview(self.settingsButton)
    self.view.addSubview(self.careersBackgroundView)
    self.careersBackgroundView.addSubview(self.logOutButton)
    self.careersBackgroundView.addSubview(self.careersScrollView)
    self.careersBackgroundView.addSubview(self.scrollInfoLabel)
    
    //add actions to buttons
    
    self.logOutButton.addTarget(self, action: "logoutBtnPressed:", forControlEvents: .TouchUpInside)
    self.settingsButton.addTarget(self, action: "hideCareersBackgroundView:", forControlEvents: .TouchUpInside)
    
    // Create testTypeViews for each testType
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      let careerButtonAtIndex:CareerButton = CareerButton()
      
      // Set careerButton properties
      
      careerButtonAtIndex.careerTitle = self.careerTypes[index]
      careerButtonAtIndex.careerImage = UIImage.init(named: self.careerTypeImages[self.careerTypes[index]]!)!
      
      careerButtonAtIndex.borderWidth = self.borderWidth
      
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
    
    self.settingsButton.contentMode = UIViewContentMode.ScaleAspectFit
    self.settingsButton.setImage(UIImage.init(named: "settings"), forState: UIControlState.Normal)
    
    self.logOutButton.backgroundColor = UIColor.turquoiseColor()
    self.logOutButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.logOutButton.setTitle("Log Out", forState: UIControlState.Normal)
    self.logOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Careers"
    
    // Customize careersBackgroundView and statsView
    
    self.careersBackgroundView.backgroundColor = UIColor.whiteColor()
    self.careersBackgroundView.layer.cornerRadius = self.minorMargin
    
    self.statsView.backgroundColor = UIColor.whiteColor()
    self.statsView.layer.cornerRadius = self.minorMargin
    self.statsView.alpha = 0
    self.statsView.clipsToBounds = true
    
    //calendar
    // todays date.
    let date = NSDate()
    
    // create an instance of calendar view with
    // base date (Calendar shows 12 months range from current base date)
    // selected date (marked dated in the calendar)
    let calendarView = CalendarView.instance(date, selectedDate: date)
    calendarView.delegate = self
    calendarView.translatesAutoresizingMaskIntoConstraints = false
    statsView.addSubview(calendarView)
    
    let calendarViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: calendarView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statsView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let calendarViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: calendarView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.statsView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let calendarViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: calendarView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.statsView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let calendarViewBottomConstraint = NSLayoutConstraint.init(item: calendarView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.statsView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    self.view.addConstraints([calendarViewRightConstraint, calendarViewLeftConstraint, calendarViewBottomConstraint, calendarViewHeightConstraint])
    
    // Constraints for calendar view - Fill the parent view.
    //statsView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    //statsView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    
    // Customize careersScrollView
    
    self.careersScrollView.showsVerticalScrollIndicator = false
    
    // Set constraints
    
    self.setConstraints()
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "careerClicked" {
      let destinationVC:TestSelectionViewController = segue.destinationViewController as! TestSelectionViewController
      destinationVC.testTypes = self.careersTestTypes[sender!.careerTitle]!
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
    
    let profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.screenFrame.height - (self.loginPageControllerViewHeight + self.buttonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([self.profilePictureImageViewCenterXConstraint, profilePictureImageViewCenterYConstraint])
    
    /* Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.logoImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin * 2)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewHeightConstraint, profilePictureImageViewWidthConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, profilePictureImageViewTopConstraint])*/
    
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
    
    // Create and add constraints for statsView
    
    self.statsView.translatesAutoresizingMaskIntoConstraints = false
    
    let statsViewTopConstraint = NSLayoutConstraint.init(item: self.statsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let statsViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let statsViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let statsViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.majorMargin * -1)
    
    self.view.addConstraints([statsViewTopConstraint, statsViewLeftConstraint, statsViewRightConstraint, statsViewBottomConstraint])
    
    // Create and add constraints for settingsButton
    
    self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.settingsButton.addConstraints([settingsButtonHeightConstraint, settingsButtonWidthConstraint])
    self.view.addConstraints([settingsButtonLeftConstraint, settingsButtonTopConstraint])
    
    // Create and add constraints for statsButton
    
    self.statsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let statsButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let statsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let statsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let statsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.statsButton.addConstraints([statsButtonHeightConstraint, statsButtonWidthConstraint])
    self.view.addConstraints([statsButtonRightConstraint, statsButtonTopConstraint])
    
    // Create and add constraints for careersBackgroundView
    
    self.careersBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.buttonHeight * 4.5))
    
    let careersBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let careersBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.careersBackgroundViewBottomConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 8) + (self.buttonHeight * 4.5))
    
    self.careersBackgroundView.addConstraint(careersBackgroundViewHeightConstraint)
    self.view.addConstraints([careersBackgroundViewRightConstraint, careersBackgroundViewLeftConstraint, self.careersBackgroundViewBottomConstraint])
    
    // Create and add constraints for logOutButton
    
    self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
    
    let logOutButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let logOutButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    let logOutButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let logOutButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    self.logOutButton.addConstraint(logOutButtonHeightConstraint)
    self.view.addConstraints([logOutButtonLeftConstraint, logOutButtonBottomConstraint, logOutButtonRightConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight/2)
    
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
      self.loadUser()
    }
    else {
      self.view.loginUser(self)
    }
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      
      if self.segueFromLoginView {
        self.logoImageViewBottomConstraint.constant = self.statusBarFrame.height + self.minorMargin + (self.screenFrame.width/12) - self.profilePictureImageView.frame.minY
        self.profilePictureImageViewCenterXConstraint.constant = (self.screenFrame.width + (self.logoImageView.frame.width/2)) * -1
        self.sloganImageViewCenterXConstraint.constant = self.screenFrame.width + (self.logoImageView.frame.width/2)
        self.view.layoutIfNeeded()
      }
      
      self.showCareersBackgroundView()
      
      }, completion: nil)
  }
  
  func loadUser() {
    
    let user = PFUser.currentUser()!
    
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
      
      self.careersBackgroundViewBottomConstraint.constant = self.minorMargin
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
          
          self.statsView.alpha = 1
          
          }, completion: nil)
        
    })
    
  }
  
  func hideCareersBackgroundView(sender: UIButton) {
    
    
    UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.statsView.alpha = 0
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
          
          self.careersBackgroundViewBottomConstraint.constant = (self.minorMargin * 8) + (self.buttonHeight * 4.5)
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