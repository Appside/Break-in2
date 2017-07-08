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
    self.setTitleColor(UIColor.black, for: UIControlState())
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: textSize)
    
    // Get app variables
    
    self.careerTypes = self.calendarModel.getAppVariables("careerTypes") as! [String]
    
    let appColors:[UIColor] = self.calendarModel.getAppColors()
    for index:Int in stride(from: 0, to: self.careerTypes.count, by: 1) {
      self.circleColors.updateValue(appColors[index], forKey: self.careerTypes[index])
    }

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
        // Drawing code
    
    if self.today {
      
      let contextRef:CGContext = UIGraphicsGetCurrentContext()!
      
      contextRef.setFillColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.5).cgColor)
      
      contextRef.fillEllipse(in: CGRect(x: (self.bounds.width - (self.bounds.height - 2))/2, y: 1, width: self.bounds.height - 2, height: self.bounds.height - 2))
      
    }
    
    if self.clicked {
      
      let contextRef:CGContext = UIGraphicsGetCurrentContext()!
      var careers:[String] = [String]()
      
      for index:Int in stride(from: 0, to: self.deadlines.count, by: 1) {
        
        if !careers.contains(self.deadlines[index][1]) {
          careers.append(self.deadlines[index][1])
        }
        
      }
      
      for index:Int in stride(from: 0, to: careers.count, by: 1) {
        
        contextRef.setFillColor(self.circleColors[careers[index]]!.cgColor)
        
        contextRef.beginPath()
        let arcSegmentAngle:Double = (2 * M_PI) / Double(careers.count)
        contextRef.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2))
        if self.today {
          CGContextAddArc(contextRef, self.bounds.width/2, self.bounds.height/2, (self.bounds.height/2) - 3, CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index))), CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index + 1))), 0)
        }
        else {
          CGContextAddArc(contextRef, self.bounds.width/2, self.bounds.height/2, (self.bounds.height/2) - 1, CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index))), CGFloat((M_PI_2 * -1) + (arcSegmentAngle * Double(index + 1))), 0)
        }
        contextRef.fillPath()
      }
      
    }
    else {
      
      let contextRef:CGContext = UIGraphicsGetCurrentContext()!
      
      contextRef.setFillColor(UIColor.clear.cgColor)
      
      contextRef.fillEllipse(in: CGRect(x: (self.bounds.width - self.bounds.height)/2, y: 0, width: self.bounds.height, height: self.bounds.height))
      
    }
    
  }
  
  func convertDegreesToRadians(_ degrees:Double) -> Double {
    
    return degrees * (M_PI/180)
  
  }

}
