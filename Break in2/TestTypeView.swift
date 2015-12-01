//
//  TestTypeView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 12/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class TestTypeView: UIView {
  
  // Declare and initialize types of tests array and index in super.testTypeViews
  
  var testTypes:[String] = [String]()
  var testDifficulties:[String] = [String]()
  var testTypeViewsIndex:Int = Int()
  
  // Declare and initialize subviews
  
  let testTypeTitleLabel:UILabel = UILabel()
  let testTypeTimeLabel:UILabel = UILabel()
  
  let testTypeDifficultyView:UIView = UIView()
  var testTypeDifficultyButtons:[UIButton] = [UIButton]()
  
  let testTypeStatsView:UIView = UIView()
  
  // Declare and initialize design constants to default values
  
  var majorMargin:CGFloat = CGFloat()
  var minorMargin:CGFloat = CGFloat()
  
  var mainLineColor:UIColor = UIColor()
  var mainBackgroundColor:UIColor = UIColor()
  var secondaryBackgroundColor:UIColor = UIColor()
  
  var testTypeTitleLabelHeight:CGFloat = CGFloat()
  var testTypeTimeLabelHeight:CGFloat = CGFloat()
  var testTypeDifficultyViewHeight:CGFloat = CGFloat()
  var testTypeStatsViewHeight:CGFloat = CGFloat()
  
  var testTypeDifficultyButtonHeight:CGFloat = CGFloat()
  var testTypeStatsViewHeightAfterSwipe:CGFloat = CGFloat()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews to testTypeView (testTypeStatsView must be behind the other subviews)
    
    self.addSubview(self.testTypeStatsView)
    self.addSubview(self.testTypeDifficultyView)
    self.addSubview(self.testTypeTitleLabel)
    self.addSubview(self.testTypeTimeLabel)
    
    // Set testTypeTitleLabel and testTypeTimeLabel characteristics
    
    self.testTypeTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
    self.testTypeTitleLabel.textColor = UIColor.turquoiseColor()
    self.testTypeTitleLabel.textAlignment = NSTextAlignment.Center
    //self.testTypeTitleLabel.layer.borderWidth = 2
    //self.testTypeTitleLabel.layer.borderColor = UIColor.blueColor().CGColor
    
    self.testTypeTimeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    self.testTypeTimeLabel.textColor = UIColor.turquoiseColor()
    self.testTypeTimeLabel.textAlignment = NSTextAlignment.Center
    //self.testTypeTimeLabel.layer.borderWidth = 2
    //self.testTypeTimeLabel.layer.borderColor = UIColor.redColor().CGColor

  
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayView() {
    
    self.testTypeTitleLabel.text = self.testTypes[testTypeViewsIndex]
    
    self.testTypeTimeLabel.text = "30 minutes"
    
    // Create testTypeDifficultyButtons for each testDifficulty
    
    for var index:Int = 0 ; index < self.testDifficulties.count ; index++ {
      
      let difficultyButton:UIButton = UIButton(type: UIButtonType.System)
      
      difficultyButton.setTitle(self.testDifficulties[index], forState: UIControlState.Normal)
      
      difficultyButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
      difficultyButton.setTitleColor(self.mainLineColor, forState: UIControlState.Normal)
      difficultyButton.layer.borderWidth = 1
      difficultyButton.layer.borderColor = self.mainLineColor.CGColor
      difficultyButton.layer.cornerRadius = self.testTypeDifficultyButtonHeight / 2
      
      difficultyButton.addTarget(self, action: Selector("difficultyButtonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
      
      self.testTypeDifficultyButtons.append(difficultyButton)
      self.testTypeDifficultyView.addSubview(self.testTypeDifficultyButtons[index])
      
    }
    
    // Set constraints
    
    self.setConstraints()
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for testTypeTitleLabel
    
    self.testTypeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeTitleLabelTopConstraint = NSLayoutConstraint.init(item: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let testTypeTitleLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testTypeTitleLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testTypeTitleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeTitleLabelHeight)
    
    self.testTypeTitleLabel.addConstraint(testTypeTitleLabelHeightConstraint)
    self.addConstraints([testTypeTitleLabelTopConstraint, testTypeTitleLabelLeftConstraint, testTypeTitleLabelRightConstraint])
    
    // Create and add constraints for testTypeTimeLabel
    
    self.testTypeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeTimeLabelTopConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    let testTypeTimeLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testTypeTimeLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testTypeTimeLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeTimeLabelHeight)
    
    self.testTypeTimeLabel.addConstraint(testTypeTimeLabelHeightConstraint)
    self.addConstraints([testTypeTimeLabelTopConstraint, testTypeTimeLabelLeftConstraint, testTypeTimeLabelRightConstraint])
    
    // Create and add constraints for testTypeDifficultyView
    
    self.testTypeDifficultyView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeDifficultyViewTopConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    let testTypeDifficultyViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testTypeDifficultyViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testTypeDifficultyViewHeightConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeDifficultyViewHeight)
    
    self.testTypeDifficultyView.addConstraint(testTypeDifficultyViewHeightConstraint)
    self.addConstraints([testTypeDifficultyViewTopConstraint, testTypeDifficultyViewLeftConstraint, testTypeDifficultyViewRightConstraint])
    
    // Create and add constraints for testTypeStatsView
    
    self.testTypeStatsView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeStatsViewTopConstraint = NSLayoutConstraint.init(item: self.testTypeStatsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testTypeStatsViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeStatsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testTypeStatsViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeStatsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testTypeStatsViewHeightConstraint = NSLayoutConstraint.init(item: self.testTypeStatsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeStatsViewHeightAfterSwipe)
    
    self.testTypeStatsView.addConstraint(testTypeStatsViewHeightConstraint)
    self.addConstraints([testTypeStatsViewTopConstraint, testTypeStatsViewLeftConstraint, testTypeStatsViewRightConstraint])
    
    // Set constraints for each testTypeDifficultyButton
    
    for var index:Int = 0 ; index < self.testTypeDifficultyButtons.count ; index++ {
      
      self.testTypeDifficultyButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let testTypeDifficultyButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
      
      let leftmostDifficultyButtonXDistance:CGFloat = (self.testTypeDifficultyButtonHeight * CGFloat(self.testDifficulties.count) / 2) + (CGFloat(self.testDifficulties.count - 1) * self.minorMargin)
      let difficultyButtonSpacing:CGFloat = (CGFloat(index) * (self.testTypeDifficultyButtonHeight + (2 * self.minorMargin)))
      let testTypeDifficultyButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeDifficultyView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: (leftmostDifficultyButtonXDistance * -1)  + difficultyButtonSpacing)
      
      let testTypeDifficultyButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeDifficultyButtonHeight)
      
      let testTypeDifficultyButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeDifficultyButtonHeight)
      
      self.testTypeDifficultyButtons[index].addConstraints([testTypeDifficultyButtonWidthConstraint, testTypeDifficultyButtonHeightConstraint])
      self.addConstraints([testTypeDifficultyButtonTopConstraint, testTypeDifficultyButtonLeftConstraint])
      
    }
    
  }
  
  func difficultyButtonTapped(sender: UIButton!) {
    
    for button:UIButton in self.testTypeDifficultyButtons {
      
      button.backgroundColor = self.backgroundColor
      button.setTitleColor(self.mainLineColor, forState: UIControlState.Normal)
      
    }
    
    sender.backgroundColor = self.secondaryBackgroundColor
    sender.setTitleColor(self.mainBackgroundColor, forState: UIControlState.Normal)
    
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
