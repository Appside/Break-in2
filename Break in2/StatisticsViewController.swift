//
//  StatisticsViewController.swift
//  Break in2
//
//  Created by Sangeet on 29/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Charts
import SCLAlertView
import SwiftSpinner
import Parse
import ParseUI

class StatisticsViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {
  
  // Declare and initialize types of careers
  
  var testTypes:[String] = [String]()
  var testColors:[String:UIColor] = [String:UIColor]()
  var tutorialViews:[UIView] = [UIView]()

  // Declare and initialize views and models
  
  let logoImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  let statisticsBackgroundView:UIView = UIView()
  let statisticsView:UIView = UIView()
  let statisticsTitleView:StatisticsTitleView = StatisticsTitleView()
  let statisticsScrollView:UIScrollView = UIScrollView()
  let testTypesBackgroundView:UIView = UIView()
  let testTypesScrollView:UIScrollView = UIScrollView()
  var testTypeButtons:[CareerButton] = [CareerButton]()
  let scrollInfoLabel:UILabel = UILabel()
  let clearStatsButton:UIButton = UIButton()
  let tutorialView:UIView = UIView()
  let tutorialNextButton:UIButton = UIButton()
    
    let pointerView1:LabelPointerView = LabelPointerView()
    let pointerView2:LabelPointerView = LabelPointerView()
    let graphView1:UIView = UIView()
    let graphView2:UIView = UIView()
    let appVariablesModel:JSONModel = JSONModel()
    let chartObject:BarChartView = BarChartView()
    let chartObject2:LineChartView = LineChartView()
    let barChartDescription:UIView = UIView()
    let barChartText:UILabel = UILabel()
    let lineChartDescription:UIView = UIView()
    let lineChartText:UILabel = UILabel()
    let noDataLabel:UIView = UIView()
    let noDataUILabel:UILabel = UILabel()
    var dateTests:[String] = [String]()
    var selectedTest:String = String()

  var testTypesBackgroundViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()

  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  let menuButtonHeight:CGFloat = 50
  var textSize:CGFloat = 15

  var firstTimeUser:Bool = false
  var tutorialPageNumber:Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // Add background image to HomeViewController's view
      
      self.view.addHomeBG()
      self.statisticsTitleView.disablePrevious()
      
      self.textSize = self.view.getTextSize(15)
        
      // Add subviews
      
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.backButton)
      self.view.addSubview(self.statisticsBackgroundView)
      self.view.addSubview(self.testTypesBackgroundView)
      self.statisticsBackgroundView.addSubview(self.statisticsView)
      self.statisticsView.addSubview(self.statisticsTitleView)
      self.statisticsView.addSubview(self.statisticsScrollView)
      self.testTypesBackgroundView.addSubview(self.scrollInfoLabel)
      self.testTypesBackgroundView.addSubview(self.testTypesScrollView)
      self.testTypesBackgroundView.addSubview(self.clearStatsButton)
      
        
        self.statisticsScrollView.addSubview(self.graphView1)
        self.statisticsScrollView.addSubview(self.graphView2)
        self.graphView1.addSubview(self.barChartDescription)
        self.barChartDescription.addSubview(self.barChartText)
        self.graphView2.addSubview(self.lineChartDescription)
        self.lineChartDescription.addSubview(self.lineChartText)

        self.graphView1.addSubview(self.pointerView1)
        self.graphView2.addSubview(self.pointerView2)
        self.statisticsView.addSubview(self.noDataLabel)
      
      self.view.addSubview(self.tutorialView)
      self.view.addSubview(self.tutorialNextButton)

      // Create careerButtons for each testType

      for var index:Int = 0 ; index < self.testTypes.count ; index++ {
        
        let careerButtonAtIndex:CareerButton = CareerButton()
        
        // Set careerButton properties
        
        careerButtonAtIndex.careerTitle = self.testTypes[index]
        careerButtonAtIndex.careerColorView.backgroundColor = self.testColors[self.testTypes[index]]
        
        // Call method to display careerButton content
        
        careerButtonAtIndex.displayButton()
        
        // Store each button in the careerButtons array
        
        self.testTypeButtons.append(careerButtonAtIndex)
        
        // Add each button to testTypesScrollView

        self.testTypesScrollView.addSubview(self.testTypeButtons[index])
        
        // Make each button perform a segue to the TestSelectionViewController
        
        self.testTypeButtons[index].tag = index
        self.testTypeButtons[index].addTarget(self, action: "dataDownload:", forControlEvents: UIControlEvents.TouchUpInside)
      }
      
      // Customize views
      
      self.testTypesBackgroundView.backgroundColor = UIColor.whiteColor()
      self.testTypesBackgroundView.layer.cornerRadius = self.minorMargin
      self.testTypesBackgroundView.alpha = 0
      self.testTypesBackgroundView.clipsToBounds = true
      
      self.statisticsBackgroundView.backgroundColor = UIColor.whiteColor()
      self.statisticsBackgroundView.layer.cornerRadius = self.minorMargin
      self.statisticsBackgroundView.alpha = 0
      self.statisticsBackgroundView.clipsToBounds = true
      
      self.testTypesScrollView.showsVerticalScrollIndicator = false
      self.statisticsScrollView.delegate = self

      self.statisticsView.backgroundColor = UIColor.whiteColor()
      self.statisticsView.layer.cornerRadius = self.minorMargin
      self.statisticsView.clipsToBounds = true
      
      self.tutorialView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.86)
      self.tutorialView.alpha = 0
      
      self.statisticsScrollView.pagingEnabled = true
      
        //PointerViews
        self.pointerView1.alpha = 0
        self.pointerView2.alpha = 0
        
        //Graph 1 (constraints and colors)
        self.graphView1.addSubview(chartObject)
        self.chartObject.setConstraintsToSuperview(40, bottom: 0, left: 0, right: 0)
        self.barChartText.setConstraintsToSuperview(5, bottom: 5, left: 0, right: 0)
        self.chartObject.delegate = self
        self.chartObject.noDataText = ""
        
        //Graph 2 (constraints and colors)
        self.graphView2.addSubview(chartObject2)
        self.chartObject2.setConstraintsToSuperview(40, bottom: 0, left: 0, right: 0)
        self.lineChartText.setConstraintsToSuperview(5, bottom: 5, left: 0, right: 0)
        self.chartObject2.delegate = self
        self.chartObject2.noDataText = ""
        
      // Customize imageViews
      
      self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
      
      // Customize buttons
      
      self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
      self.backButton.addTarget(self, action: "hideTestTypesBackgroundView:", forControlEvents: UIControlEvents.TouchUpInside)
      self.backButton.clipsToBounds = true
      self.backButton.alpha = 0
      
      self.clearStatsButton.backgroundColor = UIColor.turquoiseColor()
      self.clearStatsButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
      self.clearStatsButton.setTitle("Clear Selected Test Statistics", forState: UIControlState.Normal)
      self.clearStatsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      self.clearStatsButton.addTarget(self, action: "clearStatsWarning:", forControlEvents: UIControlEvents.TouchUpInside)
      
      self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.textSize)
      self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
      self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
      self.scrollInfoLabel.text = "Scroll For More Tests"
      
      self.tutorialNextButton.backgroundColor = UIColor.turquoiseColor()
      self.tutorialNextButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.textSize)
      self.tutorialNextButton.setTitle("Next", forState: UIControlState.Normal)
      self.tutorialNextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      self.tutorialNextButton.alpha = 0
      self.tutorialNextButton.addTarget(self, action: "nextTutorialButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
      
      // Set contraints
      
      self.setConstraints()
      
      // Display statisticsTitleView
      
      self.statisticsTitleView.displayView()

        // Do any additional setup after loading the view.
        
        
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // Show screen with animation

    self.showTestTypesBackgroundView()
    
    //LabelPointerView
    self.pointerView1.labelPointerBaseWidth = self.graphView1.frame.width/12
    self.pointerView1.moveLabelPointer(self.graphView1.frame.width/6 * (5.5))
    self.pointerView2.labelPointerBaseWidth = self.graphView1.frame.width/12
    self.pointerView2.moveLabelPointer(self.graphView1.frame.width/6 * (5.5))
    
    // Show tutorial to first time users
    
    if self.firstTimeUser {
      self.tutorialViews.appendContentsOf([self.testTypesBackgroundView, self.backButton])
      self.showTutorial()
    }

  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
    
    self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
    self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
    
    // Create and add constraints for statisticsBackgroundView
    
    self.statisticsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let statisticsBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin)
    
    let statisticsBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let statisticsBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let statisticsBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 7) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight))
    
    self.statisticsBackgroundView.addConstraint(statisticsBackgroundViewHeightConstraint)
    self.view.addConstraints([statisticsBackgroundViewTopConstraint, statisticsBackgroundViewLeftConstraint, statisticsBackgroundViewRightConstraint])
    
    // Create and add constraints for statisticsView
    
    self.statisticsView.translatesAutoresizingMaskIntoConstraints = false
    
    let statisticsViewTopConstraint = NSLayoutConstraint.init(item: self.statisticsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let statisticsViewRightConstraint = NSLayoutConstraint.init(item: self.statisticsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let statisticsViewLeftConstraint = NSLayoutConstraint.init(item: self.statisticsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let statisticsViewBottomConstraint = NSLayoutConstraint.init(item: self.statisticsView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    self.statisticsBackgroundView.addConstraints([statisticsViewTopConstraint, statisticsViewRightConstraint, statisticsViewLeftConstraint, statisticsViewBottomConstraint])
    
    // Create and add constraints for statisticsTitleView
    
    self.statisticsTitleView.translatesAutoresizingMaskIntoConstraints = false
    
    let statisticsTitleViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let statisticsTitleViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let statisticsTitleViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let statisticsTitleViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: ((self.screenFrame.height - (self.statusBarFrame.height + (self.minorMargin * 9) + (self.menuButtonHeight * 4.5) + (self.majorMargin * 2) + self.backButtonHeight)) * 2)/9)
    
    self.statisticsTitleView.addConstraint(statisticsTitleViewHeightConstraint)
    self.view.addConstraints([statisticsTitleViewTopConstraint, statisticsTitleViewLeftConstraint, statisticsTitleViewRightConstraint])
    
    // Create and add constraints for testTypesBackgroundView
    
    self.testTypesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypesBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.menuButtonHeight * 4.5))
    
    let testTypesBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testTypesBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.testTypesBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5)) + self.minorMargin)
    
    self.testTypesBackgroundView.addConstraint(testTypesBackgroundViewHeightConstraint)
    self.view.addConstraints([testTypesBackgroundViewRightConstraint, testTypesBackgroundViewLeftConstraint, self.testTypesBackgroundViewTopConstraint])
    
    // Create and add constraints for statisticsScrollView
    
    self.statisticsScrollView.translatesAutoresizingMaskIntoConstraints = false

    let statisticsScrollViewTopConstraint = NSLayoutConstraint.init(item: self.statisticsScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsTitleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let statisticsScrollViewRightConstraint = NSLayoutConstraint.init(item: self.statisticsScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let statisticsScrollViewLeftConstraint = NSLayoutConstraint.init(item: self.statisticsScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let statisticsScrollViewBottomConstraint = NSLayoutConstraint.init(item: self.statisticsScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.statisticsView.addConstraints([statisticsScrollViewTopConstraint, statisticsScrollViewRightConstraint, statisticsScrollViewLeftConstraint, statisticsScrollViewBottomConstraint])
    
    // Create and add constraints for clearStatsButton
    
    self.clearStatsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let clearStatsButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.clearStatsButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let clearStatsButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.clearStatsButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    let clearStatsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.clearStatsButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let clearStatsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.clearStatsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.clearStatsButton.addConstraint(clearStatsButtonHeightConstraint)
    self.view.addConstraints([clearStatsButtonLeftConstraint, clearStatsButtonBottomConstraint, clearStatsButtonRightConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight/2)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for testTypesScrollView
    
    self.testTypesScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypesScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testTypesScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.clearStatsButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let testTypesScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testTypesScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([testTypesScrollViewLeftConstraint, testTypesScrollViewBottomConstraint, testTypesScrollViewRightConstraint, testTypesScrollViewTopConstraint])

    // Create and add constraints for each testTypeButton and set content size for testTypesScrollView
    
    for var index:Int = 0 ; index < self.testTypeButtons.count ; index++ {
      
      self.testTypeButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let testTypeButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let testTypeButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
      
      let testTypeButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * (self.majorMargin + self.minorMargin)))
      
      if index == 0 {
        
        let testTypeButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeButtonTopConstraint)
        
      }
      else {
        
        let testTypeButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeButtons[index - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
        
        self.view.addConstraint(testTypeButtonTopConstraint)
        
      }
      
      self.testTypeButtons[index].addConstraints([testTypeButtonWidthConstraint, testTypeButtonHeightConstraint])
      self.view.addConstraint(testTypeButtonLeftConstraint)
      
      if index == self.testTypeButtons.count - 1 {
        
        let testTypeButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeButtons[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypesScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraint(testTypeButtonBottomConstraint)
        
      }
      
    }

    //Create and add constraints for GraphView1
    
    self.graphView1.translatesAutoresizingMaskIntoConstraints = false
    
    let graphView1Top:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let graphView1Left:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)

    self.statisticsScrollView.addConstraints([graphView1Top,graphView1Left])
    
    let graphView1Width:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -2*(self.majorMargin) - 2*(self.minorMargin))
    let graphView1Height:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsScrollView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)

    self.view.addConstraints([graphView1Width,graphView1Height])
    
    //Create and add constraints for GraphView2
    
    self.graphView2.translatesAutoresizingMaskIntoConstraints = false
    
    let graphView2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    self.statisticsScrollView.addConstraint(graphView2Top)
    
    let graphView2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    self.statisticsScrollView.addConstraint(graphView2Left)
    
    let graphView2Width:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -2*(self.majorMargin) - 2*(self.minorMargin))
    let graphView2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.statisticsScrollView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
    
    self.view.addConstraints([graphView2Width,graphView2Height])
    
    self.statisticsScrollView.showsHorizontalScrollIndicator = false
    
    //Create and set constraints for barChartDescription and barChartLabel
    
    self.barChartDescription.translatesAutoresizingMaskIntoConstraints = false
    
    let barChartDescriptionTop:NSLayoutConstraint = NSLayoutConstraint(item: self.barChartDescription, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let barChartDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.barChartDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let barChartDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.barChartDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    let barChartDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.barChartDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    self.graphView1.addConstraints([barChartDescriptionLeft,barChartDescriptionRight,barChartDescriptionTop])
    self.barChartDescription.addConstraint(barChartDescriptionHeight)

    //Create and set constraints for lineChartDescription and lineChartLabel
    
    self.lineChartDescription.translatesAutoresizingMaskIntoConstraints = false
    
    let lineChartDescriptionTop:NSLayoutConstraint = NSLayoutConstraint(item: self.lineChartDescription, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let lineChartDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.lineChartDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let lineChartDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.lineChartDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    let lineChartDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.lineChartDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    self.graphView2.addConstraints([lineChartDescriptionLeft,lineChartDescriptionRight,lineChartDescriptionTop])
    self.lineChartDescription.addConstraint(lineChartDescriptionHeight)
   
    //Create and set constraints for pointerView1
    
    self.pointerView1.translatesAutoresizingMaskIntoConstraints = false
    
    let pointerView1Top:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
    let pointerView1Left:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let pointerView1Right:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView1, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView1, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    let pointerView1Height:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
    self.graphView1.addConstraints([pointerView1Left,pointerView1Right,pointerView1Top])
    self.pointerView1.addConstraint(pointerView1Height)
    
    //Create and set constraints for pointerView2
    
    self.pointerView2.translatesAutoresizingMaskIntoConstraints = false
    
    let pointerView2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
    let pointerView2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let pointerView2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView2, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    let pointerView2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.pointerView2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
    self.graphView2.addConstraints([pointerView2Left,pointerView2Right,pointerView2Top])
    self.pointerView2.addConstraint(pointerView2Height)
    
    //Create and set constraints for noData Labels
    self.noDataLabel.setConstraintsToSuperview(Int(self.minorMargin), bottom: 0, left: 0, right: 0)
    self.noDataLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
    self.noDataLabel.addSubview(self.noDataUILabel)
    self.noDataUILabel.setConstraintsToSuperview(25, bottom: 10, left: 5, right: 5)
    self.noDataUILabel.text = "Select a test from the Menu"
    self.noDataUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
    let textSize2:CGFloat = self.view.getTextSize(14)
    self.noDataUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
    self.noDataUILabel.textAlignment = NSTextAlignment.Center
    self.noDataUILabel.numberOfLines = 0
    self.noDataLabel.alpha = 0
    self.statisticsTitleView.alpha = 0.0
    self.graphView1.alpha = 0.0
    self.graphView2.alpha = 0.0
    self.noDataLabel.alpha = 1.0
    
    // Create and add constraints for tutorialView
    
    self.tutorialView.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let tutorialViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
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
    
  }
  
  func showTestTypesBackgroundView() {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.backButton.alpha = 1
      self.statisticsBackgroundView.alpha = 1
      self.testTypesBackgroundView.alpha = 1
      //self.testTypesBackgroundViewTopConstraint.constant = self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5)) + self.minorMargin
      self.view.layoutIfNeeded()
      
    }, completion: nil)
    
  }
  
  func hideTestTypesBackgroundView(sender: UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.backButton.alpha = 0
      self.statisticsBackgroundView.alpha = 0
      self.testTypesBackgroundView.alpha = 0
      //self.testTypesBackgroundViewTopConstraint.constant = self.screenFrame.height
      self.view.layoutIfNeeded()
      
      }, completion:{(Bool) in
        
        if sender == self.backButton {
          self.performSegueWithIdentifier("backFromStatistics", sender: self.backButton)
        }
    
    })
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "backFromStatistics" {
      let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
      destinationVC.segueFromLoginView = false
    }
    
  }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        self.pointerView1.alpha = 1.0
        self.pointerView2.alpha = 1.0
        self.barChartText.text = "\(self.dateTests[entry.xIndex]) - \(round(entry.value))%"
        self.lineChartText.text = "\(self.dateTests[entry.xIndex]) - \(round(entry.value))s"
        self.pointerView1.moveLabelPointer((self.pointerView1.frame.width/6 * (CGFloat(entry.xIndex))) * 1.0150 + self.pointerView1.labelPointerBaseWidth)
        self.pointerView2.moveLabelPointer((self.pointerView2.frame.width/6 * (CGFloat(entry.xIndex))) * 1.100 + self.pointerView2.labelPointerBaseWidth/2)
    
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            self.statisticsTitleView.enablePrevious()
            self.statisticsTitleView.disableNext()
            self.statisticsTitleView.statisticsTitleLabel.text = "TIME PER QUESTION"
        } else {
            self.statisticsTitleView.enableNext()
            self.statisticsTitleView.disablePrevious()
            self.statisticsTitleView.statisticsTitleLabel.text = "SCORES"
        }
    }
    
    func nextStatButtonClicked(sender:UIButton) {
        self.statisticsTitleView.enablePrevious()
        self.statisticsTitleView.disableNext()
        self.statisticsScrollView.setContentOffset(self.graphView2.frame.origin, animated: true)
        self.statisticsTitleView.statisticsTitleLabel.text = "TIME PER QUESTION"
    }

    func previousStatButtonClicked(sender:UIButton) {
        self.statisticsTitleView.enableNext()
        self.statisticsTitleView.disablePrevious()
        self.statisticsScrollView.setContentOffset(self.graphView1.frame.origin, animated: true)
        self.statisticsTitleView.statisticsTitleLabel.text = "SCORES"
    }

    func dataDownload(sender:UIButton){
        
        var yUnits:[Double] = []
        var yUnits2:[Double] = []
        var dateTaken:[NSDate] = []
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle

        //parse
        if (sender.currentTitle == "Numerical Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_NUMREAS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_NUMREAS_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_NUMREAS_SCORE] as! Double)
                            yUnits2.append(object[PF_NUMREAS_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                    
                        }, subtitle: "Tap to dismiss")
                }
            }
            
        }else if (sender.currentTitle == "Verbal Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_VERBREAS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_VERBREAS_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_VERBREAS_SCORE] as! Double)
                            yUnits2.append(object[PF_VERBREAS_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }

            
        }else if (sender.currentTitle == "Arithmetic Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_ARITHMETIC_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_ARITHMETIC_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_ARITHMETIC_SCORE] as! Double)
                            yUnits2.append(object[PF_ARITHMETIC_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
            
        }else if (sender.currentTitle == "Logical Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_LOGICAL_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_LOGICAL_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_LOGICAL_SCORE] as! Double)
                            yUnits2.append(object[PF_LOGICAL_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
        }else if (sender.currentTitle == "Fractions"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_FRACTIONS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_FRACTIONS_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_FRACTIONS_SCORE] as! Double)
                            yUnits2.append(object[PF_FRACTIONS_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
        }else if (sender.currentTitle == "Sequences"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_SEQUENCE_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_SEQUENCE_USERNAME, equalTo: username!)
            query.limit = 6
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            yUnits.append(object[PF_SEQUENCE_SCORE] as! Double)
                            yUnits2.append(object[PF_SEQUENCE_TIME] as! Double)
                            dateTaken.append(object.createdAt as NSDate!)
                            print(yUnits)
                            print(yUnits2)
                            print(dateTaken)
                            
                        }
                    }
                    for element in dateTaken {
                        self.dateTests.append(formatter.stringFromDate(element))
                    }
                    SwiftSpinner.hide()
                    self.noDataUILabel.text = ""
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }


        }
    }

    func graphSetup(sender: UIButton, yUnits: [Double], yUnits2: [Double]) {
        
        //PointerViews
        self.pointerView1.alpha = 0.0
        self.pointerView2.alpha = 0.0
        
        if (yUnits.count==0) {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.noDataUILabel.text = "No Score Available"
                self.statisticsTitleView.alpha = 0.0
                self.graphView1.alpha = 0.0
                self.graphView2.alpha = 0.0
                self.noDataLabel.alpha = 1.0
                }, completion: nil)
            
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.statisticsTitleView.alpha = 1.0
                self.graphView1.alpha = 1.0
                self.graphView2.alpha = 1.0
                self.noDataLabel.alpha = 0
            }, completion: nil)
        
        //Set constraints
        self.statisticsScrollView.contentSize = CGSize(width: 2*self.statisticsScrollView.frame.width, height: 0)
        
        //Graph 1 - Test Scores
        let colors:[UIColor] = self.appVariablesModel.getAppColors()
        let xValues = ["T1","T2","T3","T4","T5","T6"]
        var dataEntries: [ChartDataEntry] = []
        var y:Int = 0
        
        //Graph 2 - Test Time
        let xValues2 = ["T1","T2","T3","T4","T5","T6"]
        var dataEntries2: [ChartDataEntry] = []
        var y2:Int = 0
        
        for y=0;y<yUnits.count;y++ {
            let dataEntry = BarChartDataEntry(value: round(yUnits[y]), xIndex: y)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Test Results")
        let chartData = BarChartData(xVals: xValues, dataSet: chartDataSet)
        self.chartObject.data = chartData
        
        self.chartObject.highlightValue(ChartHighlight(xIndex: 5, dataSetIndex: 0))
        chartDataSet.setColor(UIColor(white: 0.5, alpha: 0.5))
        chartDataSet.highlightColor = colors[sender.tag]
        chartDataSet.highlightAlpha = 1.0
        self.chartObject.descriptionText = ""
        chartData.setValueTextColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0))
        let textSize3:CGFloat = self.view.getTextSize(13)
        chartData.setValueFont(UIFont(name: "HelveticaNeue", size: textSize3))
        self.chartObject.xAxis.enabled = false
        self.chartObject.animate(xAxisDuration: 1.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        self.chartObject.legend.enabled = false
        self.chartObject.userInteractionEnabled = true
        self.chartObject.pinchZoomEnabled = false
        self.chartObject.doubleTapToZoomEnabled = false
        self.chartObject.leftAxis.enabled = false
        self.chartObject.rightAxis.enabled = false
        self.chartObject.gridBackgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.chartObject.drawHighlightArrowEnabled = false
        self.chartObject.drawValueAboveBarEnabled = true
        self.chartObject.dragEnabled = false
        
        self.barChartDescription.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.barChartText.textColor = UIColor.whiteColor()
        let textSize4:CGFloat = self.view.getTextSize(12)
        self.barChartText.font = UIFont(name: "Helvetica-NeueBold", size: textSize4)
        self.barChartText.textAlignment = NSTextAlignment.Center
        self.barChartText.text = "Select a test from the graph"
        
        for y2=0;y2<yUnits2.count;y2++ {
            let dataEntry = ChartDataEntry(value: round(yUnits2[y2]), xIndex: y2)
            dataEntries2.append(dataEntry)
        }
        
        let chartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "Test Time")
        let chartData2 = LineChartData(xVals: xValues2, dataSet: chartDataSet2)
        self.chartObject2.data = chartData2
        
        chartDataSet2.drawCubicEnabled = true
        chartDataSet2.cubicIntensity = 0.3
        chartDataSet2.drawCirclesEnabled = true
        chartDataSet2.lineWidth = 2.0
        chartDataSet2.fillColor = colors[sender.tag]
        chartDataSet2.drawHorizontalHighlightIndicatorEnabled = false
        chartDataSet2.setColor(colors[sender.tag])
        chartDataSet2.setCircleColor(colors[sender.tag])
        chartDataSet2.drawFilledEnabled = true
        chartDataSet2.circleRadius = 4.0
        chartDataSet2.setCircleColor(colors[sender.tag])
        chartDataSet2.circleHoleColor = UIColor.whiteColor()
        
        self.chartObject2.descriptionText = ""
        chartData2.setValueTextColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0))
        chartData2.setValueFont(UIFont(name: "HelveticaNeue", size: 13.0))
        chartDataSet2.valueFormatter = NSNumberFormatter()
        chartDataSet2.valueFormatter?.minimumFractionDigits = 0
        self.chartObject2.xAxis.enabled = false
        self.chartObject2.animate(xAxisDuration: 1.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        self.chartObject2.legend.enabled = false
        self.chartObject2.userInteractionEnabled = true
        self.chartObject2.pinchZoomEnabled = false
        self.chartObject2.doubleTapToZoomEnabled = false
        self.chartObject2.leftAxis.enabled = false
        self.chartObject2.rightAxis.enabled = false
        self.chartObject2.gridBackgroundColor = UIColor(white: 1.0, alpha: 0.0)
        self.chartObject2.dragEnabled = false
        
        self.lineChartDescription.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.lineChartText.textColor = UIColor.whiteColor()
        self.lineChartText.font = UIFont(name: "Helvetica-NeueBold", size: 12.0)
        self.lineChartText.textAlignment = NSTextAlignment.Center
        self.lineChartText.text = "Select a test from the graph"
        }
        //Menu - Buttons background
        
        for button in self.testTypeButtons {
            if button.tag == sender.tag {
                self.testTypeButtons[button.tag].backgroundColor = UIColor(white: 0.5, alpha: 0.5)
                self.selectedTest = sender.currentTitle!
                print(self.selectedTest)
            }
            else {
                self.testTypeButtons[button.tag].backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            }
        }
    }
  
  func showTutorial() {
    
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.tutorialView.alpha = 1
      self.tutorialNextButton.alpha = 1
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        self.view.insertSubview(self.tutorialViews[0], aboveSubview: self.tutorialView)
        
    })
  }
  
  func nextTutorialButtonClicked(sender:UIButton) {
    
    self.tutorialPageNumber++
    
    if self.tutorialViews[self.tutorialPageNumber - 1] == self.backButton {
      self.performSegueWithIdentifier("backFromStatistics", sender: sender)
    }
    else {
      for var index:Int = 0 ; index < self.tutorialViews.count ; index++ {
        if index == self.tutorialPageNumber {
          self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialNextButton)
          self.tutorialViews[index].userInteractionEnabled = false
        }
        else {
          self.view.insertSubview(self.tutorialViews[index], belowSubview: self.tutorialView)
          self.tutorialViews[index].userInteractionEnabled = true
        }
      }
      if self.tutorialPageNumber == self.tutorialViews.count - 1 {
        self.tutorialNextButton.setTitle("Back Home", forState: UIControlState.Normal)
      }
    }
    
  }
    
    func clearStatsWarning(sender:UIButton){
        
        let alertView = SCLAlertView()
        
        if self.noDataUILabel.text == "No Score Available" {
            alertView.showTitle(
                "Don't Worry", // Title of view
                subTitle: "Statistics already deleted.", // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Close", // Optional button value, default: ""
                style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0x9B9B9B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
            alertView.showCloseButton = false
            
        }else{
        
        if sender == self.clearStatsButton {
            
            alertView.addButton("Ok", target:self, selector:Selector("clearParseStatistics:"))
            alertView.showTitle(
                "Clear All Statistics", // Title of view
                subTitle: "Are you sure? You will be unable to recover these.", // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
            alertView.showCloseButton = false
            
        }else{
            
            }
            
        }
        
    }
    
    func clearParseStatistics(sender: UIButton){
        
        if self.selectedTest == "Numerical Reasoning" {
            
            SwiftSpinner.show("Deleting selected statistics")
            let query = PFQuery(className: PF_NUMREAS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_NUMREAS_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    print("About to delete \(objects!.count) \(self.selectedTest) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }

            
        }else if (self.selectedTest == "Verbal Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_VERBREAS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_VERBREAS_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("About to delete \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                    
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
            
        }else if (self.selectedTest == "Arithmetic Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_ARITHMETIC_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_ARITHMETIC_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("About to delete \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
            
        }else if (self.selectedTest == "Logical Reasoning"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_LOGICAL_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_LOGICAL_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("About to delete \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
        }else if (self.selectedTest == "Fractions"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_FRACTIONS_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_FRACTIONS_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("About to delete \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
            
        }else if (self.selectedTest == "Sequences"){
            
            SwiftSpinner.show("Loading statistics")
            let query = PFQuery(className: PF_SEQUENCE_CLASS_NAME)
            let currentUser = PFUser.currentUser()!
            let username = currentUser.username
            query.whereKey(PF_SEQUENCE_USERNAME, equalTo: username!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    // The find succeeded.
                    print("About to delete \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                    }
                    
                    let yUnits:[Double] = []
                    let yUnits2:[Double] = []
                    SwiftSpinner.hide()
                    self.graphSetup(sender, yUnits: yUnits, yUnits2: yUnits2)
                } else {
                    // Log details of the failure
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        
                        }, subtitle: "Tap to dismiss")
                }
            }
        }

        
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
