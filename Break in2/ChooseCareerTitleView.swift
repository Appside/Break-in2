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
    self.careerSelectedLabel.textAlignment = NSTextAlignment.center
    self.careerSelectedLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    self.careerSelectedLabel.text = "Career"
    
    // Customize nextStatisticButton and previousStatisticButton
    
    self.nextCareerButton.setImage(UIImage.init(named: "nextButton"), for: UIControlState())
    self.nextCareerButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    self.nextCareerButton.addTarget(self.superview, action: #selector(SettingsViewController.nextCareerButtonClicked(_:)), for: UIControlEvents.touchUpInside)
    
    self.previousCareerButton.setImage(UIImage.init(named: "prevButton"), for: UIControlState())
    self.previousCareerButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    self.previousCareerButton.addTarget(self.superview, action: #selector(SettingsViewController.previousCareerButtonClicked(_:)), for: UIControlEvents.touchUpInside)
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
    
    let careerSelectedLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let careerSelectedLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let careerSelectedLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (self.frame.width * 8)/10)
    
    let careerSelectedLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerSelectedLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    self.careerSelectedLabel.addConstraint(careerSelectedLabelWidthConstraint)
    self.addConstraints([careerSelectedLabelTopConstraint, careerSelectedLabelCenterXConstraint, careerSelectedLabelBottomConstraint])
    
    // Create and add constraints for nextCareerButton
    
    self.nextCareerButton.translatesAutoresizingMaskIntoConstraints = false
    
    let nextCareerButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    
    let nextCareerButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    
    let nextCareerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let nextCareerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextCareerButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/20)
    
    self.nextCareerButton.addConstraints([nextCareerButtonWidthConstraint, nextCareerButtonHeightConstraint])
    self.addConstraints([nextCareerButtonCenterYConstraint, nextCareerButtonRightConstraint])
    
    // Create and add constraints for previousCareerButton
    
    self.previousCareerButton.translatesAutoresizingMaskIntoConstraints = false
    
    let previousCareerButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    
    let previousCareerButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    
    let previousCareerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let previousCareerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousCareerButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width/20)
    
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
