//
//  LabelPointerView.swift
//  TestSelectionScreen
//
//  Created by Sangeet on 03/01/2016.
//  Copyright © 2016 Sangeet Shah. All rights reserved.
//

import UIKit

class LabelPointerView: UIView {
    
    let labelPointerColor:UIColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1)
    
    var labelPointerBaseWidth:CGFloat = 20
    var labelPointerMidX:CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        let contextRef:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(contextRef, UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1).CGColor)
        
        CGContextBeginPath(contextRef)
        CGContextMoveToPoint(contextRef, self.labelPointerMidX - (self.labelPointerBaseWidth/2), 0)
        CGContextAddLineToPoint(contextRef, self.labelPointerMidX, self.frame.height)
        CGContextAddLineToPoint(contextRef, self.labelPointerMidX + (self.labelPointerBaseWidth/2), 0)
        CGContextAddLineToPoint(contextRef, self.labelPointerMidX - (self.labelPointerBaseWidth/2), 0)
        CGContextFillPath(contextRef)
        
    }
    
    func moveLabelPointer(xPosition:CGFloat) {
        
        self.labelPointerMidX = xPosition
        self.setNeedsDisplay()
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}