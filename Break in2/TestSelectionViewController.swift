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
  
  let testTypes:[String] = ["Numerical Reasoning", "Verbal Reasoning", "Logical Reasoning"]
  let testDifficulties:[String] = ["E", "M", "H"]
  
  // Declare and intialize views
  
  let testSelectionView:UIView = UIView()
  var testPageControllerView:PageControllerView = PageControllerView()
  let testScrollView:UIScrollView = UIScrollView()
  var testTypeViews:[TestTypeView] = [TestTypeView]()
  let testStartButtonView:UIView = UIView()
  let testStartButton:UIButton = UIButton(type: UIButtonType.System)
  var backButton:UIButton = UIButton()
  
  // Declare and initialize constraints that will be animated
  
  var testSelectionViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var testSelectionViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
  
  // Declare and initialize tracking variables
  
  var testSelectionViewVisible:Bool = false
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let mainLineColor:UIColor = UIColor.blackColor()
  let mainBackgroundColor:UIColor = UIColor.whiteColor()
  let secondaryBackgroundColor:UIColor = UIColor.lightGrayColor()
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let testPageControllerViewHeight:CGFloat = 50
  let testTypeTitleViewHeight:CGFloat = 80
  let testTypeDifficultyViewHeight:CGFloat = 50
  let testStartButtonViewHeight:CGFloat = 50

  let testTypeStatsViewHeightAfterSwipe:CGFloat = 100
  
  // Declare and initialize gestures
  
  var careerTapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
  var testSelectionViewSwipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
  var testSelectionViewSwipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set background image
    
    self.view.addHomeBG()
    
    // Add testSelectionView and backButton to the main view
    
    self.view.addSubview(testSelectionView)
    self.view.addSubview(self.backButton)
    
    // Create testTypeViews for each testType
    
    let testTypeDifficultyButtonHeight:CGFloat = self.testTypeDifficultyViewHeight - (2 * self.minorMargin)
    
    for var index = 0 ; index < self.testTypes.count ; index++ {
      
      let testTypeViewAtIndex:TestTypeView = TestTypeView()
      
      testTypeViewAtIndex.testTypes = self.testTypes
      testTypeViewAtIndex.testDifficulties = self.testDifficulties
      testTypeViewAtIndex.testTypeViewsIndex = index
      
      testTypeViewAtIndex.majorMargin = self.majorMargin
      testTypeViewAtIndex.minorMargin = self.minorMargin
      testTypeViewAtIndex.mainLineColor = self.mainLineColor
      testTypeViewAtIndex.mainBackgroundColor = self.mainBackgroundColor
      testTypeViewAtIndex.secondaryBackgroundColor = self.secondaryBackgroundColor
      
      testTypeViewAtIndex.testTypeTitleViewHeight = self.testTypeTitleViewHeight
      testTypeViewAtIndex.testTypeDifficultyViewHeight = self.testTypeDifficultyViewHeight
      testTypeViewAtIndex.testTypeDifficultyButtonHeight = testTypeDifficultyButtonHeight
      testTypeViewAtIndex.testTypeStatsViewHeightAfterSwipe = self.testTypeStatsViewHeightAfterSwipe
      
      self.testTypeViews.append(testTypeViewAtIndex)
      
    }
    
    // Create testPageControllerView
    
    self.testPageControllerView.testTypes = self.testTypes
    self.testPageControllerView.minorMargin = self.minorMargin
    
    self.testPageControllerView.pageControllerCircleHeight = 10
    self.testPageControllerView.pageControllerSelectedCircleHeight = 18
    self.testPageControllerView.pageControllerSelectedCircleThickness = 2
    
    // Add testPageControllerView, testScrollView to testSelectionView
    
    self.testSelectionView.addSubview(self.testPageControllerView)
    self.testSelectionView.addSubview(self.testScrollView)
    self.testSelectionView.addSubview(self.testStartButtonView)
    self.testStartButtonView.addSubview(self.testStartButton)
    
    // Add testTypeViews to testScrollView
    
    for testTypeViewAtIndex:UIView in self.testTypeViews {
      
      self.testScrollView.addSubview(testTypeViewAtIndex)
      
    }
    
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
    
    // Adjust testStartButton and backButton appearances
    
    self.testStartButton.setTitle("Start Test", forState: UIControlState.Normal)
    self.testStartButton.setTitleColor(self.mainLineColor, forState: UIControlState.Normal)
    self.testStartButton.addTarget(self, action: "testStartButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
    self.backButton.addTarget(self, action: "backButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    self.backButton.clipsToBounds = true
    
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
    
    self.animateTestSelectionView()

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setConstraints() {
    
    // Create and add constraints for testSelectionView
    
    self.testSelectionView.translatesAutoresizingMaskIntoConstraints = false
    
    self.testSelectionViewBottomConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.testPageControllerViewHeight + self.testTypeTitleViewHeight + self.testTypeDifficultyViewHeight + self.testStartButtonViewHeight)
    
    let testSelectionViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testSelectionViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.testSelectionViewHeightConstraint = NSLayoutConstraint.init(item: self.testSelectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testPageControllerViewHeight + self.testTypeTitleViewHeight + self.testTypeDifficultyViewHeight + self.testStartButtonViewHeight)
    
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
    
    // Create and add constraints for testStartButtonView
    
    self.testStartButtonView.translatesAutoresizingMaskIntoConstraints = false
    
    let testStartButtonViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButtonView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testStartButtonViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButtonView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testStartButtonViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButtonView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testStartButtonViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButtonView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testStartButtonViewHeight)
    
    self.testStartButtonView.addConstraint(testStartButtonViewHeightConstraint)
    self.view.addConstraints([testStartButtonViewLeftConstraint, testStartButtonViewRightConstraint, testStartButtonViewBottomConstraint])
    
    // Create and add constraints for testScrollView
    
    self.testScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let testScrollViewViewTopConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testPageControllerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testScrollViewLeftConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testScrollViewRightConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testSelectionView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.testScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButtonView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    self.view.addConstraints([testScrollViewViewTopConstraint, testScrollViewLeftConstraint, testScrollViewRightConstraint, testScrollViewBottomConstraint])
    
    // Create and add constraints for each testTypeView and set content size for testScrollView
    
    for var index:Int = 0 ; index < self.testTypes.count ; index++ {
      
      self.testTypeViews[index].translatesAutoresizingMaskIntoConstraints = false
      
      let testTypeViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let testTypeViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeTitleViewHeight + self.testTypeDifficultyViewHeight)
      
      let testTypeViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * self.majorMargin))
    
      if index == 0 {
        
        let testTypeViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeViewLeftConstraint)
        
      }
      else {
        
        let testTypeViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeViews[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeViewLeftConstraint)
        
      }
      
      self.testTypeViews[index].addConstraints([testTypeViewWidthConstraint, testTypeViewHeightConstraint])
      self.view.addConstraint(testTypeViewTopConstraint)
      
      if index == self.testTypes.count - 1 {
        
        let testScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testScrollViewRightConstraint)
        
      }
      
    }
    
    // Create and add constraints for testStartButton
    
    self.testStartButton.translatesAutoresizingMaskIntoConstraints = false
    
    let testStartButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButtonView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let testStartButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButtonView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testStartButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButtonView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testStartButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testStartButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testStartButtonView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    self.view.addConstraints([testStartButtonTopConstraint, testStartButtonLeftConstraint, testStartButtonRightConstraint, testStartButtonBottomConstraint])
    
    // Create and add constraints for backButton
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = false
    
    let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])

  }
  
  func animateTestSelectionView() {
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      if !self.testSelectionViewVisible {
        
        self.testSelectionViewBottomConstraint.constant = self.majorMargin * -1
        self.view.layoutIfNeeded()
        
        self.testSelectionViewVisible = true
        
      }
      
      }, completion: nil)
    
  }
  
  func showStats(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.testSelectionViewHeightConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleViewHeight + self.testTypeDifficultyViewHeight + self.testStartButtonViewHeight + self.testTypeStatsViewHeightAfterSwipe
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }
  
  func hideStats(sender: UISwipeGestureRecognizer) {
    
    UIView.animateWithDuration(1, animations: {
      
      self.testSelectionViewHeightConstraint.constant = self.testPageControllerViewHeight + self.testTypeTitleViewHeight + self.testTypeDifficultyViewHeight + self.testStartButtonViewHeight
      self.view.layoutIfNeeded()
      
      }, completion: nil)
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    let pageIndex:Int = Int(self.testScrollView.contentOffset.x / self.testScrollView.frame.size.width)
    self.testPageControllerView.updatePageController(pageIndex)
    
  }
  
  func backButtonClicked(sender:UIButton) {
    
    self.performSegueWithIdentifier("backFromTestSelection", sender: nil)
    
  }
  
  func testStartButtonClicked(sender:UIButton) {
    
    self.performSegueWithIdentifier("testStartButtonClicked", sender: nil)
    
  }
  
}

