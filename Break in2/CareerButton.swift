//
//  CareerButton.swift
//  Break in2
//
//  Created by Sangeet on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class CareerButton: UIButton {
  
  var careerTitle:String = String()
  var careerImage:UIImage = UIImage()
  let careerImageView:UIImageView = UIImageView()
  let careerColorView:UIView = UIView()
  
  var borderWidth:CGFloat = 3
  var careerImageHeight:CGFloat = 25
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add careerImageView as a subview
    
    self.addSubview(self.careerImageView)
    self.addSubview(self.careerColorView)
    
    // Customize button properties
    let textSize:CGFloat = self.getTextSize(15)
    self.setTitleColor(UIColor.turquoiseColor(), for: UIControlState())
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    
    self.careerImageView.contentMode = UIViewContentMode.scaleAspectFit

    self.layer.borderColor = UIColor.turquoiseColor().cgColor
    
    self.setConstraints()
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayButton() {
    
    // Set button title and button careerImage
    
    self.setTitle(self.careerTitle, for: UIControlState())
    self.careerImageView.image = self.careerImage
    
    self.layer.borderWidth = self.borderWidth
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerImageView
    
    self.careerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    
    let careerImageViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 10)
    
    let careerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    let careerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    self.careerImageView.addConstraints([careerImageViewHeightConstraint, careerImageViewWidthConstraint])
    self.addConstraints([careerImageViewCenterYConstraint, careerImageViewLeftConstraint])
    
    // Create and add constraints for careerColorView
    
    self.careerColorView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerColorViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let careerColorViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: self.borderWidth * -1)
    
    let careerColorViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    let careerColorViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 10)
    
    self.careerColorView.addConstraints([careerColorViewWidthConstraint])
    self.addConstraints([careerColorViewTopConstraint, careerColorViewRightConstraint, careerColorViewBottomConstraint])
    
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
