//
//  ChooseCareerView.swift
//  Break in2
//
//  Created by Sangeet on 14/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

class ChooseCareerView: UIView {
  
  var careerTitle:String = String()
  let careerTitleLabel:UILabel = UILabel()
  let careerImageView:UIImageView = UIImageView()
  var careerImage:UIImage = UIImage()
  let tickButton:UIButton = UIButton()
  let crossButton:UIButton = UIButton()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame

  var minorMargin:CGFloat = 10
  var majorMargin:CGFloat = 20
  
  var height:CGFloat = 10
  let careerTitleLabelHeight:CGFloat = 50
  
  // Declare and initialize tracking variables
  
  var tickButtonSelected:Bool = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews
    
    self.addSubview(self.careerTitleLabel)
    self.addSubview(self.careerImageView)
    self.addSubview(self.tickButton)
    self.addSubview(self.crossButton)
    
    // Set properties for careerTitleLabel and careerImageView
    
    self.careerTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.careerTitleLabel.textAlignment = NSTextAlignment.Center
    self.careerTitleLabel.textColor = UIColor.turquoiseColor()

    self.careerImageView.contentMode = UIViewContentMode.ScaleAspectFit
    
    // Set properties for tickButton and crossButton
    
    self.tickButton.setImage(UIImage.init(named: "tickUnselected"), forState: UIControlState.Normal)
    self.tickButton.addTarget(self, action: "tickButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.crossButton.setImage(UIImage.init(named: "crossSelected"), forState: UIControlState.Normal)
    self.crossButton.addTarget(self, action: "crossButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerImageView
    
    self.careerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let careerImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (self.careerTitleLabelHeight / 2) * -1)
    
    let careerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.height/2)
    
    let careerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.height/2)
    
    self.careerImageView.addConstraints([careerImageViewHeightConstraint, careerImageViewWidthConstraint])
    self.addConstraints([careerImageViewCenterXConstraint, careerImageViewCenterYConstraint])
    
    // Create and add constraints for careerTitleLabel
    
    self.careerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let careerTitleLabelBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerTitleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let careerTitleLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
    
    let careerTitleLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerTitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.careerTitleLabelHeight)
    
    let careerTitleLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerTitleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
    
    self.careerTitleLabel.addConstraint(careerTitleLabelHeightConstraint)
    self.addConstraints([careerTitleLabelBottomConstraint, careerTitleLabelLeftConstraint, careerTitleLabelRightConstraint])
    
    // Create and add constraints for tickButton
    
    self.tickButton.translatesAutoresizingMaskIntoConstraints = false
    
    let tickButtonCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.careerImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: (((self.screenFrame.width/2) - self.majorMargin - (self.height/4))/2) + (self.height/4))
    
    let tickButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (self.careerTitleLabelHeight / 2) * -1)
    
    let tickButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let tickButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    self.tickButton.addConstraints([tickButtonHeightConstraint, tickButtonWidthConstraint])
    self.addConstraints([tickButtonCenterXConstraint, tickButtonCenterYConstraint])
    
    // Create and add constraints for crossButton
    
    self.crossButton.translatesAutoresizingMaskIntoConstraints = false
    
    let crossButtonCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.careerImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: ((((self.screenFrame.width/2) - self.majorMargin - (self.height/4))/2) + (self.height/4)) * -1)
    
    let crossButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (self.careerTitleLabelHeight / 2) * -1)
    
    let crossButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let crossButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    self.crossButton.addConstraints([crossButtonHeightConstraint, crossButtonWidthConstraint])
    self.addConstraints([crossButtonCenterXConstraint, crossButtonCenterYConstraint])
    
  }
  
  func displayView() {
    
    self.careerImageView.image = self.careerImage
    
    self.careerTitleLabel.text = self.careerTitle
    
    // Set constraints
    
    self.setConstraints()
    
  }
  
  func tickButtonClicked(sender:UIButton) {
    
    if !self.tickButtonSelected {
      self.tickButton.setImage(UIImage.init(named: "tickSelected"), forState: UIControlState.Normal)
      self.crossButton.setImage(UIImage.init(named: "crossUnselected"), forState: UIControlState.Normal)
      
      self.tickButtonSelected = true
    }
    
  }
  
  func crossButtonClicked(sender:UIButton) {
    
    if self.tickButtonSelected {
      self.tickButton.setImage(UIImage.init(named: "tickUnselected"), forState: UIControlState.Normal)
      self.crossButton.setImage(UIImage.init(named: "crossSelected"), forState: UIControlState.Normal)
      
      self.tickButtonSelected = false
    }
    
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
