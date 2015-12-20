//
//  CalendarDayButton.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 16/12/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class CalendarDayButton: UIButton {
  
  var circleColors:[UIColor] = [UIColor.init(red: 208/255, green: 2/255, blue: 27/255, alpha: 0.5),UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 0.5),UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 0.5),UIColor.init(red: 248/255, green: 231/255, blue: 28/255, alpha: 0.5)]
  
  var today:Bool = false
  var clicked:Bool = false
  var numberOfCirlceSegments:Int = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 14)
    
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
      
      for var index:Int = 0 ; index < self.numberOfCirlceSegments ; index++ {
      
        CGContextSetFillColorWithColor(contextRef, self.circleColors[index].CGColor)
        
        CGContextBeginPath(contextRef)
        CGContextMoveToPoint(contextRef, self.bounds.width/2, self.bounds.height/2)
        let arcSegmentAngle:Double = (2 * M_PI) / Double(self.numberOfCirlceSegments)
        if self.today {
          CGContextAddArc(contextRef, self.bounds.width/2, self.bounds.height/2, (self.bounds.height/2) - 4, CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index))), CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index + 1))), 0)
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
  
  func drawCircle (numberOfSegments: Int) {
    
    self.numberOfCirlceSegments = numberOfSegments
    self.setNeedsDisplay()
    
  }
  
  func convertDegreesToRadians(degrees:Double) -> Double {
    
    return degrees * (M_PI/180)
  
  }

}
