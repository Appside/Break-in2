//
//  TutorialDescriptionView.swift
//  Break in2
//
//  Created by Sangeet on 10/01/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit

class TutorialDescriptionView: UIView {

  let titleLabel:UILabel = UILabel()
  let descriptionLabel:UILabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.titleLabel)
    self.addSubview(self.descriptionLabel)
    
    // Customize Labels
    let textSize:CGFloat = self.getTextSize(15)
    self.titleLabel.textColor = UIColor.whiteColor()
    self.titleLabel.textAlignment = NSTextAlignment.Center
    self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: textSize)
    self.titleLabel.numberOfLines = 0
    self.titleLabel.clipsToBounds = false
    
    self.descriptionLabel.textColor = UIColor.whiteColor()
    self.descriptionLabel.textAlignment = NSTextAlignment.Center
    self.descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: textSize)
    self.descriptionLabel.numberOfLines = 0
    self.descriptionLabel.clipsToBounds = false
        
    // Set constraints
    
    self.setConstraints()
    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    
    // Create and add constraints for titleLabel
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let titleLabelLeftConstraint = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let titleLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let titleLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let titleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.titleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
    
    self.titleLabel.addConstraint(titleLabelHeightConstraint)
    self.addConstraints([titleLabelLeftConstraint, titleLabelTopConstraint, titleLabelRightConstraint])
    
    // Create and add constraints for descriptionLabel
    
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let descriptionLabelLeftConstraint = NSLayoutConstraint.init(item: self.descriptionLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let descriptionLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let descriptionLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let descriptionLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.addConstraints([descriptionLabelLeftConstraint, descriptionLabelTopConstraint, descriptionLabelRightConstraint, descriptionLabelBottomConstraint])
    
  }
  
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
