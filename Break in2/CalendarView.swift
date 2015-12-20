//
//  CalendarView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarView: UIView, UIScrollViewDelegate, CalendarMonthViewDelegate {
  
  // Declare and initialize jobDeadlines
  
  var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
  
  // Declare and initialize views and models
  
  let calendarModel:CalendarModel = CalendarModel()
  
  let calendarMonthTitleView:CalendarMonthTitleView = CalendarMonthTitleView()
  let calendarMonthsScrollView:UIScrollView = UIScrollView()
  var currentMonthView:CalendarMonthView = CalendarMonthView()
  var nextMonthView:CalendarMonthView = CalendarMonthView()
  var previousMonthView:CalendarMonthView = CalendarMonthView()
  let deadlinesView:UIView = UIView()
  
  let todaysDate:NSDate = NSDate()
  let userCalendar:NSCalendar = NSCalendar.currentCalendar()
  let dateFormatter:NSDateFormatter = NSDateFormatter()
  var currentYear = 0
  var currentMonth:Int = 0
  var nextMonth:Int = 0
  var previousMonth:Int = 0
  
  var rowHeight:CGFloat = 0
  var columnWidth:CGFloat = 0
  
  let minorMargin:CGFloat = 10
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.calendarMonthsScrollView.delegate = self
    
    self.currentYear = self.userCalendar.component(NSCalendarUnit.Year, fromDate: self.todaysDate)
    self.currentMonth = self.userCalendar.component(NSCalendarUnit.Month, fromDate: self.todaysDate)
    
    self.jobDeadlines = self.calendarModel.getJobDeadlines()
    
    // Add calendar subviews
    
    self.addSubview(self.calendarMonthTitleView)
    self.addSubview(self.calendarMonthsScrollView)
    self.addSubview(self.deadlinesView)
    
    self.calendarMonthsScrollView.addSubview(self.currentMonthView)
    self.calendarMonthsScrollView.addSubview(self.nextMonthView)
    self.calendarMonthsScrollView.addSubview(self.previousMonthView)
    
    // Customize subviews
    
    self.backgroundColor = UIColor.whiteColor()
    
    self.calendarMonthsScrollView.pagingEnabled = true
    self.calendarMonthsScrollView.showsHorizontalScrollIndicator = false
    self.calendarMonthsScrollView.setContentOffset(CGPointMake(self.calendarMonthsScrollView.frame.width, 0), animated: false)
    
    self.deadlinesView.backgroundColor = UIColor.whiteColor()
    self.deadlinesView.layer.cornerRadius = self.minorMargin
    self.deadlinesView.alpha = 0
    
    // Add tap gesture recognizer to deadlinesView
    
    let deadlinesViewTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "deadlinesViewTapped:")
    deadlinesViewTapRecognizer.numberOfTapsRequired = 1
    self.deadlinesView.addGestureRecognizer(deadlinesViewTapRecognizer)
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayCalendar() {
    
    superview?.layoutIfNeeded()
    self.rowHeight = self.frame.height/9
    self.columnWidth = self.frame.width/7
    
    // Remove calendarMonthViews from calendarMonthsScrollView
    
    self.currentMonthView.removeFromSuperview()
    self.previousMonthView.removeFromSuperview()
    self.nextMonthView.removeFromSuperview()
    
    // Reinitialize calendarMonthViews
    
    self.currentMonthView = CalendarMonthView()
    self.nextMonthView = CalendarMonthView()
    self.previousMonthView = CalendarMonthView()
    
    // Add new calendarMonthViews from calendarMonthsScrollView
    
    self.calendarMonthsScrollView.addSubview(self.currentMonthView)
    self.calendarMonthsScrollView.addSubview(self.nextMonthView)
    self.calendarMonthsScrollView.addSubview(self.previousMonthView)
    
    // Set calendarMonthView delegates
    
    self.currentMonthView.delegate = self
    self.nextMonthView.delegate = self
    self.previousMonthView.delegate = self
    
    // Set subview properties
    
    self.calendarMonthTitleView.year = self.currentYear
    self.calendarMonthTitleView.month = self.currentMonth
    
    self.currentMonthView.year = self.currentYear
    self.currentMonthView.month = self.currentMonth
    if self.currentMonth == 12 {
      self.previousMonthView.year = self.currentYear
      self.previousMonthView.month = 11
      self.nextMonthView.year = self.currentYear + 1
      self.nextMonthView.month = 1
    }
    else if self.currentMonth == 1 {
      self.previousMonthView.year = self.currentYear - 1
      self.previousMonthView.month = 12
      self.nextMonthView.year = self.currentYear
      self.nextMonthView.month = 2
    }
    else {
      self.previousMonthView.year = self.currentYear
      self.previousMonthView.month = self.currentMonth - 1
      self.nextMonthView.year = self.currentYear
      self.nextMonthView.month = self.currentMonth + 1
    }

    // Set constraints
    
    self.setConstraints()
    self.layoutIfNeeded()
    
    // Display subviews
    
    self.calendarMonthsScrollView.setContentOffset(CGPointMake(self.calendarMonthsScrollView.frame.width, 0), animated: false)
    
    self.calendarMonthTitleView.displayView(self.frame.width)
    self.currentMonthView.displayView(self.columnWidth, rowHeight: self.rowHeight)
    self.nextMonthView.displayView(self.columnWidth, rowHeight: self.rowHeight)
    self.previousMonthView.displayView(self.columnWidth, rowHeight: self.rowHeight)
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for calendarMonthTitleView
    
    self.calendarMonthTitleView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarMonthTitleViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthTitleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let calendarMonthTitleViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthTitleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let calendarMonthTitleViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthTitleView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let calendarMonthTitleViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthTitleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight * 2)
    
    self.calendarMonthTitleView.addConstraint(calendarMonthTitleViewHeightConstraint)
    self.addConstraints([calendarMonthTitleViewTopConstraint, calendarMonthTitleViewLeftConstraint, calendarMonthTitleViewRightConstraint])
    
    // Create and add constraints for calendarMonthsScrollView
    
    self.calendarMonthsScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let calendarMonthsScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthTitleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let calendarMonthsScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let calendarMonthsScrollViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
    
    let calendarMonthsScrollViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight * 7)
    
    self.calendarMonthsScrollView.addConstraints([calendarMonthsScrollViewHeightConstraint, calendarMonthsScrollViewWidthConstraint])
    self.addConstraints([calendarMonthsScrollViewTopConstraint, calendarMonthsScrollViewLeftConstraint])
    
    // Create and add constraints for previousMonthView
    
    self.previousMonthView.translatesAutoresizingMaskIntoConstraints = false
    
    let previousMonthViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let previousMonthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let previousMonthViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
    
    let previousMonthViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight * 7)
    
    self.previousMonthView.addConstraints([previousMonthViewHeightConstraint, previousMonthViewWidthConstraint])
    self.addConstraints([previousMonthViewTopConstraint, previousMonthViewLeftConstraint])
    
    // Create and add constraints for currentMonthView
    
    self.currentMonthView.translatesAutoresizingMaskIntoConstraints = false
    
    let currentMonthViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentMonthView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let currentMonthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentMonthView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.previousMonthView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let currentMonthViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentMonthView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
    
    let currentMonthViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.currentMonthView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight * 7)
    
    self.currentMonthView.addConstraints([currentMonthViewHeightConstraint, currentMonthViewWidthConstraint])
    self.addConstraints([currentMonthViewTopConstraint, currentMonthViewLeftConstraint])
    
    // Create and add constraints for nextMonthView
    
    self.nextMonthView.translatesAutoresizingMaskIntoConstraints = false
    
    let nextMonthViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let nextMonthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.currentMonthView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let nextMonthViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
    
    let nextMonthViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.rowHeight * 7)
    
    let calendarMonthsScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarMonthsScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    self.nextMonthView.addConstraints([nextMonthViewHeightConstraint, nextMonthViewWidthConstraint])
    self.addConstraints([nextMonthViewTopConstraint, nextMonthViewLeftConstraint, calendarMonthsScrollViewRightConstraint])
    
    // Create and add constraints for deadlinesView
    
    self.deadlinesView.translatesAutoresizingMaskIntoConstraints = false
    
    let deadlinesViewTopConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let deadlinesViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let deadlinesViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let deadlinesViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.addConstraints([deadlinesViewTopConstraint, deadlinesViewLeftConstraint, deadlinesViewRightConstraint, deadlinesViewBottomConstraint])
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    if self.calendarMonthsScrollView.contentOffset.x == (self.calendarMonthsScrollView.frame.width * 2) {
      
      if self.currentMonth == 12 {
        self.currentMonth = 1
        self.previousMonth = 12
        self.nextMonth = 2
        self.currentYear++
      }
      else if self.currentMonth == 11 {
        self.currentMonth = 12
        self.previousMonth = 11
        self.nextMonth = 1
      }
      else if self.currentMonth == 1 {
        self.currentMonth = 2
        self.previousMonth = 1
        self.nextMonth = 3
      }
      else {
        self.currentMonth++
        self.previousMonth++
        self.nextMonth++
      }
      
      self.displayCalendar()
      
    }
    if self.calendarMonthsScrollView.contentOffset.x == 0 {
      
      if self.currentMonth == 12 {
        self.currentMonth = 11
        self.previousMonth = 10
        self.nextMonth = 12
      }
      else if self.currentMonth == 1 {
        self.currentMonth = 12
        self.previousMonth = 11
        self.nextMonth = 1
        self.currentYear--
      }
      else if self.currentMonth == 2 {
        self.currentMonth = 1
        self.previousMonth = 12
        self.nextMonth = 2
      }
      else {
        self.currentMonth--
        self.previousMonth--
        self.nextMonth--
      }
      
      self.displayCalendar()
      
    }
    
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    self.scrollViewDidEndDecelerating(scrollView)
  }
  
  func nextMonthButtonClicked(sender: UIButton) {
    
    self.calendarMonthsScrollView.setContentOffset(self.nextMonthView.frame.origin, animated: true)
    
  }
  
  func previousMonthButtonClicked(sender: UIButton) {
    
    self.calendarMonthsScrollView.setContentOffset(self.previousMonthView.frame.origin, animated: true)
    
  }
  
  func calendarDayButtonClicked(sender: CalendarDayButton) {
    
    if sender.clicked {
      
      UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        
        self.calendarMonthTitleView.alpha = 0
        self.calendarMonthsScrollView.alpha = 0
        self.deadlinesView.alpha = 1
        
        }, completion: nil)
      
    }
    
  }
  
  func deadlinesViewTapped(sender: UITapGestureRecognizer) {
    
    UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      
      self.calendarMonthTitleView.alpha = 1
      self.calendarMonthsScrollView.alpha = 1
      self.deadlinesView.alpha = 0
      
      }, completion: nil)
    
  }
  
  func getJobDeadlinesForMonth(month: Int, year: Int) -> [[String:AnyObject]] {
    
    var deadlines:[[String:AnyObject]] = [[String:AnyObject]]()
    
    for var index = 0 ; index < self.jobDeadlines.count ; index++ {
      
      if self.jobDeadlines[index]["year"] as! Int == year {
        if self.jobDeadlines[index]["month"] as! Int == month {
          deadlines.append(self.jobDeadlines[index])
        }
      }
      
    }
    
    return deadlines
  }
  
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
