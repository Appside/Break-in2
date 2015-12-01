//
//  TestPageControllerView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 13/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class PageControllerView: UIView {
  
  // Declare and initialize types of tests array in super.testTypeViews
  
  var testTypes:[String] = [String]()
  
  // Declare and initialize drawing properties
  
  var pageControllerCircleColors:[CGColor] = [CGColor]()
  var pageControllerCircleRects:[CGRect] = [CGRect]()
  
  var selectedPageIndex:Int = 0
  var randomColorsGenerated:Bool = false
  
  // Declare and initialize design constants
  
  var minorMargin:CGFloat = CGFloat()
  
  var pageControllerCircleHeight:CGFloat = 20
  var pageControllerSelectedCircleHeight:CGFloat = 20
  var pageControllerSelectedCircleThickness:CGFloat = 2
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.opaque = false
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

    /* Only override drawRect: if you perform custom drawing.
    An empty implementation adversely affects performance during animation. */
  
  override func drawRect(rect: CGRect) {
      
    // Drawing code
    
    // Get graphics context
    
    let pageControllerContext:CGContextRef = UIGraphicsGetCurrentContext()!
    
    // Create as many page controller circles as there are types of test
    
    for var index:Int = 0 ; index < self.testTypes.count ; index++ {
      
      
      if !self.randomColorsGenerated {
        
        // Create a random color and save it
        
        let red:CGFloat = (CGFloat(arc4random_uniform(2)) * 0.5)
        let green:CGFloat = (CGFloat(arc4random_uniform(2)) * 0.5)
        let blue:CGFloat = (CGFloat(arc4random_uniform(2)) * 0.5)
        
        let randomColor:CGColor = UIColor.init(red: red , green: green, blue: blue, alpha: 1).CGColor
        
        self.pageControllerCircleColors.append(randomColor)
        
      }
      
      // Set the fill color to randomColor
      
      CGContextSetFillColorWithColor(pageControllerContext, self.pageControllerCircleColors[index])
      CGContextSetStrokeColorWithColor(pageControllerContext, self.pageControllerCircleColors[index])
      
      // Create CGRects that surround the page controller cirlces
      
      let leftmostCircleLeadingEdgeXCoordinate:CGFloat = (self.bounds.size.width / 2) - (self.pageControllerCircleHeight * CGFloat(self.testTypes.count) / 2) - (CGFloat(self.testTypes.count - 1) * self.minorMargin)
      let circleSpacing:CGFloat = (CGFloat(index) * (self.pageControllerCircleHeight + (2 * self.minorMargin)))
      
      let circleRect:CGRect = CGRectMake(leftmostCircleLeadingEdgeXCoordinate + circleSpacing, (self.bounds.size.height / 2) - (self.pageControllerCircleHeight / 2), self.pageControllerCircleHeight, self.pageControllerCircleHeight)
      self.pageControllerCircleRects.append(circleRect)
      
      // Draw page controller circles
      
      CGContextFillEllipseInRect(pageControllerContext, circleRect)
      
    }
    
    self.randomColorsGenerated = true
    
    // Set the stroke color and thickness to the color of the leftmost circle
    
    CGContextSetStrokeColorWithColor(pageControllerContext, self.pageControllerCircleColors[self.selectedPageIndex])
    CGContextSetLineWidth(pageControllerContext, self.pageControllerSelectedCircleThickness)
    
    // Draw outer circle for selected circle
    
    let strokeRect:CGRect = CGRectMake(self.pageControllerCircleRects[self.selectedPageIndex].origin.x - ((self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight) / 2), self.pageControllerCircleRects[self.selectedPageIndex].origin.y - ((self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight) / 2), self.pageControllerCircleRects[self.selectedPageIndex].width + (self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight), self.pageControllerCircleRects[self.selectedPageIndex].height + (self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight))
    CGContextStrokeEllipseInRect(pageControllerContext, strokeRect)
    
 }
  
  func updatePageController (selectedPageIndex: Int) {
    
    self.selectedPageIndex = selectedPageIndex
    self.setNeedsDisplay()
    
  }
  
}
