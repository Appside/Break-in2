//
//  ChooseCareerView.swift
//  Break in2
//
//  Created by Sangeet on 14/12/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

protocol ChooseCareerViewDelegate {
  
  func appendChosenCareer()
  func removeChosenCareer()
  
}

class ChooseCareerView: UIView {
  
  let careerImageView:UIImageView = UIImageView()
  var careerImage:UIImage = UIImage()
  let careerColorView:UIView = UIView()
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
  
  var careerChosen:Bool = false
  var delegate:ChooseCareerViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews
    
    self.addSubview(self.careerImageView)
    self.addSubview(self.tickButton)
    self.addSubview(self.crossButton)
    self.addSubview(self.careerColorView)
    
    // Set properties for careerImageView

    self.careerImageView.contentMode = UIViewContentMode.ScaleAspectFit
    
    // Set properties for tickButton and crossButton
    
    self.tickButton.addTarget(self, action: #selector(ChooseCareerView.tickButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.tickButton.setImage(UIImage.init(named: "tickUnselected"), forState: UIControlState.Normal)

    self.crossButton.addTarget(self, action: #selector(ChooseCareerView.crossButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.crossButton.setImage(UIImage.init(named: "crossUnselected"), forState: UIControlState.Normal)

  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerImageView
    
    self.careerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let careerImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let careerImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.height/2)
    
    let careerImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.height/2)
    
    self.careerImageView.addConstraints([careerImageViewHeightConstraint, careerImageViewWidthConstraint])
    self.addConstraints([careerImageViewCenterXConstraint, careerImageViewCenterYConstraint])
    
    // Create and add constraints for careerColorView
    
    self.careerColorView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerColorViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let careerColorViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careerImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    let careerColorViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 5)
    
    let careerColorViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.height/2)
    
    self.careerColorView.addConstraints([careerColorViewHeightConstraint, careerColorViewWidthConstraint])
    self.addConstraints([careerColorViewCenterXConstraint, careerColorViewTopConstraint])

    // Create and add constraints for tickButton
    
    self.tickButton.translatesAutoresizingMaskIntoConstraints = false
    
    let tickButtonCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.careerImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: (((self.screenFrame.width/2) - self.majorMargin - (self.height/4))/2) + (self.height/4))
    
    let tickButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let tickButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let tickButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tickButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    self.tickButton.addConstraints([tickButtonHeightConstraint, tickButtonWidthConstraint])
    self.addConstraints([tickButtonCenterXConstraint, tickButtonCenterYConstraint])
    
    // Create and add constraints for crossButton
    
    self.crossButton.translatesAutoresizingMaskIntoConstraints = false
    
    let crossButtonCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.careerImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: ((((self.screenFrame.width/2) - self.majorMargin - (self.height/4))/2) + (self.height/4)) * -1)
    
    let crossButtonCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
    
    let crossButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    let crossButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.crossButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
    
    self.crossButton.addConstraints([crossButtonHeightConstraint, crossButtonWidthConstraint])
    self.addConstraints([crossButtonCenterXConstraint, crossButtonCenterYConstraint])
    
  }
  
  func displayView() {
    
    self.careerImageView.image = self.careerImage
    
    // Set constraints
    
    self.setConstraints()
    
    // Set tickButton and crossButton
    
    if self.careerChosen {
      self.tickButton.setImage(UIImage.init(named: "tickSelected"), forState: UIControlState.Normal)
      self.crossButton.setImage(UIImage.init(named: "crossUnselected"), forState: UIControlState.Normal)
    }
    else {
      self.crossButton.setImage(UIImage.init(named: "crossSelected"), forState: UIControlState.Normal)
      self.tickButton.setImage(UIImage.init(named: "tickUnselected"), forState: UIControlState.Normal)
    }
    
  }
  
  func tickButtonClicked(sender:UIButton) {
    
    if !self.careerChosen {
      self.tickButton.setImage(UIImage.init(named: "tickSelected"), forState: UIControlState.Normal)
      self.crossButton.setImage(UIImage.init(named: "crossUnselected"), forState: UIControlState.Normal)
      
      self.careerChosen = true
      
      if let unwrappedDelegate = self.delegate {
        unwrappedDelegate.appendChosenCareer()
      }
    }
    
  }
  
  func crossButtonClicked(sender:UIButton) {
    
    if self.careerChosen {
      self.tickButton.setImage(UIImage.init(named: "tickUnselected"), forState: UIControlState.Normal)
      self.crossButton.setImage(UIImage.init(named: "crossSelected"), forState: UIControlState.Normal)
      
      self.careerChosen = false
      
      if let unwrappedDelegate = self.delegate {
        unwrappedDelegate.removeChosenCareer()
      }
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
