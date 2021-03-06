//
//  facebookButton.swift
//  Break in2
//
//  Created by Sangeet on 13/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class FacebookButton: UIButton {
  
  var facebookLogoImageView:UIImageView = UIImageView()
  var facebookButtonTitle:String = String()
  
  var careerImageHeight:CGFloat = 25

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews
    
    self.addSubview(self.facebookLogoImageView)
    
    // customize button appearance
    
    let textSize = self.getTextSize(15)
    self.backgroundColor = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    self.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    self.setTitleColor(UIColor.white, for: UIControlState())
    
    self.facebookLogoImageView.contentMode = UIViewContentMode.scaleAspectFit
    self.facebookLogoImageView.image = UIImage.init(named: "facebookButtonLight")
    
    // Set constraints
    
    self.setConstraints()
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func displayButton() {
    
    // Set button title and button careerImage
    
    self.setTitle(self.facebookButtonTitle, for: UIControlState())
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for facebookLogoImageView
    
    self.facebookLogoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let facebookLogoImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    
    let facebookLogoImageViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 10)
    
    let facebookLogoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    let facebookLogoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.facebookLogoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.careerImageHeight)
    
    self.facebookLogoImageView.addConstraints([facebookLogoImageViewHeightConstraint, facebookLogoImageViewWidthConstraint])
    self.addConstraints([facebookLogoImageViewCenterYConstraint, facebookLogoImageViewLeftConstraint])
    
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
