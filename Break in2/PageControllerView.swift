//
//  TestPageControllerView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 13/11/2015.
//  Copyright © 2015 Sangeet Shah. All rights reserved.
//

import UIKit

class PageControllerView: UIView {
  
  let pageControllerModel:JSONModel = JSONModel()
  
  // Declare and initialize types colors for page controller
  
  var pageControllerColors:[UIColor] = [UIColor]()
  
  // Declare and initialize drawing properties
  
  var pageControllerCircleRects:[CGRect] = [CGRect]()
  
  var selectedPageIndex:Int = 0
  var numberOfPages:Int = 1
  
  // Declare and initialize design constants
  
  var minorMargin:CGFloat = CGFloat()
  
  var pageControllerCircleHeight:CGFloat = UIScreen.main.bounds.height/60
  var pageControllerSelectedCircleHeight:CGFloat = (UIScreen.main.bounds.height/60) + 8
  var pageControllerSelectedCircleThickness:CGFloat = 2
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.isOpaque = false
    
    // Get colors
    
    self.pageControllerColors = self.pageControllerModel.getAppColors()
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

    /* Only override drawRect: if you perform custom drawing.
    An empty implementation adversely affects performance during animation. */
  
  override func draw(_ rect: CGRect) {
      
    // Drawing code
    
    // Get graphics context
    
    let pageControllerContext:CGContext = UIGraphicsGetCurrentContext()!
    
    // Create as many page controller circles as there are types of test
    
    for index:Int in stride(from: 0, to: self.numberOfPages, by: 1) {
      
      // Set the fill color to randomColor
      
      if index < self.pageControllerColors.count {
        pageControllerContext.setFillColor(self.pageControllerColors[index].cgColor)
        pageControllerContext.setStrokeColor(self.pageControllerColors[index].cgColor)
        
        pageControllerContext.setStrokeColor(self.pageControllerColors[index].cgColor)
      }
      else {
        pageControllerContext.setFillColor(UIColor.turquoiseColor().cgColor)
        pageControllerContext.setStrokeColor(UIColor.turquoiseColor().cgColor)
        
        pageControllerContext.setStrokeColor(UIColor.turquoiseColor().cgColor)
        
        self.pageControllerColors.append(UIColor.turquoiseColor())
      }
      
      // Create CGRects that surround the page controller cirlces
      
      let leftmostCircleLeadingEdgeXCoordinate:CGFloat = (self.bounds.size.width / 2) - (self.pageControllerCircleHeight * CGFloat(self.numberOfPages) / 2) - (CGFloat(self.numberOfPages - 1) * self.minorMargin)
      let circleSpacing:CGFloat = (CGFloat(index) * (self.pageControllerCircleHeight + (2 * self.minorMargin)))
      
      let circleRect:CGRect = CGRect(x: leftmostCircleLeadingEdgeXCoordinate + circleSpacing, y: (self.bounds.size.height / 2) - (self.pageControllerCircleHeight / 2), width: self.pageControllerCircleHeight, height: self.pageControllerCircleHeight)
      self.pageControllerCircleRects.append(circleRect)
      
      // Draw page controller circles
      
      pageControllerContext.fillEllipse(in: circleRect)
      
    }
    
    // Set the stroke color and thickness to the color of the leftmost circle
    
    pageControllerContext.setStrokeColor(self.pageControllerColors[self.selectedPageIndex].cgColor)
    pageControllerContext.setLineWidth(self.pageControllerSelectedCircleThickness)
    
    // Draw outer circle for selected circle
    
    let strokeRect:CGRect = CGRect(x: self.pageControllerCircleRects[self.selectedPageIndex].origin.x - ((self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight) / 2), y: self.pageControllerCircleRects[self.selectedPageIndex].origin.y - ((self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight) / 2), width: self.pageControllerCircleRects[self.selectedPageIndex].width + (self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight), height: self.pageControllerCircleRects[self.selectedPageIndex].height + (self.pageControllerSelectedCircleHeight - self.pageControllerCircleHeight))
    pageControllerContext.strokeEllipse(in: strokeRect)
    
 }
  
  func updatePageController (_ selectedPageIndex: Int) {
    
    self.selectedPageIndex = selectedPageIndex
    self.setNeedsDisplay()
    
  }
  
}
