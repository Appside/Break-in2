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
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
      
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "homeBG")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    
    func loginUser(_ target: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "navigationVC")
        target.present(welcomeVC, animated: false, completion: nil)
        
    }
    
    func setConstraintsToSuperview(_ top:Int, bottom:Int, left:Int, right:Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(top))
        let bottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -CGFloat(bottom))
        let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.left, multiplier: 1, constant: CGFloat(left))
        let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.superview, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -CGFloat(right))
        self.superview!.addConstraints([topMargin,bottomMargin,leftMargin,rightMargin])
    }
  
  func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.textAlignment = NSTextAlignment.center
    
    label.sizeToFit()
    return label.frame.height
  }
  
  func getTextSize(_ iPhone6TextSize:CGFloat) -> CGFloat {
    let screenFrame:CGRect = UIScreen.main.bounds
    return ((iPhone6TextSize/667) * screenFrame.size.height)
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
            newInt += 1
        }
        return newInt
    }
    func intMinus()->Int {
        var newInt:Int = self
        if newInt==0 {
            newInt = 9
        } else {
            newInt -= 1
        }
        return newInt
    }
}

extension String {
    func removeSpaces()-> String {
        let components = self.components(separatedBy: CharacterSet.whitespaces).filter { !$0.isEmpty }
        return components.joined(separator: "")
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

