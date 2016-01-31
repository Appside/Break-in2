//
//  CalendarDayButton.swift
//  Break in2
//
//  Created by Sangeet on 16/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarDayButton: UIButton {
  
  let calendarModel:JSONModel = JSONModel()
  
  var careerTypes:[String] = [String]()
  var circleColors:[String:UIColor] = [String:UIColor]()
  
  var year:Int = 0
  var month:Int = 0
  var day:Int = 0
  var deadlines:[[String]] = [[String]]()
  
  var today:Bool = false
  var clicked:Bool = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let textSize:CGFloat = self.getTextSize(14)
    self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: textSize)
    
    // Get app variables
    
    self.careerTypes = self.calendarModel.getAppVariables("careerTypes") as! [String]
    
    let appColors:[UIColor] = self.calendarModel.getAppColors()
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      self.circleColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func drawRect(rect: CGRect) {
        // Drawing code
    
    if self.today {
      
      let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
      
      CGContextSetFillColorWithColor(contextRef, UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.5).CGColor)
      
      CGContextFillEllipseInRect(contextRef, CGRectMake((self.bounds.width - self.bounds.height)/2, 0, self.bounds.height, self.bounds.height))
      
    }
    
    if self.clicked {
      
      let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
      var careers:[String] = [String]()
      
      for var index:Int = 0 ; index < self.deadlines.count ; index++ {
        
        if !careers.contains(self.deadlines[index][1]) {
          careers.append(self.deadlines[index][1])
        }
        
      }
      
      for var index:Int = 0 ; index < careers.count ; index++ {
        
        CGContextSetFillColorWithColor(contextRef, self.circleColors[careers[index]]!.CGColor)
        
        CGContextBeginPath(contextRef)
        let arcSegmentAngle:Double = (2 * M_PI) / Double(careers.count)
        CGContextMoveToPoint(contextRef, self.bounds.width/2, self.bounds.height/2)
        if self.today {
          CGContextAddArc(contextRef, self.bounds.width/2, self.bounds.height/2, (self.bounds.height/2) - 2, CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index))), CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index + 1))), 0)
        }
        else {
          CGContextAddArc(contextRef, self.bounds.width/2, self.bounds.height/2, self.bounds.height/2, CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index))), CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index + 1))), 0)
        }
        CGContextFillPath(contextRef)
      }
      
    }
    else {
      
      let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
      
      CGContextSetFillColorWithColor(contextRef, UIColor.clearColor().CGColor)
      
      CGContextFillEllipseInRect(contextRef, CGRectMake((self.bounds.width - self.bounds.height)/2, 0, self.bounds.height, self.bounds.height))
      
    }
    
  }
  
  func convertDegreesToRadians(degrees:Double) -> Double {
    
    return degrees * (M_PI/180)
  
  }

}
