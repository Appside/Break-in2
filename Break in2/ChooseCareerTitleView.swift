//
//  ChooseCareerTitleView.swift
//  Break in2
//
//  Created by Sangeet on 03/01/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit

class ChooseCareerTitleView: UIView {

  let careerSelectedLabel:UILabel = UILabel()
  let nextCareerButton:UIButton = UIButton()
  let previousCareerButton:UIButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews
    
    self.addSubview(self.careerSelectedLabel)
    self.addSubview(self.nextCareerButton)
    self.addSubview(self.previousCareerButton)
    
    // Customize careerTitleLabel
    let textSize:CGFloat = self.getTextSize(18)
    self.careerSelectedLabel.textAlignment = NSTextAlignment.Center
    self.careerSelectedLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    self.careerSelectedLabel.text = "Career"
    
    // Customize nextStatisticButton and previousStatisticButton
    
    self.nextCareerButton.setImage(UIImage.init(named: "nextButton"), forState: UIControlState.Normal)
    self.nextCareerButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.nextCareerButton.addTarget(self.superview, action: "nextCareerButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.previousCareerButton.setImage(UIImage.init(named: "prevButton"), forState: UIControlState.Normal)
    self.previousCareerButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.previousCareerButton.addTarget(self.superview, action: "previousCareerButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func displayView() {
    
    self.superview?.layoutIfNeeded()
    
    // Set constraints
    
    self.setConstraints()
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerSelectedLabel
    
    self.careerSelectedLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let careerSelectedLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let careerSelectedLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let careerSelectedLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.width * 8)/10)
    
    let careerSelectedLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.careerSelectedLabel.addConstraint(careerSelectedLabelWidthConstraint)
    self.addConstraints([careerSelectedLabelTopConstraint, careerSelectedLabelCenterXConstraint, careerSelectedLabelBottomConstraint])
    
    // Create and add constraints for nextCareerButton
    
    self.nextCareerButton.translatesAutoresizingMaskIntoConstraints = false
    
    let nextCareerButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let nextCareerButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let nextCareerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let nextCareerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/20)
    
    self.nextCareerButton.addConstraints([nextCareerButtonWidthConstraint, nextCareerButtonHeightConstraint])
    self.addConstraints([nextCareerButtonCenterYConstraint, nextCareerButtonRightConstraint])
    
    // Create and add constraints for previousCareerButton
    
    self.previousCareerButton.translatesAutoresizingMaskIntoConstraints = false
    
    let previousCareerButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let previousCareerButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let previousCareerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let previousCareerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/20)
    
    self.previousCareerButton.addConstraints([previousCareerButtonWidthConstraint, previousCareerButtonHeightConstraint])
    self.addConstraints([previousCareerButtonCenterYConstraint, previousCareerButtonLeftConstraint])
    
  }
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */

}
