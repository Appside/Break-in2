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
  
  var testType:String = String()
  var comingSoonTestTypes:[String] = [String]()
  var testDifficulties:[String] = [String]()
  
  // Declare and initialize subviews
  
  let testTypeTitleLabel:UILabel = UILabel()
  let testTypeTimeLabel:UILabel = UILabel()
  
  let testTypeDifficultyView:UIView = UIView()
  var testTypeDifficultyButtons:[UIButton] = [UIButton]()
  
  var difficultySelected:String = String()
  
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
    
    self.addSubview(self.testTypeDifficultyView)
    self.addSubview(self.testTypeTitleLabel)
    self.addSubview(self.testTypeTimeLabel)
    
    // Set testTypeTitleLabel and testTypeTimeLabel characteristics
    let textSize:CGFloat = self.getTextSize(20)
    self.testTypeTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    self.testTypeTitleLabel.textColor = UIColor.turquoiseColor()
    self.testTypeTitleLabel.textAlignment = NSTextAlignment.Center
    
    let textSize2:CGFloat = self.getTextSize(16)
    self.testTypeTimeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
    self.testTypeTimeLabel.textColor = UIColor.turquoiseColor()
    self.testTypeTimeLabel.textAlignment = NSTextAlignment.Center
    
    self.difficultySelected = "E"
      
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayView() {
    
    self.testTypeTitleLabel.text = self.testType
    
    //self.testTypeTimeLabel.text = "30 minutes"
    
    // Create testTypeDifficultyButtons for each testDifficulty
    
    for index:Int in 0..<self.testDifficulties.count {
      
      let difficultyButton:UIButton = UIButton(type: UIButtonType.System)
      
      difficultyButton.setTitle(self.testDifficulties[index], forState: UIControlState.Normal)
      
      let textSize3:CGFloat = self.getTextSize(15)
      difficultyButton.layer.borderWidth = 1
      difficultyButton.layer.borderColor = self.mainLineColor.CGColor
      difficultyButton.layer.cornerRadius = self.testTypeDifficultyButtonHeight / 2
      difficultyButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: textSize3)
      
      if index == 0 {
        difficultyButton.backgroundColor = self.secondaryBackgroundColor
        difficultyButton.setTitleColor(self.mainBackgroundColor, forState: UIControlState.Normal)
      }
      else {
        difficultyButton.setTitleColor(self.mainLineColor, forState: UIControlState.Normal)
      }
      
      difficultyButton.addTarget(self, action: #selector(TestTypeView.difficultyButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      
      self.testTypeDifficultyButtons.append(difficultyButton)
      self.testTypeDifficultyView.addSubview(self.testTypeDifficultyButtons[index])
      
    }
    
    if testTypeDifficultyButtons != [String]() {
      self.difficultyButtonTapped(self.testTypeDifficultyButtons[0])
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
    
    // Create and add constraints for testTypeDifficultyView
    
    self.testTypeDifficultyView.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeDifficultyViewTopConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeTitleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testTypeDifficultyViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let testTypeDifficultyViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let testTypeDifficultyViewHeightConstraint = NSLayoutConstraint.init(item: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeDifficultyViewHeight)
    
    self.testTypeDifficultyView.addConstraint(testTypeDifficultyViewHeightConstraint)
    self.addConstraints([testTypeDifficultyViewTopConstraint, testTypeDifficultyViewLeftConstraint, testTypeDifficultyViewRightConstraint])

    // Create and add constraints for testTypeTimeLabel
    
    self.testTypeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let testTypeTimeLabelTopConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.testTypeDifficultyView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let testTypeTimeLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let testTypeTimeLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let testTypeTimeLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.testTypeTimeLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.testTypeTimeLabelHeight)
    
    self.testTypeTimeLabel.addConstraint(testTypeTimeLabelHeightConstraint)
    self.addConstraints([testTypeTimeLabelTopConstraint, testTypeTimeLabelLeftConstraint, testTypeTimeLabelRightConstraint])
    
    // Set constraints for each testTypeDifficultyButton
    
    for index:Int in 0..<self.testTypeDifficultyButtons.count {
      
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
  
  func difficultyButtonTapped(sender: UIButton) {
    
    for button:UIButton in self.testTypeDifficultyButtons {
      
      button.backgroundColor = self.backgroundColor
      button.setTitleColor(self.mainLineColor, forState: UIControlState.Normal)
      
    }
    
    sender.backgroundColor = self.secondaryBackgroundColor
    sender.setTitleColor(self.mainBackgroundColor, forState: UIControlState.Normal)
    
    self.difficultySelected = sender.titleLabel!.text!
    
    if self.testType == "Help Us Add More Tests:" {
      self.testTypeTimeLabel.text = self.comingSoonTestTypes[self.testDifficulties.indexOf(sender.titleLabel!.text!)!]
    }
    else {
      if self.testType == "Numerical Reasoning" || self.testType == "Verbal Reasoning" {
        if self.difficultySelected == "E" {
          self.testTypeTimeLabel.text = "Easy (30 minutes)"
        }
        if self.difficultySelected == "M" {
          self.testTypeTimeLabel.text = "Medium (25 minutes)"
        }
        if self.difficultySelected == "H" {
          self.testTypeTimeLabel.text = "Hard (20 minutes)"
        }
      }
      else if self.testType == "Arithmetic Reasoning" {
        if self.difficultySelected == "E" {
          self.testTypeTimeLabel.text = "Easy (Operators: +, -)"
        }
        if self.difficultySelected == "M" {
          self.testTypeTimeLabel.text = "Medium (Operators: +, -, *)"
        }
        if self.difficultySelected == "H" {
          self.testTypeTimeLabel.text = "Hard (Operators: +, -, *, /)"
        }
      }
      else if self.testType == "Logical Reasoning" {
        if self.difficultySelected == "E" {
          self.testTypeTimeLabel.text = "Easy (20 minutes)"
        }
        if self.difficultySelected == "M" {
          self.testTypeTimeLabel.text = "Medium (15 minutes)"
        }
        if self.difficultySelected == "H" {
          self.testTypeTimeLabel.text = "Hard (10 minutes)"
        }
      }
      else if self.testType == "Sequences" {
        if self.difficultySelected == "E" {
          self.testTypeTimeLabel.text = "Easy (20 minutes)"
        }
        if self.difficultySelected == "M" {
          self.testTypeTimeLabel.text = "Medium (15 minutes)"
        }
        if self.difficultySelected == "H" {
          self.testTypeTimeLabel.text = "Hard (10 minutes)"
        }
      }
      else if self.testType == "Fractions" {
        if self.difficultySelected == "E" {
          self.testTypeTimeLabel.text = "Easy"
        }
        if self.difficultySelected == "M" {
          self.testTypeTimeLabel.text = "Medium"
        }
        if self.difficultySelected == "H" {
          self.testTypeTimeLabel.text = "Hard"
        }
      }
      else if self.testType == "Programming" {
        if self.difficultySelected == "E" {
            self.testTypeTimeLabel.text = "Easy (15 minutes)"
        }
        if self.difficultySelected == "M" {
            self.testTypeTimeLabel.text = "Medium (10 minutes)"
        }
        if self.difficultySelected == "H" {
            self.testTypeTimeLabel.text = "Hard (5 minutes)"
        }
        }
      else if self.testType == "Technology" {
        if self.difficultySelected == "E" {
            self.testTypeTimeLabel.text = "Easy (15 minutes)"
        }
        if self.difficultySelected == "M" {
            self.testTypeTimeLabel.text = "Medium (10 minutes)"
        }
        if self.difficultySelected == "H" {
            self.testTypeTimeLabel.text = "Hard (5 minutes)"
        }
        }
    }
    
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
