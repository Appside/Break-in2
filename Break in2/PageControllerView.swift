//
//  TestPageControllerView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 13/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class PageControllerView: UIView {
  
  // Declare and initialize types colors for page controller
  
  var pageControllerColors:[UIColor] = [UIColor.init(red: 208/255, green: 2/255, blue: 27/255, alpha: 1),UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1),UIColor.init(red: 126/255, green: 211/255, blue: 33/255, alpha: 1),UIColor.init(red: 248/255, green: 231/255, blue: 28/255, alpha: 1)]
  
  // Declare and initialize drawing properties
  
  var pageControllerCircleRects:[CGRect] = [CGRect]()
  
  var selectedPageIndex:Int = 0
  var numberOfPages:Int = 1
  
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
    
    for var index:Int = 0 ; index < self.numberOfPages ; index++ {
      
      // Set the fill color to randomColor
      
      if index < self.pageControllerColors.count {
        CGContextSetFillColorWithColor(pageControllerContext, self.pageControllerColors[index].CGColor)
        CGContextSetStrokeColorWithColor(pageControllerContext, self.pageControllerColors[index].CGColor)
        
        CGContextSetStrokeColorWithColor(pageControllerContext, self.pageControllerColors[index].CGColor)
      }
      else {
        CGContextSetFillColorWithColor(pageControllerContext, UIColor.turquoiseColor().CGColor)
        CGContextSetStrokeColorWithColor(pageControllerContext, UIColor.turquoiseColor().CGColor)
        
        CGContextSetStrokeColorWithColor(pageControllerContext, UIColor.turquoiseColor().CGColor)
        
        self.pageControllerColors.append(UIColor.turquoiseColor())
      }
      
      // Create CGRects that surround the page controller cirlces
      
      let leftmostCircleLeadingEdgeXCoordinate:CGFloat = (self.bounds.size.width / 2) - (self.pageControllerCircleHeight * CGFloat(self.numberOfPages) / 2) - (CGFloat(self.numberOfPages - 1) * self.minorMargin)
      let circleSpacing:CGFloat = (CGFloat(index) * (self.pageControllerCircleHeight + (2 * self.minorMargin)))
      
      let circleRect:CGRect = CGRectMake(leftmostCircleLeadingEdgeXCoordinate + circleSpacing, (self.bounds.size.height / 2) - (self.pageControllerCircleHeight / 2), self.pageControllerCircleHeight, self.pageControllerCircleHeight)
      self.pageControllerCircleRects.append(circleRect)
      
      // Draw page controller circles
      
      CGContextFillEllipseInRect(pageControllerContext, circleRect)
      
    }
    
    // Set the stroke color and thickness to the color of the leftmost circle
    
    CGContextSetStrokeColorWithColor(pageControllerContext, self.pageControllerColors[self.selectedPageIndex].CGColor)
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
