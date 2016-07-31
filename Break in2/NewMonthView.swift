//
//  NewMonthView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 30/07/2016.
//  Copyright © 2016 Sangeet Shah. All rights reserved.
//

import UIKit

class NewMonthView: UIView {

  var daysOfTheWeek:[String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
  
  var daysOfTheWeekLabels:[UILabel] = [UILabel]()
  var dayButtons:[CalendarDayButton] = [CalendarDayButton]()
  
  let todaysDate:NSDate = NSDate()
  let userCalendar:NSCalendar = NSCalendar.currentCalendar()
  let dateFormatter:NSDateFormatter = NSDateFormatter()
  let dateComponents:NSDateComponents = NSDateComponents()
  var year:Int = 0
  var month:Int = 0
  var startingWeekday:Int = 0
  var numberOfDaysInMonth:Int = 0
  var numberOfDaysInPreviousMonth:Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Create daysOfTheWeek Labels
    
    for index:Int in 0.stride(to: self.daysOfTheWeek.count, by: 1) {
      
      let labelAtIndex:UILabel = UILabel()
      
      // Set daysOfTheWeekLabels properties and add as subview to self
      
      labelAtIndex.textAlignment = NSTextAlignment.Center
      labelAtIndex.textColor = UIColor.whiteColor()
      labelAtIndex.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1)
      labelAtIndex.text = self.daysOfTheWeek[index]
      
      self.addSubview(labelAtIndex)
      
      // Add label to daysOfTheWeekLabels array
      
      self.daysOfTheWeekLabels.append(labelAtIndex)
      
    }
    
    // Create dayButtons
    
    for i:Int in 0.stride(through: 5, by: 1) {
      for j:Int in 0.stride(through: 6, by: 1) {
        
        let dayButtonAtIndex:CalendarDayButton = CalendarDayButton()
        
        // Set dayButton properties and add as subview to self
        
        //dayButtonAtIndex.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        //dayButtonAtIndex.setTitle("1", forState: UIControlState.Normal)
        
        // Add gray background to weekends
        if j == 5 || j == 6 {
          dayButtonAtIndex.backgroundColor = UIColor.lightGrayColor()
        }
        
        // Add target
        dayButtonAtIndex.addTarget(self, action: #selector(NewMonthView.calendarDayButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(dayButtonAtIndex)
        
        // Add button to dayButtons array
        
        self.dayButtons.append(dayButtonAtIndex)
        
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func displayView() {
    
    // Get number of days in month and month starting day
    
    self.dateComponents.year = self.year
    self.dateComponents.month = self.month
    self.dateComponents.day = 1
    
    let date:NSDate = self.userCalendar.dateFromComponents(dateComponents)!
    self.numberOfDaysInMonth = self.userCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
    self.startingWeekday = self.userCalendar.component(NSCalendarUnit.Weekday, fromDate: date)
    
    // Get number of days in previous month to find date of last day of previous month
    
    self.dateComponents.year = self.year
    self.dateComponents.month = self.month - 1
    self.dateComponents.day = 1
    
    let date2:NSDate = self.userCalendar.dateFromComponents(dateComponents)!
    self.numberOfDaysInPreviousMonth = self.userCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date2).length
    
    // Set title and title colors for calendarDayButtons
    
    if self.startingWeekday == 1 {
      for index:Int in 0.stride(through: 5, by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (5 - index)), forState: UIControlState.Normal)
      }
      for index:Int in 6.stride(to: (self.startingWeekday + self.numberOfDaysInMonth + 5), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(index - 5), forState: UIControlState.Normal)
      }
      for index:Int in (self.startingWeekday + self.numberOfDaysInMonth + 5).stride(to: (7 * 6), by: 1){
        self.dayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth + 5) + 1), forState: UIControlState.Normal)
      }
    }
    else {
      for index:Int in 0.stride(to: (self.startingWeekday - 2), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (self.startingWeekday - 3 - index)), forState: UIControlState.Normal)
      }
      for index:Int in (self.startingWeekday - 2).stride(to: (self.startingWeekday + self.numberOfDaysInMonth - 2), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday - 3)), forState: UIControlState.Normal)
      }
      for index:Int in (self.startingWeekday + self.numberOfDaysInMonth - 2).stride(to: (7 * 6), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth - 2) + 1), forState: UIControlState.Normal)
      }
    }
    
    self.setConstraints()
    
    
    
    // Highlight today's date
    let todaysDay:Int = self.userCalendar.component(NSCalendarUnit.Day, fromDate: self.todaysDate)
    
    // Clear previously highlighted today' dates
    for dayButton in self.dayButtons {
      dayButton.today = false
    }
    
    if self.year == self.userCalendar.component(NSCalendarUnit.Year, fromDate: self.todaysDate) {
      if self.month == self.userCalendar.component(NSCalendarUnit.Month, fromDate: self.todaysDate) {
        
        if self.startingWeekday == 1 {
          self.dayButtons[todaysDay + 5].today = true
          self.dayButtons[todaysDay + 5].setNeedsDisplay()
        }
        else {
          self.dayButtons[todaysDay + self.startingWeekday - 3].today = true
          self.dayButtons[todaysDay + self.startingWeekday - 3].setNeedsDisplay()
        }
        
      }
    }

    for dayButton in self.dayButtons {
      dayButton.setNeedsDisplay()
    }
    
  }
  
  func setConstraints() {
    
    // Set constraints for daysOfTheWeekLabels
    
    for index:Int in 0.stride(to: self.daysOfTheWeekLabels.count, by: 1) {
      
      self.daysOfTheWeekLabels[index].translatesAutoresizingMaskIntoConstraints = false
      let daysOfTheWeekLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      let daysOfTheWeekLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/7)
      let daysOfTheWeekLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/7))
      
      if index == 0 {
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
      }
      else {
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.daysOfTheWeekLabels[index-1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
      }
      
      self.daysOfTheWeekLabels[index].addConstraints([daysOfTheWeekLabelWidthConstraint,daysOfTheWeekLabelHeightConstraint])
      self.addConstraints([daysOfTheWeekLabelTopConstraint])
      
    }
    
    // Set constraints for dayButtons
    
    for i:Int in 0.stride(through: 5, by: 1) {
      for j:Int in 0.stride(through: 6, by: 1) {
        self.dayButtons[(i * 7) + j].translatesAutoresizingMaskIntoConstraints = false
        
        let dayButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.frame.height/7) * CGFloat(i+1))
        
        let dayButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/7)
        
        let dayButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.height/7)
        
        self.dayButtons[(i * 7) + j].addConstraints([dayButtonWidthConstraint, dayButtonHeightConstraint])
        self.addConstraint(dayButtonTopConstraint)
        
        if j == 0 {
          
          let dayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
          
          self.addConstraint(dayButtonLeftConstraint)
          
        }
        else {
          
          let dayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.dayButtons[(i * 7) + j - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
          
          self.addConstraint(dayButtonLeftConstraint)
          
        }

      }
    }
  }
  
  func calendarDayButtonClicked(button:UIButton) {
    
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}