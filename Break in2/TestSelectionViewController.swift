//
//  ViewController.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 11/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class TestSelectionViewController: UIViewController, UIScrollViewDelegate {
  
  // Declare and initialize types of tests and difficulties available for selected career
  
  var testTypes:[String] = ["Numerical Reasoning", "Verbal Reasoning", "Logical Reasoning"]
    let testTypeBackgroundImages:[String:String] = ["Numerical Reasoning":"numericalBG", "Verbal Reasoning":"verbalBG", "Logical Reasoning":"logicalBG"]
    let testTypeSegues:[String:String] = ["Numerical Reasoning":"numericalReasoningSelected","Verbal Reasoning":"verbalReasoningSelected","Logical Reasoning":"LRSegue"]
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
  
  // Declare and initialize constraints that will be animated
  
  var testSelectionViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var testSelectionViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize tracking variables
  
  var testSelectionViewVisible:Bool = false
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
  
  let testTypeStatsViewHeightAfterSwipe:CGFloat = 200
  
  // Declare and initialize gestures
  
  var careerTapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
  var testSelectionViewSwipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
  var testSelectionViewSwipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
  
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
      testTypeViewAtIndex.testTypeStatsViewHeightAfterSwipe = self.testTypeStatsViewHeightAfterSwipe
      
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
    
    // Add testPageControllerView, testScrollView to testSelectionView
    
    self.testSelectionView.addSubview(self.testPageControllerView)
    self.testSelectionView.addSubview(self.testScrollView)
    self.testSelectionView.addSubview(self.testStartButton)
    
    // Set constraints
    
    self.setConstraints()
    
    // Adjust testScrollView characteristics
    
    self.testScrollView.pagingEnabled = true
    self.testScrollView.showsHorizontalScrollIndicator = false
    
    self.testScrollView.delegate = self
    
    // Adjust main view appearance
    
    self.view.backgroundColor = self.secondaryBackgroundColor
    
    // Adjust testSelectioView apperance
    
    self.testSelectionView.backgroundColor = self.mainBackgroundColor
    self.testSelectionView.layer.cornerRadius = self.minorMargin
    
    // Adjust testStartButton and backButton appearances
    
    self.testStartButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.testStartButton.setTitle("Start Test", forState: UIControlState.Normal)
    self.testStartButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    self.testStartButton.backgroundColor = UIColor.turquoiseColor()
    self.testStartButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "hideTestSelectionView:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    self.backButton.alpha = 0
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    // Display each testTypeView
    
    for testTypeViewAtIndex in self.testTypeViews {
      
      testTypeViewAtIndex.displayView()
      
    }
    
    // Set up, customise and add gestures
    
    self.testSelectionViewSwipeUpGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("showStats:"))
    self.testSelectionViewSwipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
    self.testSelectionView.addGestureRecognizer(self.testSelectionViewSwipeUpGesture)
    
    self.testSelectionViewSwipeDownGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("hideStats:"))
    self.testSelectionViewSwipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
    self.testSelectionView.addGestureRecognizer(self.testSelectionViewSwipeDownGesture)
    
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
    
    self.testSelectionViewBottomConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + self.menuButtonHeight + (self.minorMargin * 5))
    
    let testSelectionViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testSelectionViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.testSelectionViewHeightConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + self.menuButtonHeight + (self.minorMargin * 5))
    
    self.testSelectionView.addConstraint(self.testSelectionViewHeightConstraint)
    self.view.addConstraints([self.testSelectionViewBottomConstraint, testSelectionViewLeftConstraint, testSelectionViewRightConstraint])
    
    // Create and add constraints for testPageControllerView
    
    self.testPageControllerView.translatesAutoresizingMaskIntoConstraints = false
    
    let testPageControllerViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testPageControllerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
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
    
    let testScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * 1)
    
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
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
  }
  
  func showTestSelectionView() {
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if !self.testSelectionViewVisible {
        
        self.backgroundImageView.alpha = 1
        self.backgroundImageView2.alpha = 0
        self.backButton.alpha = 1
        self.testSelectionViewBottomConstraint.constant = self.minorMargin
        self.view.layoutIfNeeded()
        
        self.testSelectionViewVisible = true
        
      }
      
      }, completion: nil)
    
  }
  
  func hideTestSelectionView(sender:UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if self.testSelectionViewVisible {
        if sender == self.backButton {
          self.backgroundImageView2.image = UIImage.init(named: "homeBG")
          self.backgroundImageView2.alpha = 1
        }
        self.backgroundImageView.alpha = 0
        self.testSelectionViewBottomConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + self.menuButtonHeight + (self.minorMargin * 5)
        self.view.layoutIfNeeded()
        
        self.testSelectionViewVisible = false
        
      }
      
      }, completion: {(Bool) in
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
          
          self.backButton.alpha = 0
          
          }, completion: {(Bool) in
        
            if sender == self.backButton {
              self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
            }
            else if sender == self.testStartButton {
              self.performSegueWithIdentifier(self.testTypeSegues[self.testTypes[self.currentScrollViewPage]]!, sender: nil)
            }
            
        })
        
    })
    
  }
  
  func showStats(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.testSelectionViewHeightConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + self.menuButtonHeight + (self.minorMargin * 5) + self.testTypeStatsViewHeightAfterSwipe
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }
  
  func hideStats(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.testSelectionViewHeightConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleLabelHeight + self.testTypeTimeLabelHeight + self.testTypeDifficultyViewHeight + self.menuButtonHeight + (self.minorMargin * 5)
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
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
  
}

