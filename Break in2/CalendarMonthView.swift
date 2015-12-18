//
//  CalendarMonthView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarMonthView: UIView {
  
  let calendarDaysTitleView:CalendarDaysTitleView = CalendarDaysTitleView()
  var calendarDayButtons:[CalendarDayButton] = [CalendarDayButton]()
  
  let todaysDate:NSDate = NSDate()
  let userCalendar:NSCalendar = NSCalendar.currentCalendar()
  let dateFormatter:NSDateFormatter = NSDateFormatter()
  let dateComponents:NSDateComponents = NSDateComponents()
  var year:Int = 0
  var month:Int = 0
  var startingWeekday:Int = 0
  var numberOfDaysInMonth:Int = 0
  var numberOfDaysInPreviousMonth:Int = 0
  
  var columnWidth:CGFloat = 0
  var rowHeight:CGFloat = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subview
    
    self.addSubview(self.calendarDaysTitleView)
    
    // Create calendarDayButtons for each day
    
    for var i:Int = 0 ; i <= 5 ; i++ {
      
      for var j:Int = 0 ; j <= 6 ; j++ {
        
        let calendarDayButtonAtIndex:CalendarDayButton = CalendarDayButton()
        
        // Add as a subview
        
        self.addSubview(calendarDayButtonAtIndex)
        
        // Add background to weekends
        
        if j == 5 || j == 6 {
          calendarDayButtonAtIndex.backgroundColor = UIColor.lightGrayColor()
        }
        
        // Add target
        
        calendarDayButtonAtIndex.addTarget(self, action: "calendarDayButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Store each calendarDayButton in calendarDayButtons array
        
        self.calendarDayButtons.append(calendarDayButtonAtIndex)

      }
      
    }
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayView(columnWidth:CGFloat, rowHeight:CGFloat) {
    
    self.columnWidth = columnWidth
    self.rowHeight = rowHeight
    
    // Get number of days in month and month starting day
    
    self.dateComponents.year = self.year
    self.dateComponents.month = self.month
    self.dateComponents.day = 1
    
    let date:NSDate = self.userCalendar.dateFromComponents(dateComponents)!
    self.numberOfDaysInMonth = self.userCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
    self.startingWeekday = self.userCalendar.component(NSCalendarUnit.Weekday, fromDate: date)
    
    // Get number of days in previous month
    
    self.dateComponents.year = self.year
    self.dateComponents.month = self.month - 1
    self.dateComponents.day = 1
    
    let date2:NSDate = self.userCalendar.dateFromComponents(dateComponents)!
    self.numberOfDaysInPreviousMonth = self.userCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date2).length
    
    // Set title and title colors for calendarDayButtons
    
    if self.startingWeekday == 1 {
      for var index:Int = 0 ; index <= 5 ; index++ {
        self.calendarDayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.calendarDayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (5 - index)), forState: UIControlState.Normal)
      }
      for var index:Int = 6 ; index < (self.startingWeekday + self.numberOfDaysInMonth + 5) ; index++ {
        self.calendarDayButtons[index].setTitle(String(index - 5), forState: UIControlState.Normal)
      }
      for var index:Int = (self.startingWeekday + self.numberOfDaysInMonth + 5) ; index < (7 * 6) ; index++ {
        self.calendarDayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.calendarDayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth + 5) + 1), forState: UIControlState.Normal)
      }
    }
    else {
      for var index:Int = 0 ; index < (self.startingWeekday - 2) ; index++ {
        self.calendarDayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.calendarDayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (self.startingWeekday - 3 - index)), forState: UIControlState.Normal)
      }
      for var index:Int = (self.startingWeekday - 2) ; index < (self.startingWeekday + self.numberOfDaysInMonth - 2) ; index++ {
        self.calendarDayButtons[index].setTitle(String(index - (self.startingWeekday - 3)), forState: UIControlState.Normal)
      }
      for var index:Int = (self.startingWeekday + self.numberOfDaysInMonth - 2) ; index < (7 * 6) ; index++ {
        self.calendarDayButtons[index].setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.calendarDayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth - 2) + 1), forState: UIControlState.Normal)
      }
    }
    
    // Set constraints
    
    self.setConstraints()
    
    // Display views
    
    self.calendarDaysTitleView.displayView(self.columnWidth * 7)
    
    if self.year == self.userCalendar.component(NSCalendarUnit.Year, fromDate: self.todaysDate) {
      if self.month == self.userCalendar.component(NSCalendarUnit.Month, fromDate: self.todaysDate) {
        
        let todaysDay:Int = self.userCalendar.component(NSCalendarUnit.Day, fromDate: self.todaysDate)
        self.calendarDayButtons[todaysDay].today = true
        //self.calendarDayButtons[todaysDay - 1].setNeedsDisplay()
        
      }
    }
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for calendarDaysTitleView
    
    self.calendarDaysTitleView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarDaysTitleViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDaysTitleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let calendarDaysTitleViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDaysTitleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let calendarDaysTitleViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDaysTitleView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let calendarDaysTitleViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDaysTitleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight)
    
    self.calendarDaysTitleView.addConstraint(calendarDaysTitleViewHeightConstraint)
    self.addConstraints([calendarDaysTitleViewTopConstraint, calendarDaysTitleViewLeftConstraint, calendarDaysTitleViewRightConstraint])
    
    // Create and add constraints for each calendarDayButton in the calendarDayButtons array
    
    for var i:Int = 0 ; i <= 5 ; i++ {
      
      for var j:Int = 0 ; j <= 6 ; j++ {
        
        self.calendarDayButtons[(i * 7) + j].translatesAutoresizingMaskIntoConstraints = false
        
        let calendarDayButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarDaysTitleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.rowHeight * CGFloat(i))
        
        let calendarDayButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.columnWidth)
        
        let calendarDayButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight)
        
        self.calendarDayButtons[(i * 7) + j].addConstraints([calendarDayButtonWidthConstraint, calendarDayButtonHeightConstraint])
        self.addConstraint(calendarDayButtonTopConstraint)
        
        if j == 0 {
          
          let calendarDayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
          
          self.addConstraint(calendarDayButtonLeftConstraint)
          
        }
        else {
          
          let calendarDayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarDayButtons[(i * 7) + j], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarDayButtons[(i * 7) + j - 1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
          
          self.addConstraint(calendarDayButtonLeftConstraint)
          
        }
        
      }
      
    }

  }
  
  func calendarDayButtonClicked(sender:CalendarDayButton) {
    
    if sender.clicked {
      sender.clicked = false
      sender.setNeedsDisplay()
    }
    else {
      sender.clicked = true
      sender.drawCircle(3)
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
