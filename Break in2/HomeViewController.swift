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
import SwiftSpinner
import GoogleMobileAds

class HomeViewController: UIViewController, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  var newSwitch:Bool = Bool()
  var membershipCounter:Int = Int()
    
  // Declare and initialize types of careers
  
  var careerTypes:[String] = [String]()
  var careerTypeImages:[String:String] = [String:String]()
  var careersTestTypes:[String:[String]] = [String:[String]]()
  var comingSoonTestTypes:[String:[String]] = [String:[String]]()
  var careerColors:[String:UIColor] = [String:UIColor]()
  var tutorialViews:[UIView] = [UIView]()
  var tutorialDescriptions:[UIView:[String]] = [UIView:[String]]()
    
    //in app purchase initialisation
    
    let productIdentifiers = Set(["com.APPSIDE.Breakin2.ExtraLives1", "com.APPSIDE.Breakin2.UnlimitedLives1"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var list = [SKProduct]()
    var p = SKProduct()
  
  // Declare and initialize views and models
  
  let homeViewModel:JSONModel = JSONModel()
  let defaults = NSUserDefaults.standardUserDefaults()
    
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
  let tutorialView:UIView = UIView()
  let tutorialNextButton:UIButton = UIButton()
  var descriptionLabelView:TutorialDescriptionView = TutorialDescriptionView()
  var tutorialFingerImageView:UIImageView = UIImageView()
  let brainBreakerQuestionButton:UIButton = UIButton()
  let brainBreakerNewLabel:UILabel = UILabel()
  let membershipButton:UIButton = UIButton()
    
  var careersBackgroundViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var tutorialViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  var menuButtonHeight:CGFloat = 50
  var backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var calendarBackgroundViewHeight:CGFloat = 300
  var textSize:CGFloat = 15

  var segueFromLoginView:Bool = true
  var firstTimeUser:Bool = false
  var tutorialPageNumber:Int = 0
    
    //Admob banner
    var bannerView:DFPBannerView = DFPBannerView()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.userLoggedIn()
    
    // Do any additional setup after loading the view.
    
    // Get app variables
    
    self.careerTypes = self.homeViewModel.getAppVariables("careerTypes") as! [String]
    self.careerTypeImages = self.homeViewModel.getAppVariables("careerTypeImages") as! [String:String]
    self.careersTestTypes = self.homeViewModel.getAppVariables("careersTestTypes") as! [String:[String]]
    self.comingSoonTestTypes = self.homeViewModel.getAppVariables("comingSoonTestTypes") as! [String:[String]]
    
    let appColors:[UIColor] = self.homeViewModel.getAppColors()
    for index:Int in 0  ..< self.careerTypes.count  {
      self.careerColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }
    
    self.textSize = self.view.getTextSize(15)
    
    // Add background image to HomeViewController's view
    
    self.view.addHomeBG()
    
    // Add logoImageView and profilePictureImageView to HomeViewController view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.profilePictureImageView)
    self.view.addSubview(self.sloganImageView)
    self.view.addSubview(self.statsButton)
    self.view.addSubview(self.settingsButton)
    self.view.addSubview(self.careersBackgroundView)
    self.view.addSubview(self.calendarBackgroundView)
    self.calendarBackgroundView.addSubview(self.calendarView)
    self.careersBackgroundView.addSubview(self.logOutButton)
    self.careersBackgroundView.addSubview(self.careersScrollView)
    self.careersBackgroundView.addSubview(self.scrollInfoLabel)
    self.careersBackgroundView.addSubview(self.bannerView)
    self.view.addSubview(self.tutorialView)
    self.view.addSubview(self.tutorialNextButton)
    self.view.addSubview(self.tutorialFingerImageView)
    self.careersBackgroundView.addSubview(self.brainBreakerQuestionButton)
    self.careersBackgroundView.addSubview(self.brainBreakerNewLabel)
    self.careersBackgroundView.bringSubviewToFront(self.brainBreakerQuestionButton)
    
    // Create careerButtons for each careerType
    
    for index:Int in 0  ..< self.careerTypes.count  {
      
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
      
      self.careerButtons[index].addTarget(self, action: #selector(HomeViewController.hideCareersBackgroundView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // Add careerButtons to careersScrollView
    
    for careerButtonAtIndex:CareerButton in self.careerButtons {
      
      self.careersScrollView.addSubview(careerButtonAtIndex)
      
    }
    
    // Customize and add content to imageViews
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    self.logoImageView.clipsToBounds = true
    
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
    self.logOutButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.logOutButton.setTitle("Log Out", forState: UIControlState.Normal)
    self.logOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Careers"
    
    self.tutorialNextButton.backgroundColor = UIColor.turquoiseColor()
    self.tutorialNextButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
      self.tutorialNextButton.setTitle("Next", forState: UIControlState.Normal)
    self.tutorialNextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
    self.descriptionLabelView.clipsToBounds = false
    
    self.brainBreakerQuestionButton.setImage(UIImage.init(named: "brainBreakerLogo"), forState: UIControlState.Normal)
    
    self.brainBreakerNewLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
    self.brainBreakerNewLabel.textAlignment = NSTextAlignment.Right
    self.brainBreakerNewLabel.textColor = UIColor.redColor()
    self.brainBreakerNewLabel.text = "New!"
    
    self.newSwitch = defaults.boolForKey("newSwitchBB")
    
    if self.newSwitch == true{
    
      self.brainBreakerNewLabel.alpha = 1
      self.defaults.setBool(false, forKey: "brainBreakerAnsweredCorrectly")
      
    }else{
      
      self.brainBreakerNewLabel.alpha = 0
      
    }
    
    // Add actions to buttons
    
    self.logOutButton.addTarget(self, action: #selector(HomeViewController.logoutBtnPressed(_:)), forControlEvents: .TouchUpInside)
    self.settingsButton.addTarget(self, action: #selector(HomeViewController.hideCareersBackgroundView(_:)), forControlEvents: .TouchUpInside)
    self.statsButton.addTarget(self, action: #selector(HomeViewController.hideCareersBackgroundView(_:)), forControlEvents: .TouchUpInside)
    self.tutorialNextButton.addTarget(self, action: #selector(HomeViewController.nextTutorialButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)

    // Customize careersBackgroundView, deadlinesView and statsView
    
    self.careersBackgroundView.backgroundColor = UIColor.whiteColor()
    self.careersBackgroundView.layer.cornerRadius = self.minorMargin
    if self.segueFromLoginView {
      self.careersBackgroundView.alpha = 1
    }
    else {
      self.careersBackgroundView.alpha = 0
    }
    
    self.calendarBackgroundView.backgroundColor = UIColor.whiteColor()
    self.calendarBackgroundView.layer.cornerRadius = self.minorMargin
    self.calendarBackgroundView.alpha = 0
    self.calendarBackgroundView.clipsToBounds = true
    
    self.calendarView.backgroundColor = UIColor.whiteColor()
    self.calendarView.layer.cornerRadius = self.minorMargin
    self.calendarView.clipsToBounds = true
    
    self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
    
    // Set tutorialView and tutorialNextButton alpha values
    
    if self.firstTimeUser {
      self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
      self.tutorialNextButton.alpha = 1
    }
    else {
      self.tutorialView.alpha = 0
      self.tutorialNextButton.alpha = 0
    }
    
    // Customize careersScrollView
    
    self.careersScrollView.showsVerticalScrollIndicator = false
    
    // Set menuButtonHeight, backButtonHeight and calendarBackgroundViewHeight
    
    if self.screenFrame.height <= 738 {
      self.calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 4)

      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.calendarBackgroundViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 6) + 25))/4
      
    }
    else {
      self.calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 14)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.calendarBackgroundViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 7) + 25))/5
    }
    
    // Set constraints
    
    self.setConstraints()
    
    // Display calendar
    
    if self.firstTimeUser && self.tutorialPageNumber == 0 {
      self.calendarView.chosenCareers = self.homeViewModel.getAppVariables("careerTypes") as! [String]
    }
    self.calendarView.displayCalendar()
    
    // Check for new Brain Breaker question
    
    self.checkNewBrainBreaker()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "careerClicked" {
      let destinationVC:TestSelectionViewController = segue.destinationViewController as! TestSelectionViewController
      destinationVC.testTypes = self.careersTestTypes[sender!.careerTitle]!
      destinationVC.comingSoonTestTypes = self.comingSoonTestTypes[sender!.careerTitle]!
      destinationVC.selectedCareer = sender!.careerTitle
    }
    if segue.identifier == "settingsClicked" {
      let destinationVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
      destinationVC.careerTypes = self.careerTypes
      destinationVC.careerTypeImages = self.careerTypeImages
      if sender as! UIButton == self.tutorialNextButton {
        destinationVC.firstTimeUser = true
      }
    }
    if segue.identifier == "statsClicked" {
      let destinationVC:StatisticsViewController = segue.destinationViewController as! StatisticsViewController
      var testTypes:[String] = [String]()
      var testColors:[String:UIColor] = [String:UIColor]()
      for career in self.careerTypes {
        for testType in self.careersTestTypes[career]! {
          if !testTypes.contains(testType) && testType != "Help Us Add More Tests:" {
            testTypes.append(testType)
          }
        }
      }
      let appColors:[UIColor] = self.homeViewModel.getAppColors()
      for index:Int in 0  ..< testTypes.count  {
        testColors.updateValue(appColors[index], forKey: testTypes[index])
      }
      destinationVC.testTypes = testTypes
      destinationVC.testColors = testColors
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
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
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
    
    let profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.screenFrame.height - (50 + self.menuButtonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
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
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([self.sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
    // Create and add constraints for calendarBackgroundView
    
    self.calendarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let calendarBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let calendarBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let calendarBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.calendarBackgroundViewHeight)
    
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
    
    let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    self.settingsButton.addConstraints([settingsButtonHeightConstraint, settingsButtonWidthConstraint])
    self.view.addConstraints([settingsButtonLeftConstraint, settingsButtonTopConstraint])
    
    // Create and add constraints for statsButton
    
    self.statsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let statsButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let statsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let statsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let statsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    self.statsButton.addConstraints([statsButtonHeightConstraint, statsButtonWidthConstraint])
    self.view.addConstraints([statsButtonRightConstraint, statsButtonTopConstraint])
    
    // Create and add constraints for membershipButton
    
    self.view.addSubview(self.membershipButton)
    self.membershipButton.alpha = 0.0
    self.membershipButton.translatesAutoresizingMaskIntoConstraints = false
    self.membershipButton.clipsToBounds = true
    self.membershipButton.layer.cornerRadius = self.screenFrame.width/24
    self.membershipButton.layer.borderWidth = 2
    self.membershipButton.layer.borderColor = UIColor.whiteColor().CGColor
    self.membershipButton.setTitle("3", forState: UIControlState.Normal)

    
    let membershipButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.membershipButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let membershipButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.membershipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let membershipButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.membershipButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    let membershipButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.membershipButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    self.membershipButton.addConstraints([membershipButtonHeightConstraint, membershipButtonWidthConstraint])
    self.view.addConstraints([membershipButtonRightConstraint, membershipButtonTopConstraint])
    
    // Create and add constraints for careersBackgroundView
    
    self.careersBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.calendarBackgroundViewHeight + self.minorMargin) + self.minorMargin)
    
    let careersBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let careersBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    if self.segueFromLoginView {
      self.careersBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.screenFrame.height)
    }
    else {
      self.careersBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.calendarBackgroundViewHeight + self.minorMargin)
    }
    
    self.careersBackgroundView.addConstraint(careersBackgroundViewHeightConstraint)
    self.view.addConstraints([careersBackgroundViewRightConstraint, careersBackgroundViewLeftConstraint, self.careersBackgroundViewTopConstraint])
    
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
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
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
    
    for index:Int in 0  ..< self.careerButtons.count  {
      
      self.careerButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let careerButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let careerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
      
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
    
    // Create and add constraints for tutorialView
    
    self.tutorialView.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    self.tutorialViewTopConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let tutorialViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height)
    
    let tutorialViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width)
    
    self.tutorialView.addConstraints([tutorialViewHeightConstraint, tutorialViewWidthConstraint])
    self.view.addConstraints([tutorialViewLeftConstraint, tutorialViewTopConstraint])
    
    // Create and add constraints for tutorialNextButton
    
    self.tutorialNextButton.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialNextButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: (self.minorMargin + self.majorMargin) * -1)
    
    let tutorialNextButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let tutorialNextButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin + self.majorMargin)
    
    let tutorialNextButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.tutorialNextButton.addConstraint(tutorialNextButtonHeightConstraint)
    self.view.addConstraints([tutorialNextButtonLeftConstraint, tutorialNextButtonBottomConstraint, tutorialNextButtonRightConstraint])
    
    // Create and add constraints for brainBreakerQuestionButton
    
    self.brainBreakerQuestionButton.translatesAutoresizingMaskIntoConstraints = false
    
    let brainBreakerQuestionButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerQuestionButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let brainBreakerQuestionButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerQuestionButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let brainBreakerQuestionButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerQuestionButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let brainBreakerQuestionButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerQuestionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
    
    self.brainBreakerQuestionButton.addConstraints([brainBreakerQuestionButtonHeightConstraint, brainBreakerQuestionButtonWidthConstraint])
    self.view.addConstraints([brainBreakerQuestionButtonRightConstraint, brainBreakerQuestionButtonTopConstraint])
    
    //Add tap Gesture to brainBreakerQuestionButton
    let brainBreakerTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.brainBreakerSegue(_:)))
    self.brainBreakerQuestionButton.addGestureRecognizer(brainBreakerTapGesture)
    
    // Create and add constraints for brainBreakerNewLabel
    
    self.brainBreakerNewLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let brainBreakerNewLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerNewLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.brainBreakerQuestionButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -5)
    
    let brainBreakerNewLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerNewLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let brainBreakerNewLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerNewLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let brainBreakerNewLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainBreakerNewLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80)
    
    self.brainBreakerNewLabel.addConstraints([brainBreakerNewLabelHeightConstraint, brainBreakerNewLabelWidthConstraint])
    self.view.addConstraints([brainBreakerNewLabelRightConstraint, brainBreakerNewLabelTopConstraint])

    
  }
    
    func brainBreakerSegue(sender:UITapGestureRecognizer) {
        
        SwiftSpinner.show("Loading")
      
        //self.newSwitch = false
        self.defaults.setBool(false, forKey: "newSwitchBB")
        
        let query = PFQuery(className: PF_BRAINBREAKER_Q_CLASS_NAME)
        //let currentUser = PFUser.currentUser()!
        //let username = currentUser.username
        //query.whereKey(PF_VERBREAS_USERNAME, equalTo: username!)
        //query.limit = 6
        query.getFirstObjectInBackgroundWithBlock({ (question: PFObject?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.isBrainBreakerDone()
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_QUESTION], forKey: "BrainBreakerQuestion")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_QUESTION_TYPE], forKey: "BrainBreakerQuestionType")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_PASSAGE], forKey: "BrainBreakerPassage")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_ANSWERS], forKey: "BrainBreakerAnswers")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_CORRECT_ANSWER], forKey: "BrainBreakerCorrectAnswerIndex")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_EXPLANATION], forKey: "BrainBreakerExplanation")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_EXPIRATION_DATE] as? NSDate ?? NSDate(), forKey: "BrainBreakerExpirationDate")
                self.defaults.setObject(question![PF_BRAINBREAKER_Q_TEST_PRIZE], forKey: "BrainBreakerTestPrize")
                self.defaults.setInteger(question![PF_BRAINBREAKER_Q_TIME_REQUIRED] as? Int ?? Int(), forKey: "MinutesToAnswerBrainBreaker")
                
                let numberCheck = self.defaults.integerForKey("BrainBreakerQuestionNumber")
                let numberCheck2 = question![PF_BRAINBREAKER_Q_Q_NUMBER] as? Int ?? Int()
                
                print(numberCheck)
                print(numberCheck2)
                
                if (numberCheck2 != numberCheck){
                    
                    let membershipType = self.defaults.objectForKey("Membership") as! String
                    
                    if (membershipType == "Premium") {
                        
                        self.defaults.setInteger(3, forKey: "NoOfBrainBreakerLives")
                        
                    }else{
                        
                        self.defaults.setInteger(1, forKey: "NoOfBrainBreakerLives")
                        
                    }
                    
                     self.defaults.setInteger(question![PF_BRAINBREAKER_Q_Q_NUMBER] as? Int ?? Int(), forKey: "BrainBreakerQuestionNumber")
                    
                }
                
                //let array = self.defaults.objectForKey("SavedCareerPreferences") as? [String] ?? [String]()
                
                SwiftSpinner.show("Tap to Proceed", animated: false).addTapHandler({
                    
                    self.performSegueWithIdentifier("BrainBreakerSegue", sender: nil)
                    SwiftSpinner.hide()
                    
                    }, subtitle: "Good luck!")
                
            }else{
                
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    
                    }, subtitle: "Tap to return to home screen")
                
            }
        })
        
    }
  
    func checkNewBrainBreaker(){
        
        let query = PFQuery(className: PF_BRAINBREAKER_Q_CLASS_NAME)
        query.getFirstObjectInBackgroundWithBlock({ (question: PFObject?, error: NSError?) -> Void in
            
            if error == nil {
                
                let numberCheckNew = self.defaults.integerForKey("BrainBreakerQuestionNumber")
                let numberCheck2New = question![PF_BRAINBREAKER_Q_Q_NUMBER] as? Int ?? Int()
                
                if (numberCheck2New != numberCheckNew){
                  
                    print("YES")
                    self.brainBreakerNewLabel.alpha = 1
                    self.defaults.setBool(true, forKey: "newSwitchBB")
                    self.defaults.setBool(false, forKey: "brainBreakerAnsweredCorrectly")
                    //self.newSwitch = true
                        
                    }else{
                  
                    print("NO")
                  
                    }
              
              //self.defaults.setInteger(question![PF_BRAINBREAKER_Q_Q_NUMBER] as? Int ?? Int(), forKey: "BrainBreakerQuestionNumber")
                
                    
                }
            
        })

        
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
    
    let membershipType = self.defaults.objectForKey("Membership") as! String
    
    if (membershipType == "Free") {
        
        self.count()
    
        self.bannerView.alpha = 0.0
        
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bannerViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.bannerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
        
        let bannerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.bannerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
        
        let bannerViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.bannerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.logOutButton.frame.height)
        
        let bannerViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.bannerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.logOutButton.frame.width)
        
        self.bannerView.addConstraints([bannerViewHeightConstraint,bannerViewWidthConstraint])
        self.view.addConstraints([bannerViewLeftConstraint, bannerViewBottomConstraint])
        
        let customSize = CGSize(width: self.logOutButton.frame.width, height: self.logOutButton.frame.height)
        let customAdSize = GADAdSizeFromCGSize(customSize)
        self.bannerView.adUnitID = AD_ID_HOMEVIEW_BANNER
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.loadRequest(DFPRequest())

    } else {
        
        self.bannerView.removeFromSuperview()
        
    }
    
    if (PFUser.currentUser() != nil) {
        self.loadUser(PFUser.currentUser()!)
    }
    else {
        self.view.loginUser(self)
    }
    
    // Show tutorial to first time users
    
    if self.firstTimeUser {
      self.tutorialViews.appendContentsOf([self.careersBackgroundView, self.calendarBackgroundView, self.settingsButton, self.statsButton, self.membershipButton])
      self.tutorialDescriptions.updateValue(["DEADLINE CALENDAR", "Staying on top of job deadlines can be tricky. Hopefully, the calender we have provided will help!\n\nDeadlines are colour coordinated with the industries to which they apply."], forKey: self.calendarBackgroundView)
      self.tutorialDescriptions.updateValue(["PRACTICE APTITUDE TESTS...", "Depending on which career you'd like to pursue, there are a number of mandatory tests. We've provided some practice for you across a range of industries.\n\n...OR HAVE SOME FUN!\n\nClick on the light bulb to try our Brain Breaker question. If you get the answer right, you will be in with a chance to win a special prize!"], forKey: self.careersBackgroundView)
      self.tutorialDescriptions.updateValue(["SETTINGS", "While we're on that subject, go to the settings page to select which careers you would like to see deadlines for."], forKey: self.settingsButton)
      self.tutorialDescriptions.updateValue(["STATISTICS", "We've also added analytics which will allow you to track your progress.\n\nAfter you have taken a few practice tests, return here to monitor your performance and track your improvement over time."], forKey: self.statsButton)
        self.tutorialDescriptions.updateValue(["", "FREE SUBSCRIPTION\n\nAs a new user, you will automatically receive 3 free lives which you can use to practice tests. We will also renew a free life every 24 hours.\n\nPREMIUM SUBSCRIPTION\n\nIf you need a little more practice, you may purchase additional tests. However, Premium membership provides you with unlimited lives, removes all advertising and gives you a couple of extra chances at the Brain Breaker."], forKey: self.membershipButton)

      self.showTutorial()
    }
    
  }
  
    func loadUser(user: PFUser) {
    
    //
    
  }
  
  func logoutBtnPressed(sender: UIButton!){
    
    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
    let alertView = SCLAlertView(appearance: appearance)
    //        alertView.addButton("Ok", target:self, selector:Selector("logOut"))
    //        alertView.addButton("Cancel") {
    //            alertView.clearAllNotice()
    //        }
    //        alertView.showCloseButton = false
    //        alertView.showViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
    //        alertView.showWarning("Logout", subTitle: "Are You Sure You Want To Exit?")
    
    alertView.addButton("Ok", target:self, selector:#selector(HomeViewController.logOut))
    alertView.addButton("Cancel", action: {
        alertView.clearAllNotice()
    })
    alertView.showTitle(
      "Logout", // Title of view
      subTitle: "Are you sure you want to exit?", // String of view
      duration: 0.0, // Duration to show before closing automatically, default: 0.0
      completeText: "Cancel", // Optional button value, default: ""
      style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
      colorStyle: 0x526B7B,//0xD0021B - RED
      colorTextButton: 0xFFFFFF
    )
    
  }
  
  func logOut(){
    
    PFUser.logOut()
    self.hideCareersBackgroundView(self.logOutButton)
    
  }
    
    func userLoggedIn(){
        
        if PFUser.currentUser() == nil {
          
            let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("navigationVC") as! LoginViewController
            self.presentViewController(navigationVC, animated: false, completion: nil)
            
        }else{
            
        }
    }
  
  func settingsBtnPressed(sender: UIButton!){
    
    self.performSegueWithIdentifier("settingsClicked", sender: nil)
    
  }
  
  func showCareersBackgroundView() {
    
    if self.segueFromLoginView {
      
      UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        
        self.settingsButton.alpha = 1
        self.statsButton.alpha = 1
        self.careersBackgroundViewTopConstraint.constant = self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.calendarBackgroundViewHeight + self.minorMargin
        self.view.layoutIfNeeded()
        
        }, completion: {(Bool) in
          
          UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.calendarBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
          
      })
      
    }
    else {
      
      UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        
        self.settingsButton.alpha = 1
        self.statsButton.alpha = 1
        self.careersBackgroundView.alpha = 1
        self.calendarBackgroundView.alpha = 1
        self.view.layoutIfNeeded()
        
        }, completion: nil)
      
    }
    
    
    
  }
  
  func hideCareersBackgroundView(sender: UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.calendarBackgroundView.alpha = 0
      self.settingsButton.alpha = 0
      self.statsButton.alpha = 0
      self.careersBackgroundView.alpha = 0
      //self.careersBackgroundViewTopConstraint.constant = self.screenFrame.height
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        if sender == self.settingsButton {
          self.performSegueWithIdentifier("settingsClicked", sender: sender)
        }
        else if sender == self.statsButton {
          self.performSegueWithIdentifier("statsClicked", sender: sender)
        }
        else if sender == self.tutorialNextButton {
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
  
  func showTutorial() {
    
    self.view.insertSubview(self.logoImageView, aboveSubview: self.tutorialView)
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(1)
      self.tutorialNextButton.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
          self.descriptionLabelView.alpha = 0
          }, completion: {(Bool) in
            self.descriptionLabelView.removeFromSuperview()
            for index:Int in 0  ..< self.tutorialViews.count  {
              if index == self.tutorialPageNumber {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialNextButton)
                self.tutorialViews[index].userInteractionEnabled = false
              }
              else {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialView)
                self.tutorialViews[index].userInteractionEnabled = true
              }
            }
            if self.tutorialViews[self.tutorialPageNumber] == self.statsButton {
              self.displayFinger(false)
              UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tutorialFingerImageView.alpha = 1
                }, completion: nil)
            }
            self.updateDescriptionLabelView()
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
              self.descriptionLabelView.alpha = 1
              }, completion: nil)

        })
    })
  }
  
  func hideTutorial() {
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.tutorialView.alpha = 0
      self.tutorialNextButton.alpha = 0
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        self.view.insertSubview(self.tutorialViews[self.tutorialPageNumber - 1], belowSubview: self.tutorialView)
        self.view.insertSubview(self.logoImageView, belowSubview: self.tutorialView)
        self.tutorialViews[self.tutorialPageNumber - 1].userInteractionEnabled = true
        
    })
  }
  
  func nextTutorialButtonClicked(sender:UIButton) {
    
    self.tutorialPageNumber += 1
    
    // Bring correct view to front or perform segues to other viewcontrollers
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        self.descriptionLabelView.alpha = 0
        self.tutorialFingerImageView.alpha = 0
        }, completion: {(Bool) in
          self.descriptionLabelView.removeFromSuperview()
          if self.tutorialViews[self.tutorialPageNumber - 1] == self.settingsButton {
            self.performSegueWithIdentifier("settingsClicked", sender: sender)
          }
          else if self.tutorialViews[self.tutorialPageNumber - 1] == self.membershipButton {
            self.tutorialFingerImageView.alpha = 0.0
            self.membershipButton.alpha = 0.0
            self.hideTutorial()
            self.tutorialNextButton.setTitle("Next", forState: UIControlState.Normal)
          }
          else {
            for index:Int in 0  ..< self.tutorialViews.count  {
              if index == self.tutorialPageNumber {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialNextButton)
                self.tutorialViews[index].userInteractionEnabled = false
              }
              else {
                self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialView)
                self.tutorialViews[index].userInteractionEnabled = true
              }
            }
            if self.tutorialViews[self.tutorialPageNumber] == self.settingsButton {
              self.tutorialNextButton.setTitle("Continue To Settings", forState: UIControlState.Normal)
              self.displayFinger(true)
              UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tutorialFingerImageView.alpha = 1
                }, completion: nil)
            }
          }
          if self.tutorialPageNumber != self.tutorialViews.count {
            self.updateDescriptionLabelView()
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
              self.descriptionLabelView.alpha = 1
              }, completion: nil)
          }
          
      })

//      else if self.tutorialViews[self.tutorialPageNumber] == self.statsButton {
//        self.tutorialNextButton.setTitle("End Walkthrough", forState: UIControlState.Normal)
//      }
    
  }
  
  func updateDescriptionLabelView () {
    
    // Create and add constraints for descriptionLabelView
    
    self.descriptionLabelView.titleLabel.text = self.tutorialDescriptions[self.tutorialViews[self.tutorialPageNumber]]![0]
    self.descriptionLabelView.descriptionLabel.text = self.tutorialDescriptions[self.tutorialViews[self.tutorialPageNumber]]![1]
    //self.descriptionLabelView.alpha = 0
    self.view.addSubview(self.descriptionLabelView)
    
    descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
    
    if self.tutorialViews[self.tutorialPageNumber] == self.membershipButton {
        self.displayFinger(false)
        self.tutorialFingerImageView.alpha = 1.0
        self.membershipButton.alpha = 1.0
        self.tutorialNextButton.setTitle("End Walkthrough", forState: UIControlState.Normal)
        
        self.descriptionLabelView.setConstraintsToSuperview(75, bottom: 150, left: Int(2*self.majorMargin), right: Int(2*self.majorMargin))
        
    } else {
    
    let descriptionLabelViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    if self.tutorialViews[self.tutorialPageNumber].frame.maxY < (self.screenFrame.height) {
      let descriptionLabelViewTopConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
      self.view.addConstraint(descriptionLabelViewTopConstraint)
    }
    else {
      let descriptionLabelViewBottomConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -20)
      self.view.addConstraint(descriptionLabelViewBottomConstraint)
    }
    
    let descriptionLabelViewHeightConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.descriptionLabelView.heightForView(self.descriptionLabelView.descriptionLabel.text!, font: self.descriptionLabelView.descriptionLabel.font, width: self.screenFrame.width - (self.majorMargin * 2)) + 60)
    
    let descriptionLabelViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2))
    
    self.descriptionLabelView.addConstraints([descriptionLabelViewHeightConstraint, descriptionLabelViewWidthConstraint])
    self.view.addConstraints([descriptionLabelViewCenterXConstraint])
    
    }
    
  }
  
  func displayFinger(pointingLeft:Bool) {
    
    self.tutorialFingerImageView.contentMode = UIViewContentMode.ScaleAspectFit
    //self.tutorialFingerImageView.alpha = 0
    self.view.addSubview(self.tutorialFingerImageView)
    
    tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialFingerImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    if pointingLeft {
      self.tutorialFingerImageView.image = UIImage.init(named: "fingerSideways")
      let tutorialFingerImageViewLeftConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
      self.view.addConstraint(tutorialFingerImageViewLeftConstraint)
    }
    else {
      let image:UIImage = UIImage.init(named: "fingerSideways")!
      self.tutorialFingerImageView.image = UIImage.init(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
      let tutorialFingerImageViewRightConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutorialViews[self.tutorialPageNumber], attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      self.view.addConstraint(tutorialFingerImageViewRightConstraint)
    }
    
    let tutorialFingerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let tutorialFingerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/6)
    
    self.tutorialFingerImageView.addConstraints([tutorialFingerImageViewHeightConstraint, tutorialFingerImageViewWidthConstraint])
    self.view.addConstraints([tutorialFingerImageViewTopConstraint])
  
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
    
    func isBrainBreakerDone() {
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        
        self.logOutButton.alpha = 0.0
        self.bannerView.alpha = 1.0
        self.careersBackgroundView.bringSubviewToFront(self.bannerView)
        
    }
    
    func count(){
        
        self.membershipCounter = self.defaults.objectForKey("MembershipCounter") as? Int ?? Int()
        
        print(membershipCounter)
        
        if self.membershipCounter < 10 {
            
            self.membershipCounter += 1
            self.defaults.setInteger(membershipCounter, forKey: "MembershipCounter")
            
        }else{
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))!,
                kTextFont: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(14))!,
                kButtonFont: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(14))!,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("Yes") {
                SwiftSpinner.show("Purchasing")
                self.unlimitedLivesTapped()
            }
            alertView.addButton("Close") {
            }
            
            alertView.showSuccess("Message", subTitle: "Premium subscription provides unlimited tests, 3 attempts at the Brainbreaker and removes all ads! \n\n Would you like to upgrade?")
            
            self.membershipCounter = 0
            self.defaults.setInteger(membershipCounter, forKey: "MembershipCounter")
        }
        
    }
    
    func premiumMembership(){
        
        SwiftSpinner.show("Purchasing")
        
        if let currentUser = PFUser.currentUser(){
            currentUser[PF_USER_MEMBERSHIP] = "Premium"
            //set other fields the same way....
            currentUser.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    
                    self.defaults.setObject("Premium", forKey: "Membership")
                    let membershipType = self.defaults.objectForKey("Membership") as! String
                    self.defaults.setInteger(3, forKey: "NoOfBrainBreakerLives")
                    print(membershipType)
                    
                    SwiftSpinner.show("You Are Now a Premium User", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                        }, subtitle: "This means you can practice an unlimited number of tests! You also have 3 attempts at each Brain Breaker question, beginning from the next one!")
                    
                } else {
                    
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Payment error, tap to return home")
                    
                }
                
            })
        }
        
    }
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "com.APPSIDE.Breakin2.ExtraLives1", "com.APPSIDE.Breakin2.UnlimitedLives1")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            print(productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        //print(myProduct)
        
        for product in myProduct {
            list.append(product)
        }
        
    }
    
    func unlimitedLivesTapped(){
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.APPSIDE.Breakin2.UnlimitedLives1") {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    
    func buyProduct(){
        
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
        
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                //print("buy, ok unlock iap here")
                //print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.APPSIDE.Breakin2.ExtraLives1":
                    break
                    //print("extra lives bought")
                case "com.APPSIDE.Breakin2.UnlimitedLives1":
                    //print("unlimited lives bought")
                    premiumMembership()
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                print("buy error")
                
                SwiftSpinner.show("Purchase Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    
                    }, subtitle: "Tap to return home")
                
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction)
    {
        print("finish transaction")
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
        print("remove trans");
    }

    
}