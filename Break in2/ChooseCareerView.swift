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

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Add subviews
    
    self.addSubview(self.careerTitleLabel)
    self.addSubview(self.careerImageView)
    self.addSubview(self.tickButton)
    self.addSubview(self.crossButton)
    
    // Set properties
    
    self.careerTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.careerTitleLabel.textAlignment = NSTextAlignment.Center
    self.careerTitleLabel.textColor = UIColor.turquoiseColor()

    self.careerImageView.contentMode = UIViewContentMode.ScaleAspectFit
    
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
    
  }
  
  func displayView() {
    
    self.careerImageView.image = self.careerImage
    
    self.careerTitleLabel.text = self.careerTitle
    
    // Set constraints
    
    self.setConstraints()
    
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
