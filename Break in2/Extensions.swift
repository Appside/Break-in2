//
//  Extensions.swift
//  Break in2
//
//  Created by Jonathan Crawford on 15/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //this function adds any BGImage called
    func addHomeBG() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
      
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "homeBG")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    
    func loginUser(target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewControllerWithIdentifier("navigationVC")
        target.presentViewController(welcomeVC, animated: false, completion: nil)
        
    }
    
    func setConstraintsToSuperview(top:Int, bottom:Int, left:Int, right:Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(top))
        let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -CGFloat(bottom))
        let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(left))
        let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -CGFloat(right))
        self.superview!.addConstraints([topMargin,bottomMargin,leftMargin,rightMargin])
    }
}

extension UIColor {
  
  // Function that returns the App's turquoise color
  class func  turquoiseColor() -> UIColor {
    return UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1)
  }
  
}

extension Int {
    func intPlus()->Int {
        var newInt:Int = self
        if newInt==9 {
            newInt = 0
        } else {
            newInt++
        }
        return newInt
    }
    func intMinus()->Int {
        var newInt:Int = self
        if newInt==0 {
            newInt = 9
        } else {
            newInt--
        }
        return newInt
    }
}

extension String {
    func removeSpaces()-> String {
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter { !$0.isEmpty }
        return components.joinWithSeparator("")
    }
}

