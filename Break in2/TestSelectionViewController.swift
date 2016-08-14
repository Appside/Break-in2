//
//  ViewController.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 11/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

/*
DIRECTORY:

NUMBER 1: CHECKING MEMBERSHIP (CRAWFORD)
NUMBER 2: PAID MEMBERSHIP (CRAWFORD)
NUMBER 3: FREE MEMBERSHIP (CRAWFORD)
*/

import UIKit
import SwiftSpinner
import SCLAlertView
import Parse

class TestSelectionViewController: UIViewController, UIScrollViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  // Timer stuff
  let defaults = NSUserDefaults.standardUserDefaults()
  var timer = NSTimer()
  var numberOfTestsTotal:Int = Int()
  var membershipType:String = String()
  var maxNumberOfTests:Int = 3
  var count:Int = 24
  var startTime:CFAbsoluteTime = CFAbsoluteTime()
  var counter:Int = Int()
  var secondsRemaining:Int = Int()
  var secondsBetweenLives:Int = 24 * 3600
  var lifeOrLives:String = String()
    var noAddtlLives:Int = 5
    
  //in app purchase initialisation
    
  let productIdentifiers = Set(["com.APPSIDE.Breakin2.ExtraLives1", "com.APPSIDE.Breakin2.UnlimitedLives1"])
  var product: SKProduct?
  var productsArray = Array<SKProduct>()
  var list = [SKProduct]()
  var p = SKProduct()
  
  // Declare and initialize types of tests and difficulties available for selected career
    
  var testTypes:[String] = [String]()
  var comingSoonTestTypes:[String] = [String]()
  let testTypeBackgroundImages:[String:String] = ["Numerical Reasoning":"numericalBG", "Verbal Reasoning":"verbalBG", "Logical Reasoning":"logicalBG", "Arithmetic Reasoning":"arithmeticBG", "Sequences":"numbersBG", "Fractions":"numericalBG", "Programming":"blurredBlue", "Technology":"blurredGreen","Help Us Add More Tests:":"blurredRed"]
  let testTypeSegues:[String:String] = ["Numerical Reasoning":"numericalReasoningSelected","Verbal Reasoning":"verbalReasoningSelected","Logical Reasoning":"logicalReasoningSelected","Arithmetic Reasoning":"arithmeticReasoningSelected","Sequences":"sequencesSelected","Fractions":"fractionsSelected","Programming":"programmingSelected","Technology":"technologySelected"]
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
  
  let testPageControllerViewHeight:CGFloat = UIScreen.mainScreen().bounds.height/16
  
  var menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  var testSelectionBackgroundViewHeight:CGFloat = 300
  var textSize:CGFloat = 15

  var statsViewVisible:Bool = false
  var firstTimeUser:Bool = false
  var selectedCareer:String = String()

  // Declare and initialize gestures
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    requestProductData()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set background images
    
    self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[0]]!)
    self.backgroundImageView.alpha = 0
    
    self.backgroundImageView2.image = UIImage.init(named: "homeBG")
    self.backgroundImageView2.alpha = 1
    
    self.textSize = self.view.getTextSize(15)
    
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
    
    // Set menuButtonHeight, backButtonHeight and calendarBackgroundViewHeight
    
    if self.screenFrame.height <= 738 {
      self.testSelectionBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 4)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.testSelectionBackgroundViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 6) + 25))/4
      
    }
    else {
      self.testSelectionBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 14)
      
      let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.testSelectionBackgroundViewHeight + self.minorMargin)
      self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 7) + 25))/5
    }
        
    // Create testTypeViews for each testType
    
    for var index:Int = 0 ; index < self.testTypes.count ; index++ {
      
      // Create each testTypeView
      
      let testTypeViewAtIndex:TestTypeView = TestTypeView()
      
      // Set testTypeView properties
      
      testTypeViewAtIndex.testType = self.testTypes[index]
      
      if self.testTypes[index] == "Help Us Add More Tests:" {
        var testDifficultiesArray:[String] = [String]()
        for comingSoonTestType in self.comingSoonTestTypes {
          let firstChar:String = String(comingSoonTestType[comingSoonTestType.startIndex.advancedBy(0)])
          testDifficultiesArray.append(firstChar)
        }
        testTypeViewAtIndex.testDifficulties = testDifficultiesArray
        testTypeViewAtIndex.comingSoonTestTypes = self.comingSoonTestTypes
      }
      else {
        testTypeViewAtIndex.testDifficulties = self.testDifficulties
      }
      
      testTypeViewAtIndex.majorMargin = self.majorMargin
      testTypeViewAtIndex.minorMargin = self.minorMargin
      testTypeViewAtIndex.mainLineColor = self.mainLineColor
      testTypeViewAtIndex.mainBackgroundColor = self.mainBackgroundColor
      testTypeViewAtIndex.secondaryBackgroundColor = self.secondaryBackgroundColor
      
      let testScrollViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.testSelectionBackgroundViewHeight + (self.minorMargin * 4) + 25 + self.testPageControllerViewHeight + self.menuButtonHeight)
      
      testTypeViewAtIndex.testTypeTitleLabelHeight = (testScrollViewHeight * 2)/7
      testTypeViewAtIndex.testTypeTimeLabelHeight = (testScrollViewHeight * 2)/7
      testTypeViewAtIndex.testTypeDifficultyViewHeight = (testScrollViewHeight * 3)/7
      testTypeViewAtIndex.testTypeDifficultyButtonHeight = testTypeViewAtIndex.testTypeDifficultyViewHeight - (2 * self.minorMargin)
      testTypeViewAtIndex.testTypeStatsViewHeightAfterSwipe = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + self.majorMargin + self.testPageControllerViewHeight + testTypeViewAtIndex.testTypeTitleLabelHeight + testTypeViewAtIndex.testTypeTimeLabelHeight + testTypeViewAtIndex.testTypeDifficultyViewHeight + (self.menuButtonHeight * 1.5) + (self.minorMargin * 5))
      
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
    
    self.testStartButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.testStartButton.setTitle("Start Test", forState: UIControlState.Normal)
    self.testStartButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testStartButton.backgroundColor = UIColor.turquoiseColor()
    self.testStartButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    self.testLivesUpgradeButton1.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.testLivesUpgradeButton1.setTitle("Buy \(self.noAddtlLives) Lives", forState: UIControlState.Normal)
    self.testLivesUpgradeButton1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testLivesUpgradeButton1.backgroundColor = UIColor.turquoiseColor()
    self.testLivesUpgradeButton1.addTarget(self, action: "addLives:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.testLivesUpgradeButton2.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
    self.testLivesUpgradeButton2.setTitle("Buy Unlimited Lives", forState: UIControlState.Normal)
    self.testLivesUpgradeButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testLivesUpgradeButton2.backgroundColor = UIColor.turquoiseColor()
    self.testLivesUpgradeButton2.addTarget(self, action: "unlimitedLivesTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    //********************************************************************
    //NUMBER 1: CHECK MEMBERSHIP TYPE
    //********************************************************************
    
    membershipType = defaults.objectForKey("Membership") as! String
    
    if (membershipType == "Premium") {
        
        //********************************************************************
        //NUMBER 2: PREMIUM MEMBERS GO TO PAID METHOD
        //********************************************************************
        
        paidConduit()
    
    }else{
        
        //********************************************************************
        //NUMBER 3: FREE MEMBERS GO TO CHECK METHOD EVERY SECOND
        //********************************************************************
        
        freeConduit()
        let date = NSDate().dateByAddingTimeInterval(0)
        timer = NSTimer(fireDate: date, interval: 1, target: self, selector: "freeConduit", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    // Adjust swipeInfoLabel, testLivesTitleLabel and testLivesSubtitleLabel appearance
    
    self.swipeInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
    self.swipeInfoLabel.textAlignment = NSTextAlignment.Center
    self.swipeInfoLabel.textColor = UIColor.lightGrayColor()
    self.swipeInfoLabel.text = "Swipe For More Tests"
    
    let textSize2:CGFloat = self.view.getTextSize(18)
    self.testLivesTitleLabel.textAlignment = NSTextAlignment.Center
    self.testLivesTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
    self.testLivesTitleLabel.text = "TIME TO NEXT FREE LIFE:"
    
    self.testLivesSubtitleLabel.backgroundColor = UIColor.turquoiseColor()
    self.testLivesSubtitleLabel.textAlignment = NSTextAlignment.Center
    self.testLivesSubtitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
    self.testLivesSubtitleLabel.textColor = UIColor.whiteColor()
    
    self.testLivesInfoLabel.textAlignment = NSTextAlignment.Center
    self.testLivesInfoLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
    
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
    
    //********************************************************************
    //NUMBER 3A: CHECK NUMBER OF LIVES AND SET BUTTON TITLE
    //********************************************************************
    
    func freeConduit(){
        
        self.numberOfTestsTotal = defaults.integerForKey("Lives")
        self.testsTotal.addTarget(self, action: "showTestLives:", forControlEvents: UIControlEvents.TouchUpInside)
        self.testsTotal.setTitle(String(self.numberOfTestsTotal), forState: UIControlState.Normal)
        
        if self.numberOfTestsTotal == 1 {
            lifeOrLives = "life"
        }else{
            lifeOrLives = "lives"
        }
        
        self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) \(lifeOrLives) left."
        self.testsTotal.clipsToBounds = true
        self.testsTotal.layer.cornerRadius = self.screenFrame.width/24
        self.testsTotal.layer.borderWidth = 2
        self.testsTotal.layer.borderColor = UIColor.whiteColor().CGColor
        
        //********************************************************************
        //NUMBER 3B: IF NUMBER OF LIVES IS LESS THAN MAX, CHECK HOW MANY...
        //********************************************************************
        
        if (self.numberOfTestsTotal < self.maxNumberOfTests) {
            
            self.checkLives()
            
        }else{
            
            self.testLivesSubtitleLabel.text = "MAXIMUM NUMBER OF FREE LIVES"
            
        }
        
    }
    
    //********************************************************************
    //NUMBER 2A: SET INFINITY LOGO
    //********************************************************************
    
    func paidConduit(){
        
        self.testsTotal.setTitle("∞", forState: UIControlState.Normal)
        self.testsTotal.clipsToBounds = true
        self.testsTotal.layer.cornerRadius = self.screenFrame.width/24
        self.testsTotal.layer.borderWidth = 2
        self.testsTotal.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    //****************************************************************************************************
    //NUMBER 3C: CHECK THE DIFFERENCE BETWEEN THE CURRENT TIME AND THE TIME SET WHEN 1ST FREE LIFE IS USED
    //****************************************************************************************************
    
    func checkLives(){
        
        startTime = CFAbsoluteTimeGetCurrent()
        let initialTime: CFAbsoluteTime = defaults.objectForKey("LivesTimer") as! CFAbsoluteTime
        let diff = startTime - initialTime
        let timeBetweenLives = Double(self.secondsBetweenLives)
        var numberToAdd = floor(diff / timeBetweenLives)
        let newLives:Int = Int(numberToAdd) + numberOfTestsTotal
        self.secondsRemaining = max(self.secondsBetweenLives - Int(diff), 0)
        
        //self.updateTimer()
        
        //****************************************************************************************************
        //NUMBER 3D: IF THERE IS A LIFE/LIVES TO ADD, CHECK THEY DON'T EXCEED MAX AND ADD THEM
        //****************************************************************************************************
        
        if numberToAdd > 0 && self.numberOfTestsTotal < self.maxNumberOfTests {
            
            self.numberOfTestsTotal = min(newLives, 3)
            self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
            self.testsTotal.setTitle(String(self.numberOfTestsTotal), forState: UIControlState.Normal)
            
            if self.numberOfTestsTotal == 1 {
                lifeOrLives = "life"
            }else{
                lifeOrLives = "lives"
            }
            
            //SET RELEVANT VARIABLES BACK TO 0 SO TIMER CAN START AFRESH, BUT IF MAX, STOP
            
            self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) \(lifeOrLives) left."
            numberToAdd = 0
            let now:CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
            self.defaults.setObject(now, forKey: "LivesTimer")
            
            if self.numberOfTestsTotal == self.maxNumberOfTests {
                
                self.timer.invalidate()
                self.testLivesSubtitleLabel.text = "MAXIMUM NUMBER OF FREE LIVES"
                
            }

            //freeConduit()
            //updateTimer()
            
        //****************************************************************************************************
        //NUMBER 3E: IF LIVES ARE MAXIMUM, SET TITLE, OTHERWISE UPDATE CLOCK
        //****************************************************************************************************
            
        } else if self.numberOfTestsTotal == self.maxNumberOfTests {
            
            self.timer.invalidate()
            self.testLivesSubtitleLabel.text = "MAXIMUM NUMBER OF FREE LIVES"
            
        }else{
        
            //self.updateTimer()
            let newHour:String = String(format: "%02d", (self.secondsRemaining / 3600))
            let newMin:String = String(format: "%02d", (self.secondsRemaining % 3600) / 60)
            let newSec:String = String(format: "%02d", (self.secondsRemaining % 3600) % 60)
            let newLabel:String = "\(newHour) : \(newMin) : \(newSec)"
            self.testLivesSubtitleLabel.text = newLabel
            
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
    
    self.testSelectionViewHeightConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + self.testSelectionBackgroundViewHeight + self.minorMargin) + self.minorMargin)
    
    self.testSelectionView.addConstraint(self.testSelectionViewHeightConstraint)
    self.view.addConstraints([self.testSelectionViewBottomConstraint, testSelectionViewLeftConstraint, testSelectionViewRightConstraint])
    
    // Create and add constraints for swipeInfoLabel
    
    self.swipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let swipeInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let swipeInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let swipeInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let swipeInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.swipeInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
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
    
    let testScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
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
    
    let testLivesBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testLivesBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testSelectionBackgroundViewHeight)
    
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
    
    if (membershipType != "Premium" && self.numberOfTestsTotal == 0 && sender.titleLabel?.text == "Start Test"){
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Buy \(self.noAddtlLives) Lives", action: ({
            
            SwiftSpinner.show("Purchasing")
            //self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
            self.addLivesTapped()
            
        }))
        
        backAlert.addButton("Wait", action: ({
            
            //self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
            
        }))
        backAlert.showSuccess("OUT OF LIVES", subTitle: "You can purchase some now.")
        
    }else{
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if self.testSelectionViewVisible {
        
        self.backgroundImageView2.image = UIImage.init(named: "homeBG")
        self.backgroundImageView2.alpha = 1
        self.backgroundImageView.alpha = 0
        self.testSelectionView.alpha = 0
        self.testsTotal.alpha = 0
        if self.testLivesBackgroudViewVisible {
          self.testLivesBackgroundView.alpha = 0
        }
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
          
          if sender.titleLabel?.text == "Start Test" {
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
              
            }else if (self.membershipType == "Premium"){
              
              self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: sender)
              
            }else{
              
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let backAlert = SCLAlertView(appearance: appearance)
                backAlert.addButton("Buy \(self.noAddtlLives) Lives", action: ({
                    
                    SwiftSpinner.show("Purchasing")
                    self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                    self.addLivesTapped()
                    
                }))

              backAlert.addButton("Wait", action: ({
                
                self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                
              }))
              backAlert.showSuccess("OUT OF LIVES", subTitle: "You can purchase some now.")
              
            }
          }
          else {
            
            SwiftSpinner.show("Submitting Vote")
            
            let query = PFQuery(className: PF_TESTVOTE_CLASS_NAME)
            query.whereKey(PF_TESTVOTE_CAREER, equalTo: self.selectedCareer)
            query.whereKey(PF_TESTVOTE_TEST, equalTo: self.testTypeViews[self.currentScrollViewPage].testTypeTimeLabel.text!)

            query.getFirstObjectInBackgroundWithBlock({ (votes: PFObject?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    votes?.incrementKey(PF_TESTVOTE_VOTES)
                    
                        votes?.saveInBackgroundWithBlock({ (success, error) -> Void in
                            
                        if error == nil {

                            SwiftSpinner.show("Vote Submitted", animated: false).addTapHandler({
                                
                                self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                                
                                SwiftSpinner.hide()
                                
                                }, subtitle: "Tap to return home")
                            
                        } else {
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                                
                                SwiftSpinner.hide()
                                
                                }, subtitle: "Try again later. Tap to return home")
                            
                        }
                        
                    })
                    
                }else{
                    
                    SwiftSpinner.show("Submitting Vote")
                    
                    let voteSubmission = PFObject(className: PF_TESTVOTE_CLASS_NAME)
                    voteSubmission[PF_TESTVOTE_CAREER] = self.selectedCareer
                    voteSubmission[PF_TESTVOTE_TEST] = self.testTypeViews[self.currentScrollViewPage].testTypeTimeLabel.text!
                    voteSubmission[PF_TESTVOTE_VOTES] = 1
                    
                    voteSubmission.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                        if error == nil {
                            
                            SwiftSpinner.show("Vote Submitted", animated: false).addTapHandler({
                                self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                                SwiftSpinner.hide()
                                }, subtitle: "Tap to return home")
                            
                        } else {
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
                                SwiftSpinner.hide()
                                }, subtitle: "Try again later. Tap to return home")
                            
                        }
                    })

                    
                }
            })
            }
        }
        })
    
    }
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
  
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    self.currentScrollViewPage = Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width)
    self.testPageControllerView.updatePageController(self.currentScrollViewPage)
    self.backgroundImageView.image = UIImage.init(named: self.testTypeBackgroundImages[self.testTypes[self.currentScrollViewPage]]!)
    self.backgroundImageView.alpha = 1
    self.backgroundImageView2.alpha = 0
    
    if self.currentScrollViewPage == self.testTypes.count - 1 {
      self.testStartButton.setTitle("Vote For This Test", forState: UIControlState.Normal)
    }
    else {
      self.testStartButton.setTitle("Start Test", forState: UIControlState.Normal)
    }
    
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
    if self.numberOfTestsTotal == 1 {
        lifeOrLives = "life"
    }else{
        lifeOrLives = "lives"
    }
    self.testLivesInfoLabel.text = "You have \(self.numberOfTestsTotal) \(lifeOrLives) left."
    
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
    
    func addLives(sender: UIButton){
        
        SwiftSpinner.show("Purchasing")
        addLivesTapped()
        
    }
    
    func extraLives(){
        
        self.numberOfTestsTotal = self.numberOfTestsTotal + self.noAddtlLives
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        
        SwiftSpinner.show("You Have Purchased 5 Additional Lives", animated: false).addTapHandler({
            SwiftSpinner.hide()
            }, subtitle: "We encourage you to put them to good use!")
        
    }
    
    //if lives are bought when out of lives
    
    func extraLives2(sender: UIButton){
        
        SwiftSpinner.show("Purchasing")
        
        addLivesTapped()
        
        self.numberOfTestsTotal = self.numberOfTestsTotal + noAddtlLives
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        self.numberOfTestsTotal--
        self.defaults.setInteger(self.numberOfTestsTotal, forKey: "Lives")
        
        SwiftSpinner.show("You Have Purchased \(self.noAddtlLives) Additional Lives", animated: false).addTapHandler({
            self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: sender)
            SwiftSpinner.hide()
            }, subtitle: "We encourage you to put them to good use!")
        
    }
    
    func premiumMembership(){
        
        SwiftSpinner.show("Purchasing")
        
        if let currentUser = PFUser.currentUser(){
            currentUser[PF_USER_MEMBERSHIP] = "Premium"
            //set other fields the same way....
            currentUser.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                                    if error == nil {
                
                                        self.timer.invalidate()
                                        self.defaults.setObject("Premium", forKey: "Membership")
                                        self.testLivesBackgroundView.alpha = 0
                                        self.testLivesBackgroudViewVisible = false
                                        self.testsTotal.removeTarget(self, action: "showTestLives:", forControlEvents: UIControlEvents.TouchUpInside)
                                        self.testsTotal.setTitle("∞", forState: UIControlState.Normal)
                                        self.membershipType = self.defaults.objectForKey("Membership") as! String
                                        self.paidConduit()
                                        print(self.membershipType)
                                        
                                        SwiftSpinner.show("You Are Now a Premium User", animated: false).addTapHandler({
                                            self.testsTotal.setTitle("∞", forState: UIControlState.Normal)
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
//            print("product added")
//            print(product.productIdentifier)
//            print(product.localizedTitle)
//            print(product.localizedDescription)
//            print(product.price)
            list.append(product)
        }
        
    }
    
    func addLivesTapped(){
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "com.APPSIDE.Breakin2.ExtraLives1") {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    
    func unlimitedLivesTapped(sender: UIButton){
        
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
    
//    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
//        print("transactions restored")
//        
//        for transaction in queue.transactions {
//            let t: SKPaymentTransaction = transaction
//            
//            let prodID = t.payment.productIdentifier as String
//            
//            switch prodID {
//            case "seemu.iap.removeads":
//                print("remove ads")
//                removeAds()
//            case "seemu.iap.addcoins":
//                print("add coins to account")
//                addCoins()
//            default:
//                print("IAP not setup")
//            }
//            
//        }
//    }
    
    
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
                    //print("extra lives bought")
                    extraLives()
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

