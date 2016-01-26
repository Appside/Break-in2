//
//  ViewController.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 11/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit
import SwiftSpinner
import SCLAlertView

class TestSelectionViewController: UIViewController, UIScrollViewDelegate {
  
  // Timer stuff
  let defaults = NSUserDefaults.standardUserDefaults()
  var timer = NSTimer()
  var numberOfTestsTotal:Int = Int()
  var membershipType:String = String()
  var maxNumberOfTests:Int = 3
  var count:Int = 24
  var startTime:CFAbsoluteTime = CFAbsoluteTime()
  var counter:Int = Int()
  var minutesRemaining:Int = Int()
  var secondsRemaining:Int = Int()
  var minutesBetweenLives:Int = 1
  var secondsBetweenLives:Int = 60
  var countSeconds:Int = Int()
  var countMinutes:Int = Int()
    
  
  // Declare and initialize types of tests and difficulties available for selected career
  
  var testTypes:[String] = [String]()
  let testTypeBackgroundImages:[String:String] = ["Numerical Reasoning":"numericalBG", "Verbal Reasoning":"verbalBG", "Logical Reasoning":"logicalBG", "Arithmetic Reasoning":"arithmeticBG","Sequences":"arithmeticBG","Fractions":"arithmeticBG"]
  let testTypeSegues:[String:String] = ["Numerical Reasoning":"numericalReasoningSelected","Verbal Reasoning":"verbalReasoningSelected","Logical Reasoning":"logicalReasoningSelected","Arithmetic Reasoning":"arithmeticReasoningSelected","Sequences":"sequencesSelected","Fractions":"fractionsSelected"]
  let testDifficulties:[String] = ["E", "M", "H"]
  
  // Declare and intialize views
  
  var backgroundImageView:UIImageView = UIImageView()
  var backgroundImageView2:UIImageView = UIImageView()
  let logoImageView:UIImageView = UIImageView()
  let testSelectionView:UIView = UIView()
  var testPageControllerView:PageControllerView = PageControllerView()
  let testScrollView:UIScrollView = UIScrollView()
  var testTypeViews:[TestTypeView] = [TestTypeView]()
  let testStartButton:UIButton = UIButton(type: UIButtonType.System)
  var backButton:UIButton = UIButton()
  let swipeInfoLabel:UILabel = UILabel()
  var testsTotal:UIButton = UIButton()
  let testLivesBackgroundView:UIView = UIView()
  let testLivesTitleLabel:UILabel = UILabel()
  let testLivesSubtitleLabel:UILabel = UILabel()
  let testLivesUpgradeButton1:UIButton = UIButton()
  let testLivesUpgradeButton2:UIButton = UIButton()
  let testLivesInfoLabel:UILabel = UILabel()
  
  // Declare and initialize constraints that will be animated
  
  var testSelectionViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var testSelectionViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize tracking variables
  
  var testSelectionViewVisible:Bool = false
  var testLivesBackgroudViewVisible = false
  var currentScrollViewPage:Int = 0
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let mainLineColor:UIColor = UIColor.turquoiseColor()
  let mainBackgroundColor:UIColor = UIColor.whiteColor()
  let secondaryBackgroundColor:UIColor = UIColor.turquoiseColor()
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let testPageControllerViewHeight:CGFloat = 50
  let testTypeTitleLabelHeight:CGFloat = 30
  let testTypeTimeLabelHeight:CGFloat = 20
  let testTypeDifficultyViewHeight:CGFloat = 50
  
  let menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  
  var statsViewVisible:Bool = false
  var firstTimeUser:Bool = false

  // Declare and initialize gestures
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set background images
    
    self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[0]]!)
    self.backgroundImageView.alpha = 0
    
    self.backgroundImageView2.image = UIImage.init(named: "homeBG")
    self.backgroundImageView2.alpha = 1
    
    // Add testSelectionView and backButton to the main view
    
    self.view.addSubview(self.backgroundImageView)
    self.view.addSubview(self.backgroundImageView2)
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.testSelectionView)
    self.view.addSubview(self.backButton)
    self.view.addSubview(self.testsTotal)
    self.view.addSubview(self.testLivesBackgroundView)
    
    // Add testSelectionView subviews
    
    self.testSelectionView.addSubview(self.testPageControllerView)
    self.testSelectionView.addSubview(self.testScrollView)
    self.testSelectionView.addSubview(self.testStartButton)
    self.testSelectionView.addSubview(self.swipeInfoLabel)
    
    // Add testLivesBackgroundView subviews
    
    self.testLivesBackgroundView.addSubview(self.testLivesTitleLabel)
    self.testLivesBackgroundView.addSubview(self.testLivesSubtitleLabel)
    self.testLivesBackgroundView.addSubview(self.testLivesInfoLabel)
    self.testLivesBackgroundView.addSubview(self.testLivesUpgradeButton1)
    self.testLivesBackgroundView.addSubview(self.testLivesUpgradeButton2)
    
    // Create testTypeViews for each testType
    
    let testTypeDifficultyButtonHeight:CGFloat = self.testTypeDifficultyViewHeight - (2 * self.minorMargin)
    
    for var index:Int = 0 ; index < self.testTypes.count ; index++ {
      
      // Create each testTypeView
      
      let testTypeViewAtIndex:TestTypeView = TestTypeView()
      
      // Set testTypeView properties
      
      testTypeViewAtIndex.testType = self.testTypes[index]
      testTypeViewAtIndex.testDifficulties = self.testDifficulties
      
      testTypeViewAtIndex.majorMargin = self.majorMargin
      testTypeViewAtIndex.minorMargin = self.minorMargin
      testTypeViewAtIndex.mainLineColor = self.mainLineColor
      testTypeViewAtIndex.mainBackgroundColor = self.mainBackgroundColor
      testTypeViewAtIndex.secondaryBackgroundColor = self.secondaryBackgroundColor
      
      testTypeViewAtIndex.testTypeTitleLabelHeight = self.testTypeTitleLabelHeight
      testTypeViewAtIndex.testTypeTimeLabelHeight = self.testTypeTimeLabelHeight
      testTypeViewAtIndex.testTypeDifficultyViewHeight = self.testTypeDifficultyViewHeight
      testTypeViewAtIndex.testTypeDifficultyButtonHeight = testTypeDifficultyButtonHeight
      testTypeViewAtIndex.testTypeStatsViewHeightAfterSwipe = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + self.majorMargin + self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 5))
      
      testTypeViewAtIndex.clipsToBounds = true
      
      // Add each testTypeView to testScrollView
      
      self.testScrollView.addSubview(testTypeViewAtIndex)
      
      // Store each testTypeView into the testTypeViews array
      
      self.testTypeViews.append(testTypeViewAtIndex)
      
    }
    
    // Customize testPageControllerView
    
    self.testPageControllerView.numberOfPages = self.testTypes.count
    self.testPageControllerView.minorMargin = self.minorMargin
    //self.testPageControllerView.layer.borderWidth = 2
    //self.testPageControllerView.layer.borderColor = UIColor.blackColor().CGColor
    
    // Set constraints
    
    self.setConstraints()
    
    // Adjust testScrollView characteristics
    
    self.testScrollView.pagingEnabled = true
    self.testScrollView.showsHorizontalScrollIndicator = false
    
    self.testScrollView.delegate = self
    
    // Adjust main view appearance
    
    self.view.backgroundColor = self.secondaryBackgroundColor
    
    // Adjust testSelectioView apperance and testLivesBackgroundView
    
    self.testSelectionView.backgroundColor = self.mainBackgroundColor
    self.testSelectionView.layer.cornerRadius = self.minorMargin
    self.testSelectionView.alpha = 0
    
    self.testLivesBackgroundView.backgroundColor = UIColor.whiteColor()
    self.testLivesBackgroundView.layer.cornerRadius = self.minorMargin
    self.testLivesBackgroundView.clipsToBounds = true
    self.testLivesBackgroundView.alpha = 0
    
    // Adjust testStartButton, backButton and testLivesUpgradeButtons appearances
    
    self.testStartButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.testStartButton.setTitle("Start Test", forState: UIControlState.Normal)
    self.testStartButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testStartButton.backgroundColor = UIColor.turquoiseColor()
    self.testStartButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    self.testLivesUpgradeButton1.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.testLivesUpgradeButton1.setTitle("£0.50 / 5 Tests", forState: UIControlState.Normal)
    self.testLivesUpgradeButton1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testLivesUpgradeButton1.backgroundColor = UIColor.turquoiseColor()
    self.testLivesUpgradeButton1.addTarget(self, action: "addLives:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.testLivesUpgradeButton2.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.testLivesUpgradeButton2.setTitle("£2.50 / Unlimited", forState: UIControlState.Normal)
    self.testLivesUpgradeButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testLivesUpgradeButton2.backgroundColor = UIColor.turquoiseColor()
    self.testLivesUpgradeButton2.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    membershipType = defaults.objectForKey("Membership") as! String
    
    if (membershipType == "Paid") {
        
        //placeholder for freemium
    
    }else{
        
        freeConduit()
        let date = NSDate().dateByAddingTimeInterval(0)
        let timer = NSTimer(fireDate: date, interval: 1, target: self, selector: "freeConduit", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    // Adjust swipeInfoLabel, testLivesTitleLabel and testLivesSubtitleLabel appearance
    
    self.swipeInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.swipeInfoLabel.textAlignment = NSTextAlignment.Center
    self.swipeInfoLabel.textColor = UIColor.lightGrayColor()
    self.swipeInfoLabel.text = "Swipe For More Tests"
    
    self.testLivesTitleLabel.textAlignment = NSTextAlignment.Center
    self.testLivesTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
    self.testLivesTitleLabel.text = "TIME TO NEXT LIFE:"
    
    self.testLivesSubtitleLabel.backgroundColor = UIColor.turquoiseColor()
    self.testLivesSubtitleLabel.textAlignment = NSTextAlignment.Center
    self.testLivesSubtitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
    self.testLivesSubtitleLabel.textColor = UIColor.whiteColor()
    
    self.testLivesInfoLabel.textAlignment = NSTextAlignment.Center
    self.testLivesInfoLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
    
    // Display each testTypeView
    
    for testTypeViewAtIndex in self.testTypeViews {
      
      testTypeViewAtIndex.displayView()
      
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // Show Test Selection screen with animation
    
    self.showTestSelectionView()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    func freeConduit(){
        
        self.numberOfTestsTotal = defaults.integerForKey("Lives")
        
        self.testsTotal.addTarget(self, action: "showTestLives:", forControlEvents: UIControlEvents.TouchUpInside)
        self.testsTotal.setTitle(String(self.numberOfTestsTotal), forState: UIControlState.Normal)
        self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) lives left."
        self.testsTotal.clipsToBounds = true
        self.testsTotal.layer.cornerRadius = self.screenFrame.width/24
        self.testsTotal.layer.borderWidth = 2
        self.testsTotal.layer.borderColor = UIColor.whiteColor().CGColor
        
        if (self.numberOfTestsTotal < self.maxNumberOfTests) {
            
//            let date = NSDate().dateByAddingTimeInterval(0)
//            let timer = NSTimer(fireDate: date, interval: 1, target: self, selector: "checkLives", userInfo: nil, repeats: true)
//            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            self.checkLives()
            
        }else{
            
            //timer.invalidate()
            self.testLivesSubtitleLabel.text = "MAXIMUM AMOUNT OF LIVES"
            
        }
        
//        self.testsTotal.addTarget(self, action: "showTestLives:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.testsTotal.setTitle(String(numberOfTestsTotal), forState: UIControlState.Normal)
//        self.testsTotal.clipsToBounds = true
//        self.testsTotal.layer.cornerRadius = self.screenFrame.width/24
//        self.testsTotal.layer.borderWidth = 2
//        self.testsTotal.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    func checkLives(){
        
        startTime = CFAbsoluteTimeGetCurrent()
        let initialTime: CFAbsoluteTime = defaults.objectForKey("LivesTimer") as! CFAbsoluteTime
        let diff = startTime - initialTime
        let timeBetweenLives = Double((60 * minutesBetweenLives) + secondsBetweenLives)
        var numberToAdd = floor(diff / timeBetweenLives)
        let newLives:Int = Int(numberToAdd) + numberOfTestsTotal
        
        minutesRemaining = max(minutesBetweenLives - Int(floor(diff / 60)), 0)
        secondsRemaining = max(secondsBetweenLives - Int(diff)%60, 0)
        
        //self.updateTimer()
        
        if numberToAdd > 0 && self.numberOfTestsTotal < self.maxNumberOfTests {
            
            self.numberOfTestsTotal = min(newLives, 3)
            self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
            self.testsTotal.setTitle(String(self.numberOfTestsTotal), forState: UIControlState.Normal)
            self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) lives left."
            numberToAdd = 0
            let now:CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
            self.defaults.setObject(now, forKey: "LivesTimer")
            
            if self.numberOfTestsTotal == self.maxNumberOfTests {
                
                timer.invalidate()
                self.testLivesSubtitleLabel.text = "MAXIMUM AMOUNT OF LIVES"
                
            }

            //freeConduit()
            //updateTimer()
            
        } else if self.numberOfTestsTotal == self.maxNumberOfTests {
            
            timer.invalidate()
            self.testLivesSubtitleLabel.text = "MAXIMUM AMOUNT OF LIVES"
            
        }else{
        
            self.updateTimer()
            
        }
        
        //freeConduit()
        
    }
  
  func setConstraints() {
    
    // Create and add constraints for backgroundImageViews
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    self.backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
    self.backgroundImageView2.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for testSelectionView
    
    self.testSelectionView.translatesAutoresizingMaskIntoConstraints = false
    
    self.testSelectionViewBottomConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: /*self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 7)*/ self.minorMargin)
    
    let testSelectionViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testSelectionViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.testSelectionViewHeightConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 7))
    
    self.testSelectionView.addConstraint(self.testSelectionViewHeightConstraint)
    self.view.addConstraints([self.testSelectionViewBottomConstraint, testSelectionViewLeftConstraint, testSelectionViewRightConstraint])
    
    // Create and add constraints for swipeInfoLabel
    
    self.swipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let swipeInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let swipeInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let swipeInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let swipeInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight * 0.5)
    
    self.swipeInfoLabel.addConstraint(swipeInfoLabelHeightConstraint)
    self.view.addConstraints([swipeInfoLabelTopConstraint, swipeInfoLabelLeftConstraint, swipeInfoLabelRightConstraint])
    
    // Create and add constraints for testPageControllerView
    
    self.testPageControllerView.translatesAutoresizingMaskIntoConstraints = false
    
    let testPageControllerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testPageControllerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testPageControllerViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testPageControllerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testPageControllerViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testPageControllerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testPageControllerViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testPageControllerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testPageControllerViewHeight)
    
    self.testPageControllerView.addConstraint(testPageControllerViewHeightConstraint)
    self.view.addConstraints([testPageControllerViewTopConstraint, testPageControllerViewLeftConstraint, testPageControllerViewRightConstraint])
    
    // Create and add constraints for testScrollView
    
    self.testScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let testScrollViewTopConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testPageControllerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testScrollViewLeftConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testScrollViewRightConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.majorMargin * -1)
    
    self.view.addConstraints([testScrollViewTopConstraint, testScrollViewLeftConstraint, testScrollViewRightConstraint, testScrollViewBottomConstraint])
    
    // Create and add constraints for each testTypeView and set content size for testScrollView
    
    for var index:Int = 0 ; index < self.testTypes.count ; index++ {
      
      self.testTypeViews[index].translatesAutoresizingMaskIntoConstraints = false
      
      let testTypeViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let testTypeViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
      
      let testTypeViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * self.majorMargin))
      
      if index == 0 {
        
        let testTypeViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeViewLeftConstraint)
        
      }
      else {
        
        let testTypeViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeViews[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeViewLeftConstraint)
        
      }
      
      self.testTypeViews[index].addConstraint(testTypeViewWidthConstraint)
      self.view.addConstraints([testTypeViewTopConstraint,testTypeViewBottomConstraint])
      
      if index == self.testTypes.count - 1 {
        
        let testScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testScrollViewRightConstraint)
        
      }
      
    }
    
    // Create and add constraints for testStartButton
    
    self.testStartButton.translatesAutoresizingMaskIntoConstraints = false
    
    let testStartButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    let testStartButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testStartButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testStartButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    self.testStartButton.addConstraint(testStartButtonHeightConstraint)
    self.view.addConstraints([testStartButtonLeftConstraint, testStartButtonRightConstraint, testStartButtonBottomConstraint])
    
    // Create and add constraints for backButton
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
    // Create and add constraints for number of tests available
    
    self.testsTotal.translatesAutoresizingMaskIntoConstraints = false
    
    let testsTotalRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testsTotal, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let testsTotalTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testsTotal, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let testsTotalHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testsTotal, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let testsTotalWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testsTotal, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.testsTotal.addConstraints([testsTotalHeightConstraint, testsTotalWidthConstraint])
    self.view.addConstraints([testsTotalRightConstraint, testsTotalTopConstraint])
    
    // Create and add constraints for testLivesBackgroundView
    
    self.testLivesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let testLivesBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testLivesBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let testLivesBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))
    
    self.testLivesBackgroundView.addConstraint(testLivesBackgroundViewHeightConstraint)
    self.view.addConstraints([testLivesBackgroundViewTopConstraint, testLivesBackgroundViewLeftConstraint, testLivesBackgroundViewRightConstraint])
    
    // Create and add constraints for testLivesTitleLabel
    
    self.testLivesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesTitleLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let testLivesTitleLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesTitleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesBackgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let testLivesTitleLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ((self.screenFrame.width - (self.majorMargin * 2)) * 8)/10)
    
    let testLivesTitleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesTitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ((self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 9) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight)) * 2)/9)
    
    self.testLivesTitleLabel.addConstraints([testLivesTitleLabelWidthConstraint, testLivesTitleLabelHeightConstraint])
    self.testLivesBackgroundView.addConstraints([testLivesTitleLabelTopConstraint, testLivesTitleLabelCenterXConstraint])
    
    // Create and add constraints for testLivesSubtitleLabel
    
    self.testLivesSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesSubtitleLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesSubtitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesTitleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testLivesSubtitleLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesSubtitleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesTitleLabel, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let testLivesSubtitleLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesSubtitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2) - (self.minorMargin * 2))
    
    let testLivesSubtitleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesSubtitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 9) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))/9)
    
    self.testLivesSubtitleLabel.addConstraints([testLivesSubtitleLabelWidthConstraint, testLivesSubtitleLabelHeightConstraint])
    self.testLivesBackgroundView.addConstraints([testLivesSubtitleLabelTopConstraint, testLivesSubtitleLabelCenterXConstraint])
    
    // Create and add constraints for testLivesUpgradeButton1
    
    self.testLivesUpgradeButton1.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesUpgradeButton1LeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin + self.majorMargin)
    
    let testLivesUpgradeButton1BottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let testLivesUpgradeButton1RightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton1, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: self.minorMargin * -0.5)
    
    let testLivesUpgradeButton1HeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.testLivesUpgradeButton1.addConstraint(testLivesUpgradeButton1HeightConstraint)
    self.view.addConstraints([testLivesUpgradeButton1LeftConstraint, testLivesUpgradeButton1BottomConstraint, testLivesUpgradeButton1RightConstraint])
    
    // Create and add constraints for testLivesUpgradeButton2
    
    self.testLivesUpgradeButton2.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesUpgradeButton2RightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: (self.minorMargin + self.majorMargin) * -1)
    
    let testLivesUpgradeButton2BottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton2, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let testLivesUpgradeButton2LeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: self.minorMargin * 0.5)
    
    let testLivesUpgradeButton2HeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesUpgradeButton2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.testLivesUpgradeButton2.addConstraint(testLivesUpgradeButton2HeightConstraint)
    self.view.addConstraints([testLivesUpgradeButton2LeftConstraint, testLivesUpgradeButton2BottomConstraint, testLivesUpgradeButton2RightConstraint])
    
    // Create and add constraints for testLivesInfoLabel
    
    self.testLivesInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testLivesInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesSubtitleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    let testLivesInfoLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesInfoLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesBackgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let testLivesInfoLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesInfoLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2) - (self.minorMargin * 2))
    
    let testLivesInfoLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesInfoLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testLivesUpgradeButton1, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    self.testLivesInfoLabel.addConstraint(testLivesInfoLabelWidthConstraint)
    self.testLivesBackgroundView.addConstraints([testLivesInfoLabelTopConstraint, testLivesInfoLabelCenterXConstraint, testLivesInfoLabelBottomConstraint])
    
  }
  
  func showTestSelectionView() {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if !self.testSelectionViewVisible {
        
        self.backgroundImageView.alpha = 1
        self.backgroundImageView2.alpha = 0
        self.backButton.alpha = 1
        self.testSelectionView.alpha = 1
        self.testsTotal.alpha = 1
        //self.testSelectionViewBottomConstraint.constant = self.minorMargin
        self.view.layoutIfNeeded()
        
        self.testSelectionViewVisible = true
        
      }
      
      }, completion: nil)
    
  }
  
  func hideTestSelectionView(sender:UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if self.testSelectionViewVisible {
        
        self.backgroundImageView2.image = UIImage.init(named: "homeBG")
        self.backgroundImageView2.alpha = 1
        self.backgroundImageView.alpha = 0
        self.testSelectionView.alpha = 0
        //self.testSelectionViewBottomConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 7)
        self.backButton.alpha = 0
        self.view.layoutIfNeeded()
        
        self.testSelectionViewVisible = false
        
      }
      
      }, completion: {(Bool) in
        
        if sender == self.backButton {
          self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
        }
        else if sender == self.testStartButton {
            
            if (self.numberOfTestsTotal == 3) {
        
                let now:CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
                self.defaults.setObject(now, forKey: "LivesTimer")
                self.numberOfTestsTotal--
                self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
                self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: sender)
                
            }else if (self.numberOfTestsTotal > 0 && self.numberOfTestsTotal != 3) {
            
                self.numberOfTestsTotal--
                self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
                self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: sender)
                
            }else{
                
                let backAlert = SCLAlertView()
                backAlert.showCloseButton = false
                backAlert.addButton("5 Lives / £0.50", target:self, selector: "extraLives2:")
                //backAlert.addButton("£2.50 / Unlimited", target:self, selector:Selector(""))
                backAlert.addButton("Wait", action: ({
                    
                    self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                    
                }))
                backAlert.showSuccess("OUT OF LIVES", subTitle: "You can purchase some now.")
                
            }
        
        }
        
    })
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "backFromTestSelection" {
      let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
      destinationVC.segueFromLoginView = false
    }
    else {
      let destinationVC:QuestionViewController = segue.destinationViewController as! QuestionViewController
      let currentTestTypeView:TestTypeView = self.testTypeViews[self.currentScrollViewPage]
      destinationVC.difficulty = currentTestTypeView.difficultySelected
    }
  }
  
  func showStats(sender: UISwipeGestureRecognizer) {
    
    if !self.statsViewVisible {
      
      UIView.animateWithDuration(1, animations: {
        
        self.testSelectionViewHeightConstraint.constant = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + self.majorMargin)
        self.view.layoutIfNeeded()
        
        }, completion: {(Bool) in
          
          self.swipeInfoLabel.text = "Swipe Down To Close"
          
      })

      self.statsViewVisible = true
      
    }
    
  }
  
  func hideStats(sender: UISwipeGestureRecognizer) {
    
    if self.statsViewVisible {
      
      UIView.animateWithDuration(1, animations: {
        
        self.testSelectionViewHeightConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 7)
        self.view.layoutIfNeeded()
        
        }, completion: {(Bool) in
          
          self.swipeInfoLabel.text = "Swipe Up For Test Explanation"
          
      })
      
      self.statsViewVisible = false
      
    }
    
  }
  
  /*func scrollViewDidScroll(scrollView: UIScrollView) {
  self.backgroundImageView.alpha = 1 - (((self.testScrollView.contentOffset.x/self.testScrollView.frame.size.width) - CGFloat(Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width))) * 2)
  }
  
  func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
  
  let scrollViewPosition:CGFloat = ((self.testScrollView.contentOffset.x/self.testScrollView.frame.size.width) - CGFloat(Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width)))
  
  if scrollViewPosition < 0.5 {
  let pageIndex:Int = Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width)
  self.testPageControllerView.updatePageController(pageIndex)
  self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[pageIndex]]!)
  }
  else {
  let pageIndex:Int = Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width) + 1
  self.testPageControllerView.updatePageController(pageIndex)
  self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[pageIndex]]!)
  }
  
  UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
  self.backgroundImageView.alpha = 1
  }, completion: nil)
  }*/
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    self.currentScrollViewPage = Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width)
    self.testPageControllerView.updatePageController(self.currentScrollViewPage)
    self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[self.currentScrollViewPage]]!)
    self.backgroundImageView.alpha = 1
    self.backgroundImageView2.alpha = 0
    
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    if self.testScrollView.contentOffset.x > (self.testScrollView.frame.size.width * CGFloat(self.currentScrollViewPage)) {
      
      if self.currentScrollViewPage != self.testTypes.count - 1 {
        
        self.backgroundImageView2.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[self.currentScrollViewPage + 1]]!)
        self.backgroundImageView.alpha = 1 - ((self.testScrollView.contentOffset.x - (self.testScrollView.frame.width * CGFloat(self.currentScrollViewPage))) / self.testScrollView.frame.size.width)
        self.backgroundImageView2.alpha = (self.testScrollView.contentOffset.x - (self.testScrollView.frame.width * CGFloat(self.currentScrollViewPage))) / self.testScrollView.frame.size.width
        
      }
      
      
    }
    else if self.testScrollView.contentOffset.x < (self.testScrollView.frame.size.width * CGFloat(self.currentScrollViewPage)) {
      
      if self.currentScrollViewPage != 0 {
        
        self.backgroundImageView2.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[self.currentScrollViewPage - 1]]!)
        self.backgroundImageView.alpha = (self.testScrollView.contentOffset.x - (self.testScrollView.frame.width * CGFloat(self.currentScrollViewPage - 1))) / self.testScrollView.frame.size.width
        self.backgroundImageView2.alpha = 1 - ((self.testScrollView.contentOffset.x - (self.testScrollView.frame.width * CGFloat(self.currentScrollViewPage - 1))) / self.testScrollView.frame.size.width)
        
      }
      
      
    }
    
  }
  
  func showTestLives(sender:UIButton) {
    
    numberOfTestsTotal = defaults.integerForKey("Lives")
    self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) lives left."
    
//    if (numberOfTestsTotal < maxNumberOfTests) {
//        
//        //let date = NSDate().dateByAddingTimeInterval(0)
//        //let timer = NSTimer(fireDate: date, interval: 1, target: self, selector: "checkLives", userInfo: nil, repeats: true)
//        //NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
//        //self.testLivesSubtitleLabel.text = String(format: "%02d", self.minutesRemaining) + " : " + String(format: "%02d", self.secondsRemaining)
//        //self.checkLives()
//        
//    }else{
//        
//    }
    
    UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if self.testLivesBackgroudViewVisible == false {
        self.testLivesBackgroundView.alpha = 1
        self.testLivesBackgroudViewVisible = true
        
      }
      else {
        self.testLivesBackgroundView.alpha = 0
        self.testLivesBackgroudViewVisible = false
      }
      self.view.layoutIfNeeded()
      
    }, completion: nil)
    
  }
    
    func updateTimer() {
        
        if self.testLivesSubtitleLabel.text == "MAXIMUM AMOUNT OF LIVES" {
            
        }else{
            if (self.secondsRemaining-1<0) {
                if (self.minutesRemaining+self.secondsRemaining==0) {
                    self.timer.invalidate()
                }
                else {
                    self.minutesRemaining--
                    self.secondsRemaining = 59
                }
            }
            else {
                self.secondsRemaining--
            }
            let newMin:String = String(format: "%02d", self.minutesRemaining)
            let newSec:String = String(format: "%02d", self.secondsRemaining)
            let newLabel:String = "\(newMin) : \(newSec)"
            self.testLivesSubtitleLabel.text = newLabel
            if (self.minutesRemaining==0 && self.secondsRemaining==0) {
                self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) lives left."
            }
    }
    }
    
    func addLives(sender: UIButton){
        
        let backAlert = SCLAlertView()
        backAlert.addButton("Yes", target:self, selector:Selector("extraLives"))
        backAlert.showTitle(
            "Are you sure?", // Title of view
            subTitle: "Purchasing an extra 5 lives will cost you £0.50", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "No", // Optional button value, default: ""
            style: .Success, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0x22B573,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        backAlert.showCloseButton = false
        
    }
    
    func extraLives(){
        
        self.numberOfTestsTotal = self.numberOfTestsTotal + 5
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        
    }
    
    func extraLives2(sender: UIButton){
        
        self.numberOfTestsTotal = self.numberOfTestsTotal + 5
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        self.numberOfTestsTotal--
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: sender)
        
    }
    
    func premiumMembership(){
        
    }
  
}

