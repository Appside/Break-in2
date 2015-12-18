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
  
  var borderWidth:CGFloat = 3
  var careerImageHeight:CGFloat = 25
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add careerImageView as a subview
    
    self.addSubview(self.careerImageView)
    
    // Customize button properties
    
    self.setTitleColor(UIColor.turquoiseColor(), forState: UIControlState.Normal)
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    
    self.careerImageView.contentMode = UIViewContentMode.ScaleAspectFit

    self.layer.borderColor = UIColor.turquoiseColor().CGColor
    
    self.setConstraints()
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayButton() {
    
    // Set button title and button careerImage
    
    self.setTitle(self.careerTitle, forState: UIControlState.Normal)
    self.careerImageView.image = self.careerImage
    
    self.layer.borderWidth = self.borderWidth
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerImageView
    
    self.careerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let careerImageViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
    
    let careerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    let careerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    self.careerImageView.addConstraints([careerImageViewHeightConstraint, careerImageViewWidthConstraint])
    self.addConstraints([careerImageViewCenterYConstraint, careerImageViewLeftConstraint])
    
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
