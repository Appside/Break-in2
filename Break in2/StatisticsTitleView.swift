//
//  StatisticsTitleView.swift
//  Break in2
//
//  Created by Sangeet on 30/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class StatisticsTitleView: UIView {
  
  let statisticsTitleLabel:UILabel = UILabel()
  let nextStatisticButton:UIButton = UIButton()
  let previousStatisticButton:UIButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.statisticsTitleLabel)
    self.addSubview(self.nextStatisticButton)
    self.addSubview(self.previousStatisticButton)
    
    // Customize statisticsTitleLabel
    let textSize:CGFloat = self.getTextSize(18)
    self.statisticsTitleLabel.textAlignment = NSTextAlignment.Center
    self.statisticsTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: textSize)
    self.statisticsTitleLabel.text = "SCORES"
    
    // Customize nextStatisticButton and previousStatisticButton
    
    self.nextStatisticButton.setImage(UIImage.init(named: "nextButton"), forState: UIControlState.Normal)
    self.nextStatisticButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.nextStatisticButton.addTarget(self.superview, action: "nextStatButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.previousStatisticButton.setImage(UIImage.init(named: "prevButton"), forState: UIControlState.Normal)
    self.previousStatisticButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    self.previousStatisticButton.addTarget(self.superview, action: "previousStatButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

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
    
    // Create and add constraints for statisticsTitleLabel
    
    self.statisticsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let statisticsTitleLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let statisticsTitleLabelCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let statisticsTitleLabelWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.frame.width * 8)/10)
    
    let statisticsTitleLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statisticsTitleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    self.statisticsTitleLabel.addConstraint(statisticsTitleLabelWidthConstraint)
    self.addConstraints([statisticsTitleLabelTopConstraint, statisticsTitleLabelCenterXConstraint, statisticsTitleLabelBottomConstraint])
    
    // Create and add constraints for nextStatisticButton
    
    self.nextStatisticButton.translatesAutoresizingMaskIntoConstraints = false
    
    let nextStatisticButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextStatisticButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let nextStatisticButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextStatisticButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    let nextStatisticButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextStatisticButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let nextStatisticButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.nextStatisticButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 18)
    
    self.nextStatisticButton.addConstraints([nextStatisticButtonWidthConstraint, nextStatisticButtonHeightConstraint])
    self.addConstraints([nextStatisticButtonCenterYConstraint, nextStatisticButtonRightConstraint])
    
    // Create and add constraints for previousStatisticButton
    
    self.previousStatisticButton.translatesAutoresizingMaskIntoConstraints = false
    
    let previousStatisticButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousStatisticButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let previousStatisticButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousStatisticButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let previousStatisticButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousStatisticButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.frame.width/10)
    
    let previousStatisticButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.previousStatisticButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 18)
    
    self.previousStatisticButton.addConstraints([previousStatisticButtonWidthConstraint, previousStatisticButtonHeightConstraint])
    self.addConstraints([previousStatisticButtonCenterYConstraint, previousStatisticButtonLeftConstraint])
    
  }

    func disableNext() {
        self.nextStatisticButton.alpha = 0.0
    }
    
    func disablePrevious() {
        self.previousStatisticButton.alpha = 0.0
    }
    func enableNext() {
        self.nextStatisticButton.alpha = 1.0
    }
    
    func enablePrevious() {
        self.previousStatisticButton.alpha = 1.0
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
