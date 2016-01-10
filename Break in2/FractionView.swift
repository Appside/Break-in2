//
//  FractionView.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 10/01/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import Foundation
import UIKit

class fractionView:UIView {
    
    let topLabel:UIButton = UIButton()
    let bottomLabel:UIButton = UIButton()
    let separatorView:UIView = UIView()

    override init(frame: CGRect) {

        super.init(frame: frame)
        
        //Set constraints for topLabel
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLabelTop:NSLayoutConstraint = NSLayoutConstraint(item: self.topLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let topLabelLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.topLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let topLabelRight:NSLayoutConstraint = NSLayoutConstraint(item: self.topLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraints([topLabelLeft,topLabelRight,topLabelTop])
        let topLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.topLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: -5)
        self.topLabel.addConstraint(topLabelHeight)

        //Set constraints for the separator View
        self.separatorView.setConstraintsToSuperview(Int(self.frame.height*0.5-1), bottom: Int(self.frame.height*0.5-1), left: 0, right: 0)
        
        //Set constraints for bottomLabel
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        let bottomLabelTop:NSLayoutConstraint = NSLayoutConstraint(item: self.bottomLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.frame.height*0.5+10)
        let bottomLabelLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.bottomLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let bottomLabelRight:NSLayoutConstraint = NSLayoutConstraint(item: self.bottomLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraints([bottomLabelLeft,bottomLabelRight,bottomLabelTop])
        let bottomLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.bottomLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: -5)
        self.bottomLabel.addConstraint(bottomLabelHeight)
        
        //Design of the separator View
        self.separatorView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        
        //Design of the top and bottom Labels
        self.fractionLabelDesign(self.topLabel)
        self.fractionLabelDesign(self.bottomLabel)
    
    }
    
    func fractionLabelDesign(fractionLabel:UIButton) {
        fractionLabel.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
        fractionLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 22.0)
        fractionLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        fractionLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        fatalError("init(coder:) has not been implemented")
    
    }

}