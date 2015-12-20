//
//  CalendarDaysOfTheWeekView.swift
//  Break in2
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarDaysTitleView: UIView {

  var daysOfTheWeek:[String] = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
  
  var daysOfTheWeekLabels:[UILabel] = [UILabel]()
  
  var calendarWidth:CGFloat = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1)
    
    for var index:Int = 0 ; index < self.daysOfTheWeek.count ; index++ {
      
      let labelAtIndex:UILabel = UILabel()
      
      labelAtIndex.textAlignment = NSTextAlignment.Center
      labelAtIndex.textColor = UIColor.whiteColor()
      labelAtIndex.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
      labelAtIndex.text = self.daysOfTheWeek[index]
      
      // Add labels as subviews
      
      self.addSubview(labelAtIndex)
      
      // Add label to daysOfTheWeekLabels array
      
      self.daysOfTheWeekLabels.append(labelAtIndex)
      
    }
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayView(calendarWidth:CGFloat) {
    
    self.calendarWidth = calendarWidth
    
    // Set constraints
    
    self.setConstraints()
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for each daysOfTheWeekLabel
    
    for var index:Int = 0 ; index < self.daysOfTheWeekLabels.count ; index++ {
      
      self.daysOfTheWeekLabels[index].translatesAutoresizingMaskIntoConstraints = false
      
      let daysOfTheWeekLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      
      let daysOfTheWeekLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
      
      let daysOfTheWeekLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.calendarWidth / CGFloat(self.daysOfTheWeek.count))
      
      self.daysOfTheWeekLabels[index].addConstraint(daysOfTheWeekLabelWidthConstraint)
      self.addConstraints([daysOfTheWeekLabelTopConstraint, daysOfTheWeekLabelBottomConstraint])
      
      if index == 0 {
        
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
        
      }
      else {
        
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.daysOfTheWeekLabels[index - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
        
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
