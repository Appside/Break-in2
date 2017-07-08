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
    
    self.backgroundColor = UIColor.clear
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    var drawRect:CGRect = CGRect()
    
    let contextRef:CGContext = UIGraphicsGetCurrentContext()!
    contextRef.setStrokeColor(self.drawingColor.cgColor)
    contextRef.setFillColor(self.drawingColor.cgColor)
    contextRef.setLineWidth(2)
    
    if self.shapeToDraw.count == 1 {
      
      if self.shapeSize == 1 {
        drawRect = CGRect(x: self.bounds.width * 0.1, y: self.bounds.height * 0.1, width: self.bounds.width * 0.8, height: self.bounds.height * 0.8)
      }
      else if self.shapeSize == 2 {
        drawRect = CGRect(x: self.bounds.width * 0.2, y: self.bounds.height * 0.2, width: self.bounds.width * 0.6, height: self.bounds.height * 0.6)
      }
      else if self.shapeSize == 3 {
        drawRect = CGRect(x: self.bounds.width * 0.3, y: self.bounds.height * 0.3, width: self.bounds.width * 0.4, height: self.bounds.height * 0.4)
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
      drawRects.append(CGRect(x: self.bounds.width * 0.1, y: self.bounds.height * 0.1, width: self.bounds.width * 0.8, height: self.bounds.height * 0.8))
      drawRects.append(CGRect(x: self.bounds.width * 0.25, y: self.bounds.height * 0.25, width: self.bounds.width * 0.5, height: self.bounds.height * 0.5))
      drawRects.append(CGRect(x: self.bounds.width * 0.4, y: self.bounds.height * 0.4, width: self.bounds.width * 0.2, height: self.bounds.height * 0.2))
      if self.shapeToDraw[0] == "Rhombus" {
        drawRects[0] = CGRect(x: self.bounds.width * 0.05, y: self.bounds.height * 0.05, width: self.bounds.width * 0.9, height: self.bounds.height * 0.9)
        if self.shapeToDraw[1] == "Square" {
          drawRects[1] = CGRect(x: self.bounds.width * 0.3, y: self.bounds.height * 0.3, width: self.bounds.width * 0.4, height: self.bounds.height * 0.4)
        }
      }
      if self.shapeToDraw[1] == "Rhombus" {
        drawRects[1] = CGRect(x: self.bounds.width * 0.2, y: self.bounds.height * 0.2, width: self.bounds.width * 0.6, height: self.bounds.height * 0.6)
      }
      
      for index:Int in stride(from: 0, to: self.shapeToDraw.count, by: 1) {
        
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
      drawRects.append(CGRect(x: self.bounds.width * 0.1, y: self.bounds.height * 0.1, width: self.bounds.width * 0.3, height: self.bounds.height * 0.3))
      drawRects.append(CGRect(x: self.bounds.width * 0.6, y: self.bounds.height * 0.1, width: self.bounds.width * 0.3, height: self.bounds.height * 0.3))
      drawRects.append(CGRect(x: self.bounds.width * 0.1, y: self.bounds.height * 0.6, width: self.bounds.width * 0.3, height: self.bounds.height * 0.3))
      drawRects.append(CGRect(x: self.bounds.width * 0.6, y: self.bounds.height * 0.6, width: self.bounds.width * 0.3, height: self.bounds.height * 0.3))
      
      for index:Int in stride(from: 0, to: self.shapeToDraw.count, by: 1) {
        
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
  
  func drawCircle(_ contextRef:CGContext, inRect:CGRect) {
    
    if self.isShaded {
      contextRef.fillEllipse(in: inRect)
    }
    else {
      contextRef.strokeEllipse(in: inRect)
    }
    
  }
  
  func drawSquare(_ contextRef:CGContext, inRect:CGRect) {
    
    contextRef.beginPath()
    contextRef.move(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y))
    if self.isShaded {
      contextRef.fillPath()
    }
    else {
      contextRef.strokePath()
    }
  }
  
  func drawTriangle(_ contextRef:CGContext, inRect:CGRect) {
    
    contextRef.beginPath()
    contextRef.move(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + (inRect.width/2), y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + inRect.height))
    if self.isShaded {
      contextRef.fillPath()
    }
    else {
      contextRef.strokePath()
    }
  }
  
  func drawOctagon(_ contextRef:CGContext, inRect:CGRect) {
    
    let octagonSideLength:CGFloat = inRect.width/(1 + (2 * cos(45)))
    let rectOctagonGap:CGFloat = (inRect.width - octagonSideLength)/2
    
    contextRef.beginPath()
    contextRef.move(to: CGPoint(x: inRect.origin.x + rectOctagonGap, y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + rectOctagonGap + octagonSideLength, y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y + rectOctagonGap))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y + rectOctagonGap + octagonSideLength))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + rectOctagonGap + octagonSideLength, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + rectOctagonGap, y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + rectOctagonGap + octagonSideLength))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + rectOctagonGap))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + rectOctagonGap, y: inRect.origin.y))
    if self.isShaded {
      contextRef.fillPath()
    }
    else {
      contextRef.strokePath()
    }
  }
  
  func drawRhombus(_ contextRef:CGContext, inRect:CGRect) {
    
    contextRef.beginPath()
    contextRef.move(to: CGPoint(x: inRect.origin.x + (inRect.width/2), y: inRect.origin.y))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + inRect.width, y: inRect.origin.y + (inRect.height/2)))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + (inRect.width/2), y: inRect.origin.y + inRect.height))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x, y: inRect.origin.y + (inRect.height/2)))
    contextRef.addLine(to: CGPoint(x: inRect.origin.x + (inRect.width/2), y: inRect.origin.y))
    if self.isShaded {
      contextRef.fillPath()
    }
    else {
      contextRef.strokePath()
    }
  }
  
}
