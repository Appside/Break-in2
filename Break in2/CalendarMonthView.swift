//
//  CalendarMonthView.swift
//  Break in2
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit
import SwiftSpinner
import ParseUI
import Parse

protocol CalendarMonthViewDelegate {
  
  //func getJobDeadlinesForMonth(month:Int, year:Int) -> [[String:AnyObject]]
  func calendarDayButtonClicked(_ sender: CalendarDayButton)
  
}

class CalendarMonthView: UIView {
  
  var delegate:CalendarMonthViewDelegate?
  
  var daysOfTheWeek:[String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
  
  var daysOfTheWeekLabels:[UILabel] = [UILabel]()
  var dayButtons:[CalendarDayButton] = [CalendarDayButton]()
  
  let todaysDate:Date = Date()
  let userCalendar:Calendar = Calendar.current
  let dateFormatter:DateFormatter = DateFormatter()
  var dateComponents:DateComponents = DateComponents()
  var year:Int = 0
  var month:Int = 0
  var startingWeekday:Int = 0
  var numberOfDaysInMonth:Int = 0
  var numberOfDaysInPreviousMonth:Int = 0
  var deadlines:[[String:AnyObject]] = [[String:AnyObject]]()
  var chosenCareers:[String] = [String]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Create daysOfTheWeek Labels
    
    for index:Int in stride(from: 0, to: self.daysOfTheWeek.count, by: 1) {
      
      let labelAtIndex:UILabel = UILabel()
      
      // Set daysOfTheWeekLabels properties and add as subview to self
      
      labelAtIndex.textAlignment = NSTextAlignment.center
      labelAtIndex.textColor = UIColor.white
      labelAtIndex.font = UIFont(name: "HelveticaNeue-Medium", size: self.getTextSize(15))
      labelAtIndex.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1)
      labelAtIndex.text = self.daysOfTheWeek[index]
      
      self.addSubview(labelAtIndex)
      
      // Add label to daysOfTheWeekLabels array
      
      self.daysOfTheWeekLabels.append(labelAtIndex)
      
    }
    
    // Create dayButtons
    
    for _:Int in stride(from: 0, through: 5, by: 1) {
      for j:Int in stride(from: 0, through: 6, by: 1) {
        
        let dayButtonAtIndex:CalendarDayButton = CalendarDayButton()
        
        // Set dayButton properties and add as subview to self
        
        dayButtonAtIndex.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: self.getTextSize(14))
        
        // Add gray background to weekends
        if j == 5 || j == 6 {
          dayButtonAtIndex.backgroundColor = UIColor.lightGray
        }
        
        // Add target
        dayButtonAtIndex.addTarget(self, action: #selector(CalendarMonthView.calendarDayButtonClicked(_:)), for: UIControlEvents.touchUpInside)
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
    
    let date:Date = self.userCalendar.date(from: dateComponents)!
    self.numberOfDaysInMonth = (self.userCalendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date).length
    self.startingWeekday = (self.userCalendar as NSCalendar).component(NSCalendar.Unit.weekday, from: date)
    
    // Get number of days in previous month to find date of last day of previous month
    
    self.dateComponents.year = self.year
    self.dateComponents.month = self.month - 1
    self.dateComponents.day = 1
    
    let date2:Date = self.userCalendar.date(from: dateComponents)!
    self.numberOfDaysInPreviousMonth = (self.userCalendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date2).length
    
    // Set title and title colors for calendarDayButtons
    
    if self.startingWeekday == 1 {
      for index:Int in stride(from: 0, through: 5, by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.gray, for: UIControlState())
        self.dayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (5 - index)), for: UIControlState())
      }
      for index:Int in stride(from: 6, to: (self.startingWeekday + self.numberOfDaysInMonth + 5), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.black, for: UIControlState())
        self.dayButtons[index].setTitle(String(index - 5), for: UIControlState())
        self.dayButtons[index].year = self.year
        self.dayButtons[index].month = self.month
        self.dayButtons[index].day = index - 5
      }
      for index:Int in stride(from: (self.startingWeekday + self.numberOfDaysInMonth + 5), to: (7 * 6), by: 1){
        self.dayButtons[index].setTitleColor(UIColor.gray, for: UIControlState())
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth + 5) + 1), for: UIControlState())
      }
    }
    else {
      for index:Int in stride(from: 0, to: (self.startingWeekday - 2), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.gray, for: UIControlState())
        self.dayButtons[index].setTitle(String(self.numberOfDaysInPreviousMonth - (self.startingWeekday - 3 - index)), for: UIControlState())
      }
      for index:Int in stride(from: (self.startingWeekday - 2), to: (self.startingWeekday + self.numberOfDaysInMonth - 2), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.black, for: UIControlState())
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday - 3)), for: UIControlState())
        self.dayButtons[index].year = self.year
        self.dayButtons[index].month = self.month
        self.dayButtons[index].day = index - (self.startingWeekday - 3)
      }
      for index:Int in stride(from: (self.startingWeekday + self.numberOfDaysInMonth - 2), to: (7 * 6), by: 1) {
        self.dayButtons[index].setTitleColor(UIColor.gray, for: UIControlState())
        self.dayButtons[index].setTitle(String(index - (self.startingWeekday + self.numberOfDaysInMonth - 2) + 1), for: UIControlState())
      }
    }
    
    self.setConstraints()
    
    // Highlight today's date
    let todaysDay:Int = (self.userCalendar as NSCalendar).component(NSCalendar.Unit.day, from: self.todaysDate)
    
    // Clear previously highlighted dates
    for dayButton in self.dayButtons {
      dayButton.today = false
      dayButton.clicked = false
    }
    
    if self.year == (self.userCalendar as NSCalendar).component(NSCalendar.Unit.year, from: self.todaysDate) {
      if self.month == (self.userCalendar as NSCalendar).component(NSCalendar.Unit.month, from: self.todaysDate) {
        
        if self.startingWeekday == 1 {
          self.dayButtons[todaysDay + 5].today = true
        }
        else {
          self.dayButtons[todaysDay + self.startingWeekday - 3].today = true
        }
        
      }
    }
    
    for dayButton in self.dayButtons {
      dayButton.setNeedsDisplay()
    }
    
    // Get deadline dates
    
    //    if let unwrappedDelegate = self.delegate {
    //        self.deadlines = unwrappedDelegate.getJobDeadlinesForMonth(self.month, year: self.year)
    //    }
    
    // Display dates with deadlines
    
    for dayButton in dayButtons {
        
        dayButton.deadlines.removeAll()
        
    }
    
    for index:Int in stride(from: 0, to: self.deadlines.count, by: 1) {
      
      let deadline:[String:AnyObject] = self.deadlines[index]
      
      let day:Int = deadline["day"] as! Int
      let company:String = deadline["company"] as! String
      let career:String = deadline["career"] as! String
      let position:String = deadline["position"] as! String
      
      if self.startingWeekday == 1 {
        
        self.dayButtons[day + 5].clicked = true
        self.dayButtons[day + 5].deadlines.append([company,career,position])
        
      }
      else {
        
        self.dayButtons[day + self.startingWeekday - 3].clicked = true
        self.dayButtons[day + self.startingWeekday - 3].deadlines.append([company,career,position])
        
      }
      
    }
    
  }
  
  func setConstraints() {
    
    // Set constraints for daysOfTheWeekLabels
    
    for index:Int in stride(from: 0, to: self.daysOfTheWeekLabels.count, by: 1) {
      
      self.daysOfTheWeekLabels[index].translatesAutoresizingMaskIntoConstraints = false
      let daysOfTheWeekLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
      let daysOfTheWeekLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/7)
      let daysOfTheWeekLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/7))
      
      if index == 0 {
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
      }
      else {
        let daysOfTheWeekLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.daysOfTheWeekLabels[index], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.daysOfTheWeekLabels[index-1], attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        self.addConstraint(daysOfTheWeekLabelLeftConstraint)
      }
      
      self.daysOfTheWeekLabels[index].addConstraints([daysOfTheWeekLabelWidthConstraint,daysOfTheWeekLabelHeightConstraint])
      self.addConstraints([daysOfTheWeekLabelTopConstraint])
      
    }
    
    // Set constraints for dayButtons
    
    for i:Int in stride(from: 0, through: 5, by: 1) {
      for j:Int in stride(from: 0, through: 6, by: 1) {
        self.dayButtons[(i * 7) + j].translatesAutoresizingMaskIntoConstraints = false
        
        let dayButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.frame.height/7) * CGFloat(i+1))
        
        let dayButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/7)
        
        let dayButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height/7)
        
        self.dayButtons[(i * 7) + j].addConstraints([dayButtonWidthConstraint, dayButtonHeightConstraint])
        self.addConstraint(dayButtonTopConstraint)
        
        if j == 0 {
          
          let dayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
          
          self.addConstraint(dayButtonLeftConstraint)
          
        }
        else {
          
          let dayButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.dayButtons[(i * 7) + j], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.dayButtons[(i * 7) + j - 1], attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
          
          self.addConstraint(dayButtonLeftConstraint)
          
        }
        
      }
    }
    
  }
  
  func calendarDayButtonClicked(_ sender:CalendarDayButton) {
    
    self.delegate?.calendarDayButtonClicked(sender)
    
    /*if sender.clicked {
     sender.clicked = false
     sender.setNeedsDisplay()
     }
     else {
     sender.clicked = true
     sender.drawCircle(3)
     }*/
    
    
  }
  /*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func drawRect(rect: CGRect) {
   // Drawing code
   }
   */
  
}
