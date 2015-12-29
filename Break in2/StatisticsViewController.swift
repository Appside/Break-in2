//
//  StatisticsViewController.swift
//  Break in2
//
//  Created by Sangeet on 29/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
  
  // Declare and initialize types of careers
  
  var testTypes:[String] = [String]()
  var testColors:[String:UIColor] = [String:UIColor]()
  
  // Declare and initialize views and models
  
  let logoImageView:UIImageView = UIImageView()
  let backButton:UIButton = UIButton()
  let statisticsBackgroundView:UIView = UIView()
  let testTypesBackgroundView:UIView = UIView()
  let testTypesScrollView:UIScrollView = UIScrollView()
  var testTypeButtons:[CareerButton] = [CareerButton]()
  let scrollInfoLabel:UILabel = UILabel()
  let clearStatsButton:UIButton = UIButton()

  var testTypesBackgroundViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()

  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let backButtonHeight:CGFloat = UIScreen.mainScreen().bounds.width/12
  let menuButtonHeight:CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Add background image to HomeViewController's view
      
      self.view.addHomeBG()
      
      // Add subviews
      
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.backButton)
      self.view.addSubview(self.statisticsBackgroundView)
      self.view.addSubview(self.testTypesBackgroundView)
      self.testTypesBackgroundView.addSubview(self.scrollInfoLabel)
      self.testTypesBackgroundView.addSubview(self.testTypesScrollView)
      self.testTypesBackgroundView.addSubview(self.clearStatsButton)
      
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
        
        self.testTypeButtons[index].addTarget(self, action: "testTypeClicked:", forControlEvents: UIControlEvents.TouchUpInside)
      }
      
      // Customize views
      
      self.testTypesBackgroundView.backgroundColor = UIColor.whiteColor()
      self.testTypesBackgroundView.layer.cornerRadius = self.minorMargin
      self.testTypesBackgroundView.alpha = 1
      self.testTypesBackgroundView.clipsToBounds = true
      
      self.statisticsBackgroundView.backgroundColor = UIColor.whiteColor()
      self.statisticsBackgroundView.layer.cornerRadius = self.minorMargin
      self.statisticsBackgroundView.alpha = 0
      self.statisticsBackgroundView.clipsToBounds = true
      
      self.testTypesScrollView.showsVerticalScrollIndicator = false
      
      // Customize imageViews
      
      self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
      
      // Customize buttons
      
      self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
      self.backButton.addTarget(self, action: "hideTestTypesBackgroundView:", forControlEvents: UIControlEvents.TouchUpInside)
      self.backButton.clipsToBounds = true
      self.backButton.alpha = 0
      
      self.clearStatsButton.backgroundColor = UIColor.turquoiseColor()
      self.clearStatsButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
      self.clearStatsButton.setTitle("Clear Selected Test Statistics", forState: UIControlState.Normal)
      self.clearStatsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
      
      self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
      self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
      self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
      self.scrollInfoLabel.text = "Scroll For More Tests"
      
      // Set contraints
      
      self.setConstraints()

        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // Show screen with animation

    self.showTestTypesBackgroundView()
    
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
    
    // Create and add constraints for testTypesBackgroundView
    
    self.testTypesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypesBackgroundViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.minorMargin * 7) + (self.menuButtonHeight * 4.5))
    
    let testTypesBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let testTypesBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    self.testTypesBackgroundViewTopConstraint = NSLayoutConstraint.init(item: self.testTypesBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.screenFrame.height)
    
    self.testTypesBackgroundView.addConstraint(testTypesBackgroundViewHeightConstraint)
    self.view.addConstraints([testTypesBackgroundViewRightConstraint, testTypesBackgroundViewLeftConstraint, self.testTypesBackgroundViewTopConstraint])
    
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

  }
  
  func showTestTypesBackgroundView() {
    
    UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      
      self.backButton.alpha = 1
      self.statisticsBackgroundView.alpha = 1
      self.testTypesBackgroundViewTopConstraint.constant = self.screenFrame.height - ((self.minorMargin * 7) + (self.menuButtonHeight * 4.5)) + self.minorMargin
      self.view.layoutIfNeeded()
      
    }, completion: nil)
    
  }
  
  func hideTestTypesBackgroundView(sender: UIButton) {
    
    UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      
      self.backButton.alpha = 0
      self.statisticsBackgroundView.alpha = 0
      self.testTypesBackgroundViewTopConstraint.constant = self.screenFrame.height
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
