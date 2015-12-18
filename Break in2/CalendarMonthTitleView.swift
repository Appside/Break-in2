//
//  CalendarMonthTitleView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarMonthTitleView: UIView {
  
  let monthLabel:UILabel = UILabel()
  let nextMonthButton:UIButton = UIButton()
  let previousMonthButton:UIButton = UIButton()
  
  var year:Int = 0
  var month:Int = 0
  
  var calendarWidth:CGFloat = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.monthLabel)
    self.addSubview(self.nextMonthButton)
    self.addSubview(self.previousMonthButton)
    
    // Customize monthLabel
    
    self.monthLabel.textAlignment = NSTextAlignment.Center
    self.monthLabel.text = "Month"
    
    // Customize nextMonthButton and previousMonthButton
    
    self.nextMonthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
    self.nextMonthButton.setTitle("Next", forState: UIControlState.Normal)
    
    self.previousMonthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    self.previousMonthButton.setTitle("Previous", forState: UIControlState.Normal)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayView(calendarWidth:CGFloat) {
    
    self.calendarWidth = calendarWidth
    
    // Set constraints
    
    self.setConstraints()
    
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM"
    self.monthLabel.text = dateFormatter.monthSymbols[self.month - 1] + " " + String(self.year)
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for monthLabel
    
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let monthLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let monthLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let monthLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.calendarWidth/2)
    
    let monthLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.monthLabel.addConstraint(monthLabelWidthConstraint)
    self.addConstraints([monthLabelTopConstraint, monthLabelCenterXConstraint, monthLabelBottomConstraint])
    
    // Create and add constraints for nextMonthButton
    
    self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
    
    let nextMonthButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let nextMonthButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
    
    let nextMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.calendarWidth/4)
    
    let nextMonthButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.nextMonthButton.addConstraint(nextMonthButtonWidthConstraint)
    self.addConstraints([nextMonthButtonTopConstraint, nextMonthButtonRightConstraint, nextMonthButtonBottomConstraint])

    // Create and add constraints for previousMonthButton
    
    self.previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
    
    let previousMonthButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let previousMonthButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
    
    let previousMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.calendarWidth/4)
    
    let previousMonthButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.previousMonthButton.addConstraint(previousMonthButtonWidthConstraint)
    self.addConstraints([previousMonthButtonTopConstraint, previousMonthButtonLeftConstraint, previousMonthButtonBottomConstraint])

  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}