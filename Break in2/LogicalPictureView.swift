//
//  LogicalPictureView.swift
//  Break in2
//
//  Created by Sangeet on 14/01/2016.
//  Copyright © 2016 Sangeet Shah. All rights reserved.
//

import UIKit

class LogicalPictureView: UIView {
  
  let drawingColor:UIColor = UIColor.turquoiseColor()
  var shapeToDraw:[String] = [String]()
  var isShaded:Bool = false
  var shapeSize:Int = 1
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clearColor()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    var drawRect:CGRect = CGRect()
    
    let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextSetStrokeColorWithColor(contextRef, self.drawingColor.CGColor)
    CGContextSetFillColorWithColor(contextRef, self.drawingColor.CGColor)
    CGContextSetLineWidth(contextRef, 2)
    
    if self.shapeToDraw.count == 1 {
      
      if self.shapeSize == 1 {
        drawRect = CGRectMake(self.bounds.width * 0.1, self.bounds.height * 0.1, self.bounds.width * 0.8, self.bounds.height * 0.8)
      }
      else if self.shapeSize == 2 {
        drawRect = CGRectMake(self.bounds.width * 0.2, self.bounds.height * 0.2, self.bounds.width * 0.6, self.bounds.height * 0.6)
      }
      else if self.shapeSize == 3 {
        drawRect = CGRectMake(self.bounds.width * 0.3, self.bounds.height * 0.3, self.bounds.width * 0.4, self.bounds.height * 0.4)
      }
      
      if self.shapeToDraw[0] == "Circle" {
        self.drawCircle(contextRef, inRect: drawRect)
      }
      else if self.shapeToDraw[0] == "Square" {
        self.drawSquare(contextRef, inRect: drawRect)
      }
      else if self.shapeToDraw[0] == "Octagon" {
        self.drawOctagon(contextRef, inRect: drawRect)
      }
      else if self.shapeToDraw[0] == "Triangle" {
        self.drawTriangle(contextRef, inRect: drawRect)
      }
      else if self.shapeToDraw[0] == "Rhombus" {
        self.drawRhombus(contextRef, inRect: drawRect)
      }
      
    }
    else if self.shapeToDraw.count == 3 {
      
      var drawRects:[CGRect] = [CGRect]()
      drawRects.append(CGRectMake(self.bounds.width * 0.1, self.bounds.height * 0.1, self.bounds.width * 0.8, self.bounds.height * 0.8))
      drawRects.append(CGRectMake(self.bounds.width * 0.25, self.bounds.height * 0.25, self.bounds.width * 0.5, self.bounds.height * 0.5))
      drawRects.append(CGRectMake(self.bounds.width * 0.4, self.bounds.height * 0.4, self.bounds.width * 0.2, self.bounds.height * 0.2))
      if self.shapeToDraw[0] == "Rhombus" {
        drawRects[0] = CGRectMake(self.bounds.width * 0.05, self.bounds.height * 0.05, self.bounds.width * 0.9, self.bounds.height * 0.9)
        if self.shapeToDraw[1] == "Square" {
          drawRects[1] = CGRectMake(self.bounds.width * 0.3, self.bounds.height * 0.3, self.bounds.width * 0.4, self.bounds.height * 0.4)
        }
      }
      if self.shapeToDraw[1] == "Rhombus" {
        drawRects[1] = CGRectMake(self.bounds.width * 0.2, self.bounds.height * 0.2, self.bounds.width * 0.6, self.bounds.height * 0.6)
      }
      
      for var index:Int = 0 ; index < self.shapeToDraw.count ; index++ {
        
        if self.shapeToDraw[index] == "Circle" {
          self.drawCircle(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Square" {
          self.drawSquare(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Octagon" {
          self.drawOctagon(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Triangle" {
          self.drawTriangle(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Rhombus" {
          self.drawRhombus(contextRef, inRect: drawRects[index])
        }
        
      }
      
    }
    else if self.shapeToDraw.count == 4 {
      
      var drawRects:[CGRect] = [CGRect]()
      drawRects.append(CGRectMake(self.bounds.width * 0.1, self.bounds.height * 0.1, self.bounds.width * 0.3, self.bounds.height * 0.3))
      drawRects.append(CGRectMake(self.bounds.width * 0.6, self.bounds.height * 0.1, self.bounds.width * 0.3, self.bounds.height * 0.3))
      drawRects.append(CGRectMake(self.bounds.width * 0.1, self.bounds.height * 0.6, self.bounds.width * 0.3, self.bounds.height * 0.3))
      drawRects.append(CGRectMake(self.bounds.width * 0.6, self.bounds.height * 0.6, self.bounds.width * 0.3, self.bounds.height * 0.3))
      
      for var index:Int = 0 ; index < self.shapeToDraw.count ; index++ {
        
        if self.shapeToDraw[index] == "Circle" {
          self.drawCircle(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Square" {
          self.drawSquare(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Octagon" {
          self.drawOctagon(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Triangle" {
          self.drawTriangle(contextRef, inRect: drawRects[index])
        }
        else if self.shapeToDraw[index] == "Rhombus" {
          self.drawRhombus(contextRef, inRect: drawRects[index])
        }
        
      }
      
    }
    
  }
  
  func drawCircle(contextRef:CGContextRef, inRect:CGRect) {
    
    if self.isShaded {
      CGContextFillEllipseInRect(contextRef, inRect)
    }
    else {
      CGContextStrokeEllipseInRect(contextRef, inRect)
    }
    
  }
  
  func drawSquare(contextRef:CGContextRef, inRect:CGRect) {
    
    CGContextBeginPath(contextRef)
    CGContextMoveToPoint(contextRef, inRect.origin.x, inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y)
    if self.isShaded {
      CGContextFillPath(contextRef)
    }
    else {
      CGContextStrokePath(contextRef)
    }
  }
  
  func drawTriangle(contextRef:CGContextRef, inRect:CGRect) {
    
    CGContextBeginPath(contextRef)
    CGContextMoveToPoint(contextRef, inRect.origin.x, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + (inRect.width/2), inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y + inRect.height)
    if self.isShaded {
      CGContextFillPath(contextRef)
    }
    else {
      CGContextStrokePath(contextRef)
    }
  }
  
  func drawOctagon(contextRef:CGContextRef, inRect:CGRect) {
    
    let octagonSideLength:CGFloat = inRect.width/(1 + (2 * cos(45)))
    let rectOctagonGap:CGFloat = (inRect.width - octagonSideLength)/2
    
    CGContextBeginPath(contextRef)
    CGContextMoveToPoint(contextRef, inRect.origin.x + rectOctagonGap, inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + rectOctagonGap + octagonSideLength, inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y + rectOctagonGap)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y + rectOctagonGap + octagonSideLength)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + rectOctagonGap + octagonSideLength, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + rectOctagonGap, inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y + rectOctagonGap + octagonSideLength)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y + rectOctagonGap)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + rectOctagonGap, inRect.origin.y)
    if self.isShaded {
      CGContextFillPath(contextRef)
    }
    else {
      CGContextStrokePath(contextRef)
    }
  }
  
  func drawRhombus(contextRef:CGContextRef, inRect:CGRect) {
    
    CGContextBeginPath(contextRef)
    CGContextMoveToPoint(contextRef, inRect.origin.x + (inRect.width/2), inRect.origin.y)
    CGContextAddLineToPoint(contextRef, inRect.origin.x + inRect.width, inRect.origin.y + (inRect.height/2))
    CGContextAddLineToPoint(contextRef, inRect.origin.x + (inRect.width/2), inRect.origin.y + inRect.height)
    CGContextAddLineToPoint(contextRef, inRect.origin.x, inRect.origin.y + (inRect.height/2))
    CGContextAddLineToPoint(contextRef, inRect.origin.x + (inRect.width/2), inRect.origin.y)
    if self.isShaded {
      CGContextFillPath(contextRef)
    }
    else {
      CGContextStrokePath(contextRef)
    }
  }
  
}
