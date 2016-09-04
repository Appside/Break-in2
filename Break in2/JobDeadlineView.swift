//
//  JobDeadlineView.swift
//  Break in2
//
//  Created by Sangeet on 04/09/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit

class JobDeadlineView: UIView {
  
  let careerColorView:UIView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.careerColorView)
    
    self.setConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    
    // Create and add constraints for careerColorView
    
    self.careerColorView.translatesAutoresizingMaskIntoConstraints = false
    
    let careerColorViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    
    let careerColorViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -8)
    
    let careerColorViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
    
    let careerColorViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerColorView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 4)
    
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
