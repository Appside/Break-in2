//
//  CalculatorView.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 14/09/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit

class CalculatorView:UIView {
    
    var ViewHeight:CGFloat = CGFloat()
    var ViewWidth:CGFloat = CGFloat()
    var ButtonSize:CGFloat = CGFloat()
    var ButtonMargin:CGFloat = CGFloat()
    let ResultsView:UIView = UIView()
    let touchColor:UIColor = UIColor(white: 1.0, alpha: 0.2)
    var TopPane:UILabel = UILabel()
    var BottomPane:UILabel = UILabel()
    var firstNumber = 0
    var secondNumber = 0
    var operation = ""
    var memory1:Double = 0
    var memory2:Double = 0
    var memory3:Double = 0
    var firstNumberTyped:Bool = true
    var decimalPressed:Bool = false
    var decimalPoints1:Int = 0
    var decimalPoints2:Int = 0
    var numbersTyped:Int = 0
    var operatorPress:Bool = false
    var operatorMemory:String = String()
    var equalPress:Bool = false
    var lastPress:String = String()
    var line1Top:String = ""
    var line2Top:String = ""
    var line3Top:String = ""
    
    let touch0:UIButton = UIButton()            //0
    let touch1:UIButton = UIButton()            //1
    let touch2:UIButton = UIButton()            //2
    let touch3:UIButton = UIButton()            //3
    let touch4:UIButton = UIButton()            //4
    let touch5:UIButton = UIButton()            //5
    let touch6:UIButton = UIButton()            //6
    let touch7:UIButton = UIButton()            //7
    let touch8:UIButton = UIButton()            //8
    let touch9:UIButton = UIButton()            //9
    let touchPlus:UIButton = UIButton()         //10
    let touchMinus:UIButton = UIButton()        //11
    let touchDivide:UIButton = UIButton()       //12
    let toucheMultiply:UIButton = UIButton()    //13
    let touchPoint:UIButton = UIButton()        //14
    let touchPercent:UIButton = UIButton()      //15
    let touchC:UIButton = UIButton()            //16
    let touchAC:UIButton = UIButton()           //17
    let touchEqual:UIButton = UIButton()        //18
    
    var touchArray:[UIButton] = [UIButton]()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.touchArray.append(self.touch0)
        self.touchArray.append(self.touch1)
        self.touchArray.append(self.touch2)
        self.touchArray.append(self.touch3)
        self.touchArray.append(self.touch4)
        self.touchArray.append(self.touch5)
        self.touchArray.append(self.touch6)
        self.touchArray.append(self.touch7)
        self.touchArray.append(self.touch8)
        self.touchArray.append(self.touch9)
        self.touchArray.append(self.touchPlus)
        self.touchArray.append(self.touchMinus)
        self.touchArray.append(self.touchDivide)
        self.touchArray.append(self.toucheMultiply)
        self.touchArray.append(self.touchPoint)
        self.touchArray.append(self.touchPercent)
        self.touchArray.append(self.touchC)
        self.touchArray.append(self.touchAC)
        self.touchArray.append(self.touchEqual)
        
        self.userInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareCalculator(height:CGFloat, width:CGFloat) {
        
        self.ViewHeight = height
        self.ViewWidth = width
        self.ButtonMargin = UIView().getTextSize(5)
        
        let var1 = (self.ViewHeight - 8*self.ButtonMargin)/7
        let var2 = (self.ViewWidth - 5*self.ButtonMargin)/4
        self.ButtonSize = min(var1,var2)
        let additionalLeftMargin:CGFloat = (width - 5*self.ButtonMargin - 4*self.ButtonSize)/2
        
        self.addSubview(self.ResultsView)
        self.ResultsView.backgroundColor = self.touchColor
        self.ResultsView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.ResultsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.ButtonMargin)
        let centerXConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.ResultsView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant:0)
        self.addConstraints([topConstraint,centerXConstraint])
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.ResultsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 2*self.ButtonSize+self.ButtonMargin)
        let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.ResultsView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 4*self.ButtonSize+3*self.ButtonMargin)
        self.ResultsView.addConstraints([heightConstraint,widthConstraint])
        self.ResultsView.layer.cornerRadius = 8.0
        self.ResultsView.layer.borderColor = UIColor(white: 1.0, alpha: 0.4).CGColor
        self.ResultsView.layer.borderWidth = 2.0
        
        self.ResultsView.addSubview(self.TopPane)
        self.ResultsView.addSubview(self.BottomPane)
        self.TopPane.setConstraintsToSuperview(10, bottom: Int(2*self.ButtonSize+self.ButtonMargin)/2-10, left: 10, right: 10)
        self.BottomPane.setConstraintsToSuperview(Int(2*self.ButtonSize+self.ButtonMargin)/2+10, bottom: 10, left: 10, right: 10)
        self.TopPane.text = ""
        self.TopPane.lineBreakMode = .ByTruncatingTail
        
        self.BottomPane.textAlignment = NSTextAlignment.Center
        self.BottomPane.textColor = UIColor.whiteColor()
        self.BottomPane.font = UIFont(name: "HelveticaNeue-Bold", size: UIView().getTextSize(25))
        self.BottomPane.numberOfLines = 1
        self.BottomPane.lineBreakMode = NSLineBreakMode.ByTruncatingHead
        self.BottomPane.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        self.BottomPane.layer.cornerRadius = 10.0
        self.BottomPane.text = "0"
        
        self.TopPane.textAlignment = NSTextAlignment.Right
        self.TopPane.textColor = UIColor.whiteColor()
        self.TopPane.font = UIFont(name: "HelveticaNeue-Bold", size: UIView().getTextSize(15))
        self.TopPane.numberOfLines = 3
        
        for button in self.touchArray {
            
            
            self.addSubview(button)
            button.backgroundColor = self.touchColor
            button.layer.cornerRadius = 8.0
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.titleLabel?.textColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: UIView().getTextSize(25))
            
            let buttonIndex = self.touchArray.indexOf(button)
            
            if buttonIndex == 0 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.ButtonMargin+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 2*self.ButtonSize+self.ButtonMargin)
                button.addConstraints([heightConstraint,widthConstraint])
                button.titleLabel?.textAlignment = NSTextAlignment.Center
                button.setTitle("0", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 1 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.ButtonMargin+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -self.ButtonSize-2*self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("1", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 2 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2*self.ButtonMargin+self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.ButtonMargin-self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("2", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 3 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 3*self.ButtonMargin+2*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.ButtonMargin-self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("3", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 4 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.ButtonMargin+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.ButtonSize-3*self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("4", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 5 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2*self.ButtonMargin+self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -3*self.ButtonMargin-2*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("5", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 6 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 3*self.ButtonMargin+2*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -3*self.ButtonMargin-2*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("6", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 7 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.ButtonMargin+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -3*self.ButtonSize-4*self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("7", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 8 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2*self.ButtonMargin+self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -4*self.ButtonMargin-3*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("8", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 9 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 3*self.ButtonMargin+2*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -4*self.ButtonMargin-3*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("9", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.numberTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 10 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.ButtonMargin+3*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.ButtonMargin-self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("+", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.operatorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 11 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.ButtonMargin+3*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -3*self.ButtonMargin-2*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("-", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.operatorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 12 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.ButtonMargin+3*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -4*self.ButtonMargin-3*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("x", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.operatorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 13 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.ButtonMargin+3*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.ButtonMargin-4*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("/", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.operatorPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 14 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 3*self.ButtonMargin+2*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle(".", forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(CalculatorView.decimalPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 15 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2*self.ButtonMargin+self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.ButtonMargin-4*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("C", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.resetCalculator(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 16 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 3*self.ButtonMargin+2*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.ButtonMargin-4*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("%", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                
            } else if buttonIndex == 17 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.ButtonMargin+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5*self.ButtonMargin-4*self.ButtonSize)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("Rst", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.fullReset(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            } else if buttonIndex == 18 {
                
                button.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 4*self.ButtonMargin+3*self.ButtonSize+additionalLeftMargin)
                let bottomConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -self.ButtonMargin)
                self.addConstraints([leftConstraint,bottomConstraint])
                let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.ButtonSize)
                button.addConstraints([heightConstraint,widthConstraint])
                button.setTitle("=", forState: UIControlState.Normal)
                button.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.4)
                button.addTarget(self, action: #selector(CalculatorView.equalPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            }
            
        }
        
    }
    
    func numberTapped(sender:UIButton) {
        
        if self.operatorPress == true || self.equalPress == true {
            
            let buttonTest:UIButton = UIButton()
            buttonTest.setTitle(self.lastPress, forState: UIControlState.Normal)
            self.resetCalculator(buttonTest)
        
        }
        
        if self.lastPress == "=" {
            
            let buttonTest:UIButton = UIButton()
            buttonTest.setTitle("C", forState: UIControlState.Normal)
            self.resetCalculator(buttonTest)
            
        }
        
        self.numbersTyped += 1
        
        if self.numbersTyped <= 15 {
        
        let numberStrings = ["0","1","2","3","4","5","6","7","8","9"]
        let numberInt:[Double] = [0,1,2,3,4,5,6,7,8,9]
        let number = numberInt[numberStrings.indexOf(sender.currentTitle!)!]
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 12;
            
        if self.firstNumberTyped == true {
            
            if self.decimalPressed == true {
                formatter.minimumFractionDigits = 1
                self.decimalPoints1 += 1
                self.memory1 = number / 10
            } else {
                self.memory1 = number
            }
            self.firstNumberTyped = false
            
        } else {

            if self.decimalPressed == true {
                self.decimalPoints1 += 1
                let toAdd:Double = number / pow(10,Double(self.decimalPoints1))
                self.memory1 = self.memory1 + toAdd
                formatter.minimumFractionDigits = self.decimalPoints1
            } else {
                self.memory1 = self.memory1*10 + number
            }
            
        }
        
        self.BottomPane.text = formatter.stringFromNumber(self.memory1)
        
        }
        
        self.lastPress = sender.currentTitle!
        
    }
    
    func decimalPress(sender:UIButton) {
        
        if self.operatorPress == true || self.equalPress == true {
            
            self.BottomPane.text = "0"
            let buttonTest:UIButton = UIButton()
            buttonTest.setTitle(self.lastPress, forState: UIControlState.Normal)
            self.resetCalculator(buttonTest)
            
        }
        
        if self.lastPress == "=" {
            
            let buttonTest:UIButton = UIButton()
            buttonTest.setTitle("C", forState: UIControlState.Normal)
            self.resetCalculator(buttonTest)
            
        }
        
        self.decimalPressed = true
        self.lastPress = sender.currentTitle!
        self.BottomPane.textColor = UIColor.whiteColor()
        
    }
    
    func resetCalculator(sender:UIButton) {
        
        self.decimalPoints1 = 0
        self.decimalPressed = false
        self.memory1 = 0
        self.firstNumberTyped = true
        self.numbersTyped = 0
        
        if self.operatorPress == true || self.equalPress {
            
            self.BottomPane.textColor = UIColor.whiteColor()
            self.operatorPress = false
            self.equalPress = false
            
        } else {
         
            self.operatorPress = false
            self.memory2 = 0
            self.memory3 = 0
            self.decimalPoints2 = 0
            self.equalPress = false
            
        }
        
        if sender.currentTitle == "C" {
            self.BottomPane.text = "0"
            self.memory2 = 0
            self.memory3 = 0
            self.decimalPoints2 = 0
            self.equalPress = false
            self.operatorPress = false
            
        }
        
        self.lastPress = sender.currentTitle!
        
    }
    
    func operatorPressed(sender:UIButton) {
        
        
        if self.firstNumberTyped == false {
            
            if self.equalPress == true {
                
                    self.memory1 = self.memory3
                    self.memory2 = self.memory3
                
            } else {
                
                self.memory2 = self.memory1
                
            }
            
            self.BottomPane.textColor = UIColor.grayColor()
            self.operatorPress = true
            self.operatorMemory = sender.currentTitle!
            
        }
        
        self.decimalPoints1 = 0
        self.decimalPoints2 = 0
        self.lastPress = sender.currentTitle!
        
    }
    
    func equalPressed(sender:UIButton) {
        
        if self.memory2 != 0  && self.lastPress != "=" {
        
        if self.operatorMemory == "+" {
            self.memory3 = self.memory2 + self.memory1
        }
        if self.operatorMemory == "-" {
            self.memory3 = self.memory2 - self.memory1
        }
        if self.operatorMemory == "x" {
            self.memory3 = self.memory2 * self.memory1
        }
        if self.operatorMemory == "/" {
            self.memory3 = self.memory2 / self.memory1
        }

        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 12;
        
        let nombre1:String = formatter.stringFromNumber(self.memory2)!
        let nombre2:String = formatter.stringFromNumber(self.memory1)!
        let nombre3:String = formatter.stringFromNumber(self.memory3)!
            
        if self.TopPane.text == "" {
            self.line1Top = "\(nombre1) \(self.operatorMemory) \(nombre2) = \(nombre3)"
        } else {
            if self.line2Top == "" {
                self.line2Top = "\(nombre1) \(self.operatorMemory) \(nombre2) = \(nombre3)"
            } else {
                if self.line3Top != "" {
                    self.line1Top = self.line2Top
                    self.line2Top = self.line3Top
                }
                self.line3Top = "\(nombre1) \(self.operatorMemory) \(nombre2) = \(nombre3)"
            }
        }
            
        self.TopPane.text = "\(self.line1Top)\n\(self.line2Top)\n\(self.line3Top)"
        
        self.BottomPane.text = formatter.stringFromNumber(self.memory3)
        
        self.operatorPress = false
        self.equalPress = true
            
        self.decimalPoints1 = 0
            
        }
        
        if self.lastPress == "=" {
            
            if self.operatorMemory == "+" {
                self.memory3 = self.memory3 + self.memory1
            }
            if self.operatorMemory == "-" {
                self.memory3 = self.memory3 - self.memory1
            }
            if self.operatorMemory == "x" {
                self.memory3 = self.memory3 * self.memory1
            }
            if self.operatorMemory == "/" {
                self.memory3 = self.memory3 / self.memory1
            }
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            formatter.maximumFractionDigits = 6
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 12;
            
            self.BottomPane.text = formatter.stringFromNumber(self.memory3)
            
            if self.operatorPress == true {
            
                self.operatorPress = false
                self.equalPress = true
                self.decimalPoints1 = 0
                
            }
            
        }
        
        self.lastPress = sender.currentTitle!
        self.BottomPane.textColor = UIColor.whiteColor()
        
    }
    
    func fullReset(sender:UIButton) {
        
        self.line1Top = ""
        self.line2Top = ""
        self.line3Top = ""
        self.TopPane.text = ""
        
        let buttonTest:UIButton = UIButton()
        buttonTest.setTitle("C", forState: UIControlState.Normal)
        self.resetCalculator(buttonTest)
        
    }
    
}
