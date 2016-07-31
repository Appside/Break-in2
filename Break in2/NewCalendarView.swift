//
//  NewCalendarView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 26/07/2016.
//  Copyright © 2016 Sangeet Shah. All rights reserved.
//

import UIKit

class NewCalendarView: UIView, UIScrollViewDelegate {
  
  // Declare and initialize jobDeadlines
  
  var jobDeadlines:[[String:AnyObject]] = [[String:AnyObject]]()
  var chosenCareers:[String] = [String]()
  
  let monthTitleLabel:UILabel = UILabel()
  let nextMonthButton:UIButton = UIButton()
  let previousMonthButton:UIButton = UIButton()
  let monthScrollView:UIScrollView = UIScrollView()
  var monthViews:[NewMonthView] = [NewMonthView]()
  
  let todaysDate:NSDate = NSDate()
  let userCalendar:NSCalendar = NSCalendar.currentCalendar()
  let dateFormatter:NSDateFormatter = NSDateFormatter()
  var currentYear = 0
  var currentMonth:Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Set monthTitleLabel properties and add as subview to self
    
    self.monthTitleLabel.textAlignment = NSTextAlignment.Center
    self.monthTitleLabel.text = "Month"
    self.addSubview(self.monthTitleLabel)
    
    // Set nextMonthButton properties and add as subview to self
    
    self.nextMonthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.nextMonthButton.setTitle("Next", forState: UIControlState.Normal)
    self.nextMonthButton.titleLabel!.textAlignment = NSTextAlignment.Center
    self.nextMonthButton.addTarget(self, action: #selector(NewCalendarView.nextMonthButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.nextMonthButton)
    
    // Set previousMonthButton properties and add as subview to self
    
    self.previousMonthButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.previousMonthButton.setTitle("Prev", forState: UIControlState.Normal)
    self.previousMonthButton.titleLabel!.textAlignment = NSTextAlignment.Center
    self.previousMonthButton.addTarget(self, action: #selector(NewCalendarView.previousMonthButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.previousMonthButton)
    
    // Set monthScrollView properties and add as subview to self
    
    self.monthScrollView.pagingEnabled = true
    self.monthScrollView.delegate = self
    self.addSubview(self.monthScrollView)
    
    // Create current, next and previous monthViews
    
    for index:Int in 0.stride(through: 2, by: 1) {
      
      let monthViewAtIndex:NewMonthView = NewMonthView()
      
      // Set monthView properties and add as subview to monthScrollView
      
      self.monthScrollView.addSubview(monthViewAtIndex)
      
      // Add view to monthViews array
      
      self.monthViews.append(monthViewAtIndex)
      
    }
    
    // Get present year and present month
    
    self.currentYear = self.userCalendar.component(NSCalendarUnit.Year, fromDate: self.todaysDate)
    self.currentMonth = self.userCalendar.component(NSCalendarUnit.Month, fromDate: self.todaysDate)
    
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
    
    // Set monthTitleLabel
    
    let dateFormatter:NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let monthTitleString:String = dateFormatter.monthSymbols[self.currentMonth - 1] + " " + String(self.currentYear)
    self.monthTitleLabel.text = monthTitleString.uppercaseString
    
    // Move monthScrollView to the middle of the content size
    
    self.monthScrollView.setContentOffset(CGPointMake(self.monthScrollView.frame.width, 0), animated: false)
    
    // Set constraints
    
    self.setConstraints()
    self.layoutIfNeeded()
    
    // Display all monthViews
    for view:NewMonthView in self.monthViews {
      view.displayView()
    }
    
  }
  
  func setConstraints() {
    
    // Set constraints for monthTitleLabel
    
    self.monthTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    let monthTitleLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let monthTitleLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.frame.width/4)
    let monthTitleLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/2)
    let monthTitleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.monthTitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*2)
    self.addConstraints([monthTitleLabelTopConstraint,monthTitleLabelLeftConstraint])
    self.monthTitleLabel.addConstraints([monthTitleLabelWidthConstraint,monthTitleLabelHeightConstraint])
    
    // Set constraints for nextMonthButton
    
    self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let nextMonthButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let nextMonthButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: (self.frame.width/4)*3)
    let nextMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/4)
    let nextMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextMonthButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*2)
    self.addConstraints([nextMonthButtonTopConstraint,nextMonthButtonLeftConstraint])
    self.nextMonthButton.addConstraints([nextMonthButtonWidthConstraint,nextMonthButtonHeightConstraint])
    
    // Set constraints for previousMonthButton
    
    self.previousMonthButton.translatesAutoresizingMaskIntoConstraints = false
    let previousMonthButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let previousMonthButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    let previousMonthButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/4)
    let previousMonthButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousMonthButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.height/9)*2)
    self.addConstraints([previousMonthButtonTopConstraint,previousMonthButtonLeftConstraint])
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
    
  }
  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    
//    let currentMonthViewLocation = CGPointMake(0, self.monthScrollView.contentOffset.y)
//    let currentMonthViewSize = self.monthViews[0].frame.size
//    
//    self.monthViews[0].frame = CGRect(origin: currentMonthViewLocation, size: currentMonthViewSize)
//  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    if self.monthScrollView.contentOffset.x == (self.monthScrollView.frame.width * 2) {
      
      self.currentMonth += 1
      self.displayCalendar()
      
    }
    if self.monthScrollView.contentOffset.x == 0 {
      
      self.currentMonth -= 1
      self.displayCalendar()
      
    }
    
  }
  
  func nextMonthButtonClicked(sender: UIButton) {
    
    self.monthScrollView.setContentOffset(CGPointMake(self.frame.width*2, 0), animated: true)
    
  }
  
  func previousMonthButtonClicked(sender: UIButton) {
    
    self.monthScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    
  }
  
  


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
