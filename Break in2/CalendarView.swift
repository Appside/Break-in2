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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class CalendarView: UIView, UIScrollViewDelegate, CalendarMonthViewDelegate {
  
  // Declare and initialize jobDeadlines
  
  var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
  var chosenCareers:[String] = [String]()
    
  // Sort appended jobs bug
  var flushCounter:Int = Int()
  
  // Declare and initialize views and models
  
  let calendarModel:JSONModel = JSONModel()
  let defaults = UserDefaults.standard
  
  let monthTitleButton:UIButton = UIButton()
  let updateDeadlinesButton:UIButton = UIButton()
  let nextMonthButton:UIButton = UIButton()
  let previousMonthButton:UIButton = UIButton()
  let monthScrollView:UIScrollView = UIScrollView()
  var monthViews:[CalendarMonthView] = [CalendarMonthView]()
  let deadlinesView:UIView = UIView()
  var careerTypes:[String] = [String]()
  var careerColors:[String:UIColor] = [String:UIColor]()
  
  let todaysDate:Date = Date()
  let userCalendar:Calendar = Calendar.current
  let dateFormatter:DateFormatter = DateFormatter()
  var currentYear = 0
  var currentMonth:Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.careerTypes = self.calendarModel.getAppVariables("careerTypes") as! [String]
    
    let appColors:[UIColor] = self.calendarModel.getAppColors()
    for index:Int in stride(from: 0, to: self.careerTypes.count, by: 1) {
      self.careerColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }
    
    // Set deadlinesView properties and add as subview to self
    self.deadlinesView.backgroundColor = UIColor.white
    self.deadlinesView.alpha = 0
    self.addSubview(self.deadlinesView)
    
    // Set monthTitleButton properties and add as subview to self
    
    self.monthTitleButton.titleLabel?.textAlignment = NSTextAlignment.center
    self.monthTitleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.getTextSize(18))
    self.monthTitleButton.setTitleColor(UIColor.black, for: UIControlState())
    self.monthTitleButton.addTarget(self, action: #selector(self.downloadAndDisplayJobDeadlinesForCurrentMonth), for: UIControlEvents.touchUpInside)
    self.addSubview(self.monthTitleButton)
    
    // Set updateDeadlinesButton properties and add as subview to self
    
    self.updateDeadlinesButton.titleLabel?.textAlignment = NSTextAlignment.center
    self.updateDeadlinesButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.getTextSize(14))
    self.updateDeadlinesButton.setTitle("Tap Here To Refresh", for: UIControlState())
    self.updateDeadlinesButton.setTitleColor(UIColor.gray, for: UIControlState())
    self.updateDeadlinesButton.addTarget(self, action: #selector(self.downloadAndDisplayJobDeadlinesForCurrentMonth), for: UIControlEvents.touchUpInside)
    self.addSubview(self.updateDeadlinesButton)
    
    // Set nextMonthButton properties and add as subview to self
    
    self.nextMonthButton.setImage(UIImage.init(named: "nextButton"), for: UIControlState())
    self.nextMonthButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    self.nextMonthButton.addTarget(self, action: #selector(CalendarView.nextMonthButtonClicked(_:)), for: UIControlEvents.touchUpInside)
    self.addSubview(self.nextMonthButton)
    
    // Set previousMonthButton properties and add as subview to self
    
    self.previousMonthButton.setImage(UIImage.init(named: "prevButton"), for: UIControlState())
    self.previousMonthButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    self.previousMonthButton.addTarget(self, action: #selector(CalendarView.previousMonthButtonClicked(_:)), for: UIControlEvents.touchUpInside)
    self.addSubview(self.previousMonthButton)
    
    // Set monthScrollView properties and add as subview to self
    
    self.monthScrollView.isPagingEnabled = true
    self.monthScrollView.delegate = self
    self.monthScrollView.showsHorizontalScrollIndicator = false
    self.addSubview(self.monthScrollView)
    
    // Create current, next and previous monthViews
    
    for _:Int in stride(from: 0, through: 2, by: 1) {
      
      let monthViewAtIndex:CalendarMonthView = CalendarMonthView()
      
      // Set monthView properties and add as subview to monthScrollView
      
      monthViewAtIndex.delegate = self
      self.monthScrollView.addSubview(monthViewAtIndex)
      
      // Add view to monthViews array
      
      self.monthViews.append(monthViewAtIndex)
      
    }
    
    // Get present year and present month
    
    self.currentYear = (self.userCalendar as NSCalendar).component(NSCalendar.Unit.year, from: self.todaysDate)
    self.currentMonth = (self.userCalendar as NSCalendar).component(NSCalendar.Unit.month, from: self.todaysDate)
    
    // Get user's chosen careers
    self.chosenCareers = self.defaults.object(forKey: "SavedCareerPreferences") as? [String] ?? [String]()
    
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
    
    let dateFormatter:DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthTitleString:String = dateFormatter.monthSymbols[self.currentMonth - 1] + " " + String(self.currentYear)
    self.monthTitleButton.setTitle(monthTitleString.uppercased(), for: UIControlState())
    
    // Set constraints
    
    self.setConstraints()
    self.layoutIfNeeded()
    
    // Display all monthViews
    for view:CalendarMonthView in self.monthViews {
      view.displayView()
    }
    
    // Move monthScrollView to the middle of the content size
    
    self.monthScrollView.setContentOffset(CGPoint(x: self.monthScrollView.frame.width, y: 0), animated: false)
    
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
    
    let dateFormatter:DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthTitleString:String = dateFormatter.monthSymbols[self.currentMonth - 1] + " " + String(self.currentYear)
    self.monthTitleButton.setTitle(monthTitleString.uppercased(), for: UIControlState())
    
    // Give deadlines array to monthView[1] (current month)
    
    // Display all monthViews
    for view:CalendarMonthView in self.monthViews {
      view.displayView()
    }
    
    // Move monthScrollView to the middle of the content size
    
    self.monthScrollView.setContentOffset(CGPoint(x: self.monthScrollView.frame.width, y: 0), animated: false)
    
  }
  
  func setConstraints() {
    
    // Set constraints for monthTitleButton
    
    self.monthTitleButton.translatesAutoresizingMaskIntoConstraints = false
    let monthTitleButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    let monthTitleButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: (self.frame.width/10) * 2)
    let monthTitleButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.width/10) * 6)
    let monthTitleButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/9) * 1.5)
    self.addConstraints([monthTitleButtonTopConstraint,monthTitleButtonLeftConstraint])
    self.monthTitleButton.addConstraints([monthTitleButtonWidthConstraint,monthTitleButtonHeightConstraint])
    
    // Set constraints for updateDeadlinesButton
    
    self.updateDeadlinesButton.translatesAutoresizingMaskIntoConstraints = false
    let updateDeadlinesButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.frame.height/9) * 1.2)
    let updateDeadlinesButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: (self.frame.width/10) * 2)
    let updateDeadlinesButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.width/10) * 6)
    let updateDeadlinesButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.updateDeadlinesButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/9) * 0.5)
    self.addConstraints([updateDeadlinesButtonTopConstraint,updateDeadlinesButtonLeftConstraint])
    self.updateDeadlinesButton.addConstraints([updateDeadlinesButtonWidthConstraint,updateDeadlinesButtonHeightConstraint])
    // Set constraints for nextMonthButton
    
    self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let nextMonthButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.frame.height/9)
    let nextMonthButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    let nextMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/10)
    let nextMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/20)
    self.addConstraints([nextMonthButtonCenterYConstraint,nextMonthButtonRightConstraint])
    self.nextMonthButton.addConstraints([nextMonthButtonWidthConstraint,nextMonthButtonHeightConstraint])
    
    // Set constraints for previousMonthButton
    
    self.previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let previousMonthButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.frame.height/9)
    let previousMonthButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    let previousMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/10)
    let previousMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/20)
    self.addConstraints([previousMonthButtonCenterYConstraint,previousMonthButtonLeftConstraint])
    self.previousMonthButton.addConstraints([previousMonthButtonWidthConstraint,previousMonthButtonHeightConstraint])
    
    // Set constraints for monthScrollView
    
    self.monthScrollView.translatesAutoresizingMaskIntoConstraints = false
    let monthScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.frame.height/9)*2)
    let monthScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    let monthScrollViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
    let monthScrollViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthScrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/9)*7)
    self.addConstraints([monthScrollViewTopConstraint,monthScrollViewLeftConstraint])
    self.monthScrollView.addConstraints([monthScrollViewWidthConstraint,monthScrollViewHeightConstraint])
    
    // Set constraints for monthViews
    
    for index:Int in stride(from: 0, through: 2, by: 1) {
      
      self.monthViews[index].translatesAutoresizingMaskIntoConstraints = false
      let monthViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
      let monthViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
      let monthViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/9)*7)
      
      if index == 0 {
        let monthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthViewLeftConstraint)
      }
      else {
        let monthViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.monthViews[index-1], attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthViewLeftConstraint)
      }
      
      self.monthViews[index].addConstraints([monthViewWidthConstraint,monthViewHeightConstraint])
      self.monthScrollView.addConstraints([monthViewTopConstraint])
      
      if index == 2 {
        let monthScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthViews[index], attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.monthScrollView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        self.monthScrollView.addConstraint(monthScrollViewRightConstraint)
      }
      
    }
    
    // Create and add constraints for deadlinesView
    
    self.deadlinesView.translatesAutoresizingMaskIntoConstraints = false
    
    let deadlinesViewTopConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let deadlinesViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    
    let deadlinesViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    
    let deadlinesViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.deadlinesView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    self.addConstraints([deadlinesViewTopConstraint, deadlinesViewLeftConstraint, deadlinesViewRightConstraint, deadlinesViewBottomConstraint])
    
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
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
    
    self.nextMonthButton.isUserInteractionEnabled = true
    self.previousMonthButton.isUserInteractionEnabled = true
    
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.scrollViewDidEndDecelerating(scrollView)
  }
  
  func nextMonthButtonClicked(_ sender: UIButton) {
    
    self.nextMonthButton.isUserInteractionEnabled = false
    self.previousMonthButton.isUserInteractionEnabled = false
    self.monthScrollView.setContentOffset(CGPoint(x: self.frame.width*2, y: 0), animated: true)
    
  }
  
  func previousMonthButtonClicked(_ sender: UIButton) {
    
    self.nextMonthButton.isUserInteractionEnabled = false
    self.previousMonthButton.isUserInteractionEnabled = false
    self.monthScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    
  }
  
  func calendarDayButtonClicked(_ sender: CalendarDayButton) {
    
    if sender.clicked {
      
      self.deadlinesViewInitialize(sender)
      
      UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: {
        
        self.monthTitleButton.alpha = 0
        self.nextMonthButton.alpha = 0
        self.previousMonthButton.alpha = 0
        self.monthScrollView.alpha = 0
        self.deadlinesView.alpha = 1
        self.updateDeadlinesButton.alpha = 0
        
        }, completion: nil)
      
    }
    
  }
  
  func deadlinesViewInitialize(_ sender: CalendarDayButton) {
    
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
    let titleViewTop:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    let titleViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    let titleViewRight:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.deadlinesView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    self.deadlinesView.addConstraints([titleViewTop,titleViewLeft, titleViewRight])
    let titleViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.height/9)*2)
    titleView.addConstraint(titleViewHeight)
    
    backButton.translatesAutoresizingMaskIntoConstraints = false
    let backButtonCenterY:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: titleView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    let backButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: titleView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    titleView.addConstraints([backButtonLeft,backButtonCenterY])
    let backButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width/20)
    let backButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width/10)
    backButton.addConstraints([backButtonHeight,backButtonWidth])
    backButton.setImage(UIImage(named: "prevButton"), for: UIControlState())
    backButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    backButton.addTarget(self, action: #selector(CalendarView.backToCalendarView(_:)), for: UIControlEvents.touchUpInside)
    
    deadlineTitle.translatesAutoresizingMaskIntoConstraints = false
    let deadlineTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: titleView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    let deadlineTitleBottom:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: titleView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    let deadlineTitleCenterX:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: titleView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    titleView.addConstraints([deadlineTitleTop,deadlineTitleBottom,deadlineTitleCenterX])
    let deadlineTitleWidth:NSLayoutConstraint = NSLayoutConstraint(item: deadlineTitle, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.deadlinesView.bounds.width*8/10)
    deadlineTitle.addConstraint(deadlineTitleWidth)
    deadlineTitle.textColor = UIColor.black
    let textSize = self.getTextSize(18)
    deadlineTitle.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    deadlineTitle.textAlignment = NSTextAlignment.center
    
    deadlineScrollView.setConstraintsToSuperview(Int(((self.frame.height/12)*2)+5), bottom: 0, left: 0, right: 0)
    
    //Initalize Date
    let dateFormatter:DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthString:String = dateFormatter.monthSymbols[sender.month - 1]
    deadlineTitle.text = String(sender.day) + " " + monthString.uppercased() + " " + String(sender.year)
    
    //Initialize Deadline Table
    var i:Int = 0
    var j:Int = 0
    var currentCareer:String = ""
    let cellHeight:Int = 50

    for elementArray in sender.deadlines {
      
      if elementArray[1] != currentCareer {
        
        currentCareer = elementArray[1]
        
        let tableCell:UIView = UIView()
        let careerName:UILabel = UILabel()
        
        deadlineScrollView.addSubview(tableCell)
        tableCell.translatesAutoresizingMaskIntoConstraints = false
        let tableCellTop:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat((i+j)*cellHeight))
        let tableCellLeft:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 10)
        deadlineScrollView.addConstraints([tableCellTop,tableCellLeft])
        let tableCellWidth:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(self.deadlinesView.bounds.width))
        let tableCellHeight:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(cellHeight))
        tableCell.addConstraints([tableCellHeight,tableCellWidth])
        
        tableCell.backgroundColor = UIColor.white
        
        tableCell.addSubview(careerName)

        careerName.translatesAutoresizingMaskIntoConstraints = false
        careerName.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        careerName.numberOfLines = 0
        let textSize2 = self.getTextSize(15)
        careerName.font = UIFont(name: "HelveticaNeue-Medium", size: textSize2)
        careerName.textAlignment = NSTextAlignment.left
        careerName.textColor = self.careerColors[currentCareer]
        careerName.text = elementArray[1].uppercased()

        j += 1
      }
      
      let tableCell:JobDeadlineView = JobDeadlineView()
      let companyName:UILabel = UILabel()
      let positionName:UILabel = UILabel()
      
      deadlineScrollView.addSubview(tableCell)
      tableCell.translatesAutoresizingMaskIntoConstraints = false
      let tableCellWidth:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(self.deadlinesView.bounds.width))
      let tableCellHeight:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(cellHeight))
      tableCell.addConstraints([tableCellHeight,tableCellWidth])
      let tableCellTop:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat((i+j)*cellHeight))
      let tableCellLeft:NSLayoutConstraint = NSLayoutConstraint(item: tableCell, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: deadlineScrollView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
      deadlineScrollView.addConstraints([tableCellTop,tableCellLeft])
      
//      if (i%2==0) {
//        tableCell.backgroundColor = UIColor.whiteColor()
//      }
//      else {
//        tableCell.backgroundColor = UIColor.whiteColor()
//      }
      
      tableCell.careerColorView.backgroundColor = self.careerColors[currentCareer]
      
      tableCell.addSubview(companyName)
      tableCell.addSubview(positionName)
      companyName.translatesAutoresizingMaskIntoConstraints = false
      positionName.translatesAutoresizingMaskIntoConstraints = false
      companyName.setConstraintsToSuperview(5, bottom: 25, left: 10, right: 5)
      positionName.setConstraintsToSuperview(25, bottom: 5, left: 10, right: 5)
      companyName.numberOfLines = 0
      positionName.numberOfLines = 0
      let textSize2 = self.getTextSize(14)
      companyName.font = UIFont(name: "HelveticaNeue-MediumBold", size: textSize2)
      companyName.textAlignment = NSTextAlignment.left
      positionName.font = UIFont(name: "HelveticaNeue-LightItalic", size: textSize2)
      positionName.textAlignment = NSTextAlignment.left
      positionName.textColor = UIColor.gray.withAlphaComponent(1)
      
      companyName.text = elementArray[0]
      positionName.text = elementArray[2]
      
      i += 1
      
    }
    
    //Set content size
    deadlineScrollView.contentSize = CGSize(width: Int(self.deadlinesView.bounds.width), height: Int((i+j)*cellHeight))
    
  }
  
  func backToCalendarView(_ sender: UITapGestureRecognizer) {
    
    self.flushCounter += 1
    
    UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: {
      
      self.monthTitleButton.alpha = 1
      self.nextMonthButton.alpha = 1
      self.previousMonthButton.alpha = 1
      self.monthScrollView.alpha = 1
      self.deadlinesView.alpha = 0
      self.updateDeadlinesButton.alpha = 1
        
      }, completion: nil)
  }
  
  func deadlinesViewTapped(_ sender: UITapGestureRecognizer) {
    
    UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: {
      
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
    
    let query1 = PFQuery(className: PF_CALENDAR_CLASS_NAME)
    let query2 = PFQuery(className: PF_CALENDAR_CLASS_NAME)
    query1.whereKey(PF_CALENDAR_DEADLINEMONTH, equalTo: self.currentMonth)
    query1.whereKey(PF_CALENDAR_DEADLINEYEAR, equalTo: self.currentYear)
    query2.whereKey(PF_CALENDAR_DEADLINEYEAR, equalTo: 2000)
    
    let query = PFQuery.orQuery(withSubqueries: [query1, query2])
    
    query.findObjectsInBackground {
      (objects: [PFObject]?, error: Error?) -> Void in
      
      if error == nil {
        
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) job deadlines.")
        
        // Do something with the found objects
        if let objects = objects {
          
          let todaysMonth:Int = (self.userCalendar as NSCalendar).component(NSCalendar.Unit.month, from: self.todaysDate)
          
          for object in objects {
            
            if objects.count >= 0 {
              
              var deadlinesIndividual:[String:AnyObject] = [:]
              
              print(object[PF_CALENDAR_CAREERTYPE] as! String)
              print(self.chosenCareers)
              
              if self.chosenCareers.contains(object[PF_CALENDAR_CAREERTYPE] as! String) {
                
                if object[PF_CALENDAR_DEADLINEYEAR] as! Int == 2000 {
                  if self.currentMonth == todaysMonth {
                    deadlinesIndividual.updateValue((self.userCalendar as NSCalendar).component(NSCalendar.Unit.year, from: self.todaysDate) as AnyObject, forKey: "year")
                    deadlinesIndividual.updateValue(todaysMonth as AnyObject, forKey: "month")
                    deadlinesIndividual.updateValue((self.userCalendar as NSCalendar).component(NSCalendar.Unit.day, from: self.todaysDate) as AnyObject, forKey: "day")
                    deadlinesIndividual.updateValue(object[PF_CALENDAR_COMPANY] as! String as AnyObject, forKey: "company")
                    deadlinesIndividual.updateValue(object[PF_CALENDAR_CAREERTYPE] as! String as AnyObject, forKey: "career")
                    deadlinesIndividual.updateValue(object[PF_CALENDAR_JOBTITLE] as! String as AnyObject, forKey: "position")
                    
                    deadlinesTemp.append(deadlinesIndividual)
                  }
                }
                else {
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEYEAR] as! Int as AnyObject, forKey: "year")
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEMONTH] as! Int as AnyObject, forKey: "month")
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_DEADLINEDAY] as! Int as AnyObject, forKey: "day")
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_COMPANY] as! String as AnyObject, forKey: "company")
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_CAREERTYPE] as! String as AnyObject, forKey: "career")
                  deadlinesIndividual.updateValue(object[PF_CALENDAR_JOBTITLE] as! String as AnyObject, forKey: "position")
                  
                  deadlinesTemp.append(deadlinesIndividual)
                }
                
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
        self.monthViews[1].deadlines = deadlinesTemp.sorted {
          if ($0["career"] as? String) == ($1["career"] as? String) {
            if ($0["company"] as? String) == ($1["company"] as? String) {
              return ($0["position"] as? String) < ($1["position"] as? String)
            }
            else {
              return ($0["company"] as? String) < ($1["company"] as? String)
            }
          }
          else {
            return ($0["career"] as? String) < ($1["career"] as? String)
          }
        }
        self.monthViews[1].displayView()
        
        let dateFormatter:DateFormatter = DateFormatter()
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
