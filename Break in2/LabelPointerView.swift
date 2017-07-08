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
        
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let contextRef:CGContext = UIGraphicsGetCurrentContext()!
        
        contextRef.setFillColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1).cgColor)
        
        contextRef.beginPath()
        contextRef.move(to: CGPoint(x: self.labelPointerMidX - (self.labelPointerBaseWidth/2), y: 0))
        contextRef.addLine(to: CGPoint(x: self.labelPointerMidX, y: self.frame.height))
        contextRef.addLine(to: CGPoint(x: self.labelPointerMidX + (self.labelPointerBaseWidth/2), y: 0))
        contextRef.addLine(to: CGPoint(x: self.labelPointerMidX - (self.labelPointerBaseWidth/2), y: 0))
        contextRef.fillPath()
        
    }
    
    func moveLabelPointer(_ xPosition:CGFloat) {
        
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
