//
//  CalendarView.swift
//  Break in2
//
//  Created by Sangeet on 15/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit
import SwiftSpinner
import Parse
import ParseUI

class CalendarView: UIView, UIScrollViewDelegate, CalendarMonthViewDelegate {
  
  // Declare and initialize jobDeadlines
  
  var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
  var chosenCareers:[String] = [String]()
    
  // Sort appended jobs bug
  var flushCounter:Int = Int()
  
  // Declare and initialize views and models
  
  let calendarModel:JSONModel = JSONModel()
  let defaults = NSUserDefaults.standardUserDefaults()
  
  let monthTitleButton:UIButton = UIButton()
  let updateDeadlinesButton:UIButton = UIButton()
  let nextMonthButton:UIButton = UIButton()
  let previousMonthButton:UIButton = UIButton()
  let monthScrollView:UIScrollView = UIScrollView()
  var monthViews:[CalendarMonthView] = [CalendarMonthView]()
  let deadlinesView:UIView = UIView()
  
  let todaysDate:NSDate = NSDate()
  let userCalendar:NSCalendar = NSCalendar.currentCalendar()
  let dateFormatter:NSDateFormatter = NSDateFormatter()
  var currentYear = 0
  var currentMonth:Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Set deadlinesView properties and add as subview to self
    self.deadlinesView.backgroundColor = UIColor.whiteColor()
    self.deadlinesView.alpha = 0
    self.addSubview(self.deadlinesView)
    
    // Set monthTitleButton properties and add as subview to self
    
    self.monthTitleButton.titleLabel?.textAlignment = NSTextAlignment.Center
    self.monthTitleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.getTextSize(18))
    self.monthTitleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.monthTitleButton.addTarget(self, action: #selector(self.downloadAndDisplayJobDeadlinesForCurrentMonth), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.monthTitleButton)
    
    // Set updateDeadlinesButton properties and add as subview to self
    
    self.updateDeadlinesButton.titleLabel?.textAlignment = NSTextAlignment.Center
    self.updateDeadlinesButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.getTextSize(14))
    self.updateDeadlinesButton.setTitle("Tap Here To Refresh", forState: UIControlState.Normal)
    self.updateDeadlinesButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    self.updateDeadlinesButton.addTarget(self, action: #selector(self.downloadAndDisplayJobDeadlinesForCurrentMonth), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.updateDeadlinesButton)
    
    // Set nextMonthButton properties and add as subview to self
    
    self.nextMonthButton.setImage(UIImage.init(named: "nextButton"), forState: UIControlState.Normal)
    self.nextMonthButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.nextMonthButton.addTarget(self, action: #selector(NewCalendarView.nextMonthButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.nextMonthButton)
    
    // Set previousMonthButton properties and add as subview to self
    
    self.previousMonthButton.setImage(UIImage.init(named: "prevButton"), forState: UIControlState.Normal)
    self.previousMonthButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.previousMonthButton.addTarget(self, action: #selector(NewCalendarView.previousMonthButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.previousMonthButton)
    
    // Set monthScrollView properties and add as subview to self
    
    self.monthScrollView.pagingEnabled = true
    self.monthScrollView.delegate = self
    self.monthScrollView.showsHorizontalScrollIndicator = false
    self.addSubview(self.monthScrollView)
    
    // Create current, next and previous monthViews
    
    for index:Int in 0.stride(through: 2, by: 1) {
      
      let monthViewAtIndex:CalendarMonthView = CalendarMonthView()
      
      // Set monthView properties and add as subview to monthScrollView
      
      monthViewAtIndex.delegate = self
      self.monthScrollView.addSubview(monthViewAtIndex)
      
      // Add view to monthViews array
      
      self.monthViews.append(monthViewAtIndex)
      
    }
    
    // Get present year and present month
    
    self.currentYear = self.userCalendar.component(NSCalendarUnit.Year, fromDate: self.todaysDate)
    self.currentMonth = self.userCalendar.component(NSCalendarUnit.Month, fromDate: self.todaysDate)
    
    // Get user's chosen careers
    self.chosenCareers = self.defaults.objectForKey("SavedCareerPreferences") as? [String] ?? [String]()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func displayCalendar() {
    
    if superview != nil {
      superview?.layoutIfNeeded()
    }
    
    // Set current, next and previous monthView month and year properties
    
    if self.currentMonth == 0 {
      self.currentMonth = 12
      self.currentYear -= 1
      self.monthViews[0].month = 11
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = 12
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 1
      self.monthViews[2].year = self.currentYear + 1
    }
    else if self.currentMonth == 1 {
      self.monthViews[0].month = 12
      self.monthViews[0].year = self.currentYear - 1
      self.monthViews[1].month = 1
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 2
      self.monthViews[2].year = self.currentYear
    }
    else if self.currentMonth == 13 {
      self.currentMonth = 1
      self.currentYear += 1
      self.monthViews[0].month = 12
      self.monthViews[0].year = self.currentYear - 1
      self.monthViews[1].month = 1
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 2
      self.monthViews[2].year = self.currentYear
    }
    else if self.currentMonth == 12 {
      self.monthViews[0].month = 11
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = 12
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 1
      self.monthViews[2].year = self.currentYear + 1
    }
    else {
      self.monthViews[0].month = self.currentMonth - 1
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = self.currentMonth
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = self.currentMonth + 1
      self.monthViews[2].year = self.currentYear
    }
    
    // Set monthTitleButton
    
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthTitleString:String = dateFormatter.monthSymbols[self.currentMonth - 1] + " " + String(self.currentYear)
    self.monthTitleButton.setTitle(monthTitleString.uppercaseString, forState: UIControlState.Normal)
    
    // Set constraints
    
    self.setConstraints()
    self.layoutIfNeeded()
    
    // Display all monthViews
    for view:CalendarMonthView in self.monthViews {
      view.displayView()
    }
    
    // Move monthScrollView to the middle of the content size
    
    self.monthScrollView.setContentOffset(CGPointMake(self.monthScrollView.frame.width, 0), animated: false)
    
  }
  
  func updateCalendar() {
    
    // Set current, next and previous monthView month and year properties
    
    if self.currentMonth == 0 {
      self.currentMonth = 12
      self.currentYear -= 1
      self.monthViews[0].month = 11
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = 12
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 1
      self.monthViews[2].year = self.currentYear + 1
    }
    else if self.currentMonth == 1 {
      self.monthViews[0].month = 12
      self.monthViews[0].year = self.currentYear - 1
      self.monthViews[1].month = 1
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 2
      self.monthViews[2].year = self.currentYear
    }
    else if self.currentMonth == 13 {
      self.currentMonth = 1
      self.currentYear += 1
      self.monthViews[0].month = 12
      self.monthViews[0].year = self.currentYear - 1
      self.monthViews[1].month = 1
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 2
      self.monthViews[2].year = self.currentYear
    }
    else if self.currentMonth == 12 {
      self.monthViews[0].month = 11
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = 12
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = 1
      self.monthViews[2].year = self.currentYear + 1
    }
    else {
      self.monthViews[0].month = self.currentMonth - 1
      self.monthViews[0].year = self.currentYear
      self.monthViews[1].month = self.currentMonth
      self.monthViews[1].year = self.currentYear
      self.monthViews[2].month = self.currentMonth + 1
      self.monthViews[2].year = self.currentYear
    }
    
    // Set monthTitleButton
    
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthTitleString:String = dateFormatter.monthSymbols[self.currentMonth - 1] + " " + String(self.currentYear)
    self.monthTitleButton.setTitle(monthTitleString.uppercaseString, forState: UIControlState.Normal)
    
    // Give deadlines array to monthView[1] (current month)
    
    // Display all monthViews
    for view:CalendarMonthView in self.monthViews {
      view.displayView()
    }
    
    // Move monthScrollView to the middle of the content size
    
    self.monthScrollView.setContentOffset(CGPointMake(self.monthScrollView.frame.width, 0), animated: false)
    
  }
  
  func setConstraints() {
    
    // Set constraints for monthTitleButton
    
    self.monthTitleButton.translatesAutoresizingMaskIntoConstraints = false
    let monthTitleButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let monthTitleButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: (self.frame.width/10) * 2)
    let monthTitleButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.width/10) * 6)
    let monthTitleButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9) * 1.5)
    self.addConstraints([monthTitleButtonTopConstraint,monthTitleButtonLeftConstraint])
    self.monthTitleButton.addConstraints([monthTitleButtonWidthConstraint,monthTitleButtonHeightConstraint])
    
    // Set constraints for updateDeadlinesButton
    
    self.updateDeadlinesButton.translatesAutoresizingMaskIntoConstraints = false
    let updateDeadlinesButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.frame.height/9) * 1.2)
    let updateDeadlinesButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: (self.frame.width/10) * 2)
    let updateDeadlinesButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.width/10) * 6)
    let updateDeadlinesButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9) * 0.5)
    self.addConstraints([updateDeadlinesButtonTopConstraint,updateDeadlinesButtonLeftConstraint])
    self.updateDeadlinesButton.addConstraints([updateDeadlinesButtonWidthConstraint,updateDeadlinesButtonHeightConstraint])
    // Set constraints for nextMonthButton
    
    self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let nextMonthButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.frame.height/9)
    let nextMonthButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    let nextMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    let nextMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/20)
    self.addConstraints([nextMonthButtonCenterYConstraint,nextMonthButtonRightConstraint])
    self.nextMonthButton.addConstraints([nextMonthButtonWidthConstraint,nextMonthButtonHeightConstraint])
    
    // Set constraints for previousMonthButton
    
    self.previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let previousMonthButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.frame.height/9)
    let previousMonthButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let previousMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    let previousMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/20)
    self.addConstraints([previousMonthButtonCenterYConstraint,previousMonthButtonLeftConstraint])
    self.previousMonthButton.addConstraints([previousMonthButtonWidthConstraint,previousMonthButtonHeightConstraint])
    
    // Set constraints for monthScrollView
    
    self.monthScrollView.translatesAutoresizingMaskIntoConstraints = false
    let monthScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (self.frame.height/9)*2)
    let monthScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let monthScrollViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
    let monthScrollViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*7)
    self.addConstraints([monthScrollViewTopConstraint,monthScrollViewLeftConstraint])
    self.monthScrollView.addConstraints([monthScrollViewWidthConstraint,monthScrollViewHeightConstraint])
    
    // Set constraints for monthViews
    
    for index:Int in 0.stride(through: 2, by: 1) {
      
      self.monthViews[index].translatesAutoresizingMaskIntoConstraints = false
      let monthViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
      let monthViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width)
      let monthViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*7)
      
      if index == 0 {
        let monthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthViewLeftConstraint)
      }
      else {
        let monthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.monthViews[index-1], attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthViewLeftConstraint)
      }
      
      self.monthViews[index].addConstraints([monthViewWidthConstraint,monthViewHeightConstraint])
      self.monthScrollView.addConstraints([monthViewTopConstraint])
      
      if index == 2 {
        let monthScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthScrollViewRightConstraint)
      }
      
    }
    
    // Create and add constraints for deadlinesView
    
    self.deadlinesView.translatesAutoresizingMaskIntoConstraints = false
    
    let deadlinesViewTopConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let deadlinesViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let deadlinesViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let deadlinesViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.addConstraints([deadlinesViewTopConstraint, deadlinesViewLeftConstraint, deadlinesViewRightConstraint, deadlinesViewBottomConstraint])
    
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    if self.monthScrollView.contentOffset.x == (self.monthScrollView.frame.width * 2) {
      
      self.currentMonth += 1
      self.monthViews[1].deadlines.removeAll()
      self.updateCalendar()
      
    }
    if self.monthScrollView.contentOffset.x == 0 {
      
      self.currentMonth -= 1
      self.monthViews[1].deadlines.removeAll()
      self.updateCalendar()
      
    }
    
    self.nextMonthButton.userInteractionEnabled = true
    self.previousMonthButton.userInteractionEnabled = true
    
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    self.scrollViewDidEndDecelerating(scrollView)
  }
  
  func nextMonthButtonClicked(sender: UIButton) {
    
    self.nextMonthButton.userInteractionEnabled = false
    self.previousMonthButton.userInteractionEnabled = false
    self.monthScrollView.setContentOffset(CGPointMake(self.frame.width*2, 0), animated: true)
    
  }
  
  func previousMonthButtonClicked(sender: UIButton) {
    
    self.nextMonthButton.userInteractionEnabled = false
    self.previousMonthButton.userInteractionEnabled = false
    self.monthScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    
  }
  
  func calendarDayButtonClicked(sender: CalendarDayButton) {
    
    if sender.clicked {
      
      self.deadlinesViewInitialize(sender)
      
      UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
        
        self.monthTitleButton.alpha = 0
        self.nextMonthButton.alpha = 0
        self.previousMonthButton.alpha = 0
        self.monthScrollView.alpha = 0
        self.deadlinesView.alpha = 1
        self.updateDeadlinesButton.alpha = 0
        
        }, completion: nil)
      
    }
    
  }
  
  func deadlinesViewInitialize(sender: CalendarDayButton) {
    
    //Clean existing views
    for singleView in self.deadlinesView.subviews {
      singleView.removeFromSuperview()
    }
    
    //Initialize Views
    let titleView:UIView = UIView()
    let deadlineTitle:UILabel = UILabel()
    let deadlineScrollView:UIScrollView = UIScrollView()
    let backButton:UIButton = UIButton()
    
    //Set constraints to Views
    self.deadlinesView.addSubview(titleView)
    self.deadlinesView.addSubview(deadlineScrollView)
    titleView.addSubview(backButton)
    titleView.addSubview(deadlineTitle)
    
    titleView.translatesAutoresizingMaskIntoConstraints = false
    let titleViewTop:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let titleViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let titleViewRight:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    self.deadlinesView.addConstraints([titleViewTop,titleViewLeft, titleViewRight])
    let titleViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*2)
    titleView.addConstraint(titleViewHeight)
    
    backButton.translatesAutoresizingMaskIntoConstraints = false
    let backButtonCenterY:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    let backButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    titleView.addConstraints([backButtonLeft,backButtonCenterY])
    let backButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width/20)
    let backButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width/10)
    backButton.addConstraints([backButtonHeight,backButtonWidth])
    backButton.setImage(UIImage(named: "prevButton"), forState: UIControlState.Normal)
    backButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    backButton.addTarget(self, action: #selector(CalendarView.backToCalendarView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    
    deadlineTitle.translatesAutoresizingMaskIntoConstraints = false
    let deadlineTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let deadlineTitleBottom:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    let deadlineTitleCenterX:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    titleView.addConstraints([deadlineTitleTop,deadlineTitleBottom,deadlineTitleCenterX])
    let deadlineTitleWidth:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width*8/10)
    deadlineTitle.addConstraint(deadlineTitleWidth)
    deadlineTitle.textColor = UIColor.blackColor()
    let textSize = self.getTextSize(18)
    deadlineTitle.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    deadlineTitle.textAlignment = NSTextAlignment.Center
    
    deadlineScrollView.setConstraintsToSuperview(Int(((self.frame.height/9)*2)+5), bottom: 0, left: 0, right: 0)
    
    //Initalize Date
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthString:String = dateFormatter.monthSymbols[sender.month - 1]
    deadlineTitle.text = String(sender.day) + " " + monthString.uppercaseString + " " + String(sender.year)
    
    //Initialize Deadline Table
    var i:Int = 0
    let cellHeight:Int = 70

    for elementArray in sender.deadlines {
      
      let tableCell:UIView = UIView()
      let companyName:UILabel = UILabel()
      let careerName:UILabel = UILabel()
      let positionName:UILabel = UILabel()
      
      deadlineScrollView.addSubview(tableCell)
      tableCell.translatesAutoresizingMaskIntoConstraints = false
      let tableCellTop:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*cellHeight))
      let tableCellLeft:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      deadlineScrollView.addConstraints([tableCellTop,tableCellLeft])
      let tableCellWidth:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(self.deadlinesView.bounds.width))
      let tableCellHeight:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(cellHeight))
      tableCell.addConstraints([tableCellHeight,tableCellWidth])
      
      if (i%2==0) {
        tableCell.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
      }
      else {
        tableCell.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.2)
      }
      
      tableCell.addSubview(companyName)
      tableCell.addSubview(careerName)
      tableCell.addSubview(positionName)
      companyName.translatesAutoresizingMaskIntoConstraints = false
      careerName.translatesAutoresizingMaskIntoConstraints = false
      positionName.translatesAutoresizingMaskIntoConstraints = false
      companyName.setConstraintsToSuperview(5, bottom: 45, left: 10, right: 5)
      careerName.setConstraintsToSuperview(25, bottom: 25, left: 10, right: 5)
      positionName.setConstraintsToSuperview(45, bottom: 5, left: 10, right: 5)
      companyName.numberOfLines = 0
      careerName.numberOfLines = 0
      positionName.numberOfLines = 0
      let textSize2 = self.getTextSize(15)
      companyName.font = UIFont(name: "HelveticaNeue-MediumBold", size: textSize2)
      companyName.textAlignment = NSTextAlignment.Left
      careerName.font = UIFont(name: "HelveticaNeue-LightItalic", size: textSize2)
      careerName.textAlignment = NSTextAlignment.Left
      positionName.font = UIFont(name: "HelveticaNeue-LightItalic", size: textSize2)
      positionName.textAlignment = NSTextAlignment.Left
      
      companyName.text = elementArray[0]
      careerName.text = elementArray[1]
      positionName.text = elementArray[2]
      
      i += 1
      
    }
    
    //Set content size
    deadlineScrollView.contentSize = CGSize(width: Int(self.deadlinesView.bounds.width), height: Int(i*cellHeight))
    
  }
  
  func backToCalendarView(sender: UITapGestureRecognizer) {
    
    self.flushCounter += 1
    
    UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      
      self.monthTitleButton.alpha = 1
      self.nextMonthButton.alpha = 1
      self.previousMonthButton.alpha = 1
      self.monthScrollView.alpha = 1
      self.deadlinesView.alpha = 0
      self.updateDeadlinesButton.alpha = 1
        
      }, completion: nil)
  }
  
  func deadlinesViewTapped(sender: UITapGestureRecognizer) {
    
    UIView.animateWithDuration(0.5, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
      
      self.monthTitleButton.alpha = 1
      self.nextMonthButton.alpha = 1
      self.previousMonthButton.alpha = 1
      self.monthScrollView.alpha = 1
      self.deadlinesView.alpha = 0
      
      }, completion: nil)
    
  }
  
  func downloadAndDisplayJobDeadlinesForCurrentMonth() {
    
    SwiftSpinner.show("Loading")
    var deadlinesTemp:[[String:AnyObject]] = [[String:AnyObject]]()
    deadlinesTemp.removeAll()
    
    let query = PFQuery(className: PF_CALENDAR_CLASS_NAME)
    query.whereKey(PF_CALENDAR_DEADLINEMONTH, equalTo: self.currentMonth)
    query.whereKey(PF_CALENDAR_DEADLINEYEAR, equalTo: self.currentYear)
    
    query.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      if error == nil {
        
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) job deadlines.")
        
        // Do something with the found objects
        if let objects = objects {
          
          for object in objects {
            
            if objects.count >= 0 {
              
              var deadlinesIndividual:[String:AnyObject] = [:]
              
              print(object[PF_CALENDAR_CAREERTYPE] as! String)
              print(self.chosenCareers)
              
              if self.chosenCareers.contains(object[PF_CALENDAR_CAREERTYPE] as! String) {
                
                deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEDAY] as! Int, forKey: "day")
                deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEMONTH] as! Int, forKey: "month")
                deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEYEAR] as! Int, forKey: "year")
                deadlinesIndividual.updateValue(object[PF_CALENDAR_COMPANY] as! String, forKey: "company")
                deadlinesIndividual.updateValue(object[PF_CALENDAR_CAREERTYPE] as! String, forKey: "career")
                deadlinesIndividual.updateValue(object[PF_CALENDAR_JOBTITLE] as! String, forKey: "position")
                
                deadlinesTemp.append(deadlinesIndividual)
                //self.monthViews[1].deadlines.append(deadlinesIndividual)
                
              }else{
                print("career not selected by user")
              }
            }else{
              print("no jobs available this month")
            }
          }//for loop ends
          
        }else{
          //if objects ends
        }
        
        //print(self.monthViews[1].deadlines)
        
        self.monthViews[1].deadlines.removeAll()
        print(self.monthViews[1].deadlines)
        self.monthViews[1].deadlines = deadlinesTemp
        print(self.monthViews[1].deadlines)
        self.monthViews[1].displayView()
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Mmmm"
        let monthTitleString1:String = dateFormatter.monthSymbols[self.currentMonth - 1]
        
        SwiftSpinner.show("\(monthTitleString1)'s Job Deadlines Updated", animated: false).addTapHandler({
            
            SwiftSpinner.hide()
            
            }, subtitle: "Tap to dismiss")
        
      } else {
        // Log details of the failure
        SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
          
          SwiftSpinner.hide()
          
          }, subtitle: "Tap to dismiss")
      }
    }
    
  }
  
}
