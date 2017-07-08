//
//  TutorialViewController.swift
//  Break in2
//
//  Created by Sangeet on 10/01/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TutorialViewController: UIViewController {

  let backgroundImageView:UIImageView = UIImageView()
  let backgroundView2:UIView = UIView()
  let logoImageView:UILabel = UILabel()
  let profilePictureImageView:UIImageView = UIImageView()
  let sloganImageView:UIImageView = UIImageView()
  let tutorialNextButton:UIButton = UIButton()
  let descriptionLabelView:TutorialDescriptionView = TutorialDescriptionView()
  let descriptionImageView:UIImageView = UIImageView()
  let tutorialViewModel:JSONModel = JSONModel()
  var descriptionLabelViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
  var logoImageViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
  var sloganImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.main.bounds
  let statusBarFrame:CGRect = UIApplication.shared.statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  var menuButtonHeight:CGFloat = 50
  let backButtonHeight:CGFloat = UIScreen.main.bounds.width/12
  var loginPageControllerViewHeight:CGFloat = 50
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let user = PFUser.current()

        // Do any additional setup after loading the view.
      
      // Download and save JSON files
      
      self.tutorialViewModel.saveJSONFile("JobDeadlines", completion: nil)
      
      // Add logoImageView and profilePictureImageView to HomeViewController view
      
      self.view.addSubview(self.backgroundImageView)
      self.view.addSubview(self.backgroundView2)
      self.view.addSubview(self.logoImageView)
      self.view.addSubview(self.profilePictureImageView)
      self.view.addSubview(self.sloganImageView)
      self.view.addSubview(self.tutorialNextButton)
      self.view.addSubview(self.descriptionLabelView)
      self.view.addSubview(self.descriptionImageView)

      // Customize and add content to imageViews
      
      self.backgroundImageView.image = UIImage(named: "homeBG")
      self.backgroundView2.backgroundColor = UIColor.black
      self.backgroundView2.alpha = 0

      self.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        let labelString:String = String("BREAKIN2")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(26))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(26))!, range: NSRange(location: 5, length: NSString(string: labelString).length-5))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.logoImageView.attributedText = attributedString
      
      self.profilePictureImageView.contentMode = UIViewContentMode.scaleAspectFit
      self.profilePictureImageView.image = UIImage.init(named: "planeLogo")!
      
      self.sloganImageView.contentMode = UIViewContentMode.scaleAspectFit
      self.sloganImageView.image = UIImage.init(named: "asSlogan")
      
      self.tutorialNextButton.backgroundColor = UIColor.turquoiseColor()
      self.tutorialNextButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
      self.tutorialNextButton.setTitle("Let's Get Started", for: UIControlState())
      self.tutorialNextButton.setTitleColor(UIColor.white, for: UIControlState())
      self.tutorialNextButton.addTarget(self, action: #selector(TutorialViewController.GoToEditProfile(_:)), for: UIControlEvents.touchUpInside)
      self.tutorialNextButton.alpha = 0
      
      let string:String = "Welcome \(user![PF_USER_FULLNAME])"
      self.descriptionLabelView.titleLabel.text = string.uppercased()
      self.descriptionLabelView.descriptionLabel.text = "BREAKIN2 is a simple app...\n\n...but we all need a little help from time to time, so we've provided a short introduction to get you started."
      self.descriptionLabelView.alpha = 0
      
      self.descriptionImageView.image = UIImage.init(named: "fingbutton")
      self.descriptionImageView.contentMode = UIViewContentMode.scaleAspectFit
      self.descriptionImageView.alpha = 0
      
      // Set menuButtonHeight, backButtonHeight and calendarBackgroundViewHeight
      
      if self.screenFrame.height <= 738 {
        let calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 4)
        
        let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + calendarBackgroundViewHeight + self.minorMargin)
        self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 6) + 25))/4
        
      }
      else {
        let calendarBackgroundViewHeight = self.screenFrame.width - (self.majorMargin * 14)
        
        let careerBackgroundViewHeight:CGFloat = self.screenFrame.height - (self.statusBarFrame.height + self.backButtonHeight + (self.majorMargin * 2) + calendarBackgroundViewHeight + self.minorMargin)
        self.menuButtonHeight = (careerBackgroundViewHeight - ((self.minorMargin * 7) + 25))/5
      }
      
      // Set constraints
      
      self.setConstraints()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 1, delay: 0.5, options: UIViewAnimationOptions(), animations: {
      
      self.backgroundImageView.alpha = 0
      self.backgroundView2.alpha = 1
      self.tutorialNextButton.alpha = 1
      self.logoImageViewBottomConstraint.constant = self.statusBarFrame.height + self.minorMargin + (self.screenFrame.width/12) - self.profilePictureImageView.frame.minY
      self.profilePictureImageViewCenterXConstraint.constant = (self.screenFrame.width + (self.logoImageView.frame.width/2)) * -1
      self.sloganImageViewCenterXConstraint.constant = self.screenFrame.width + (self.logoImageView.frame.width/2)
      self.view.layoutIfNeeded()
      
      }, completion: {(Bool) in
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
          
          self.descriptionLabelView.alpha = 1
          self.descriptionImageView.alpha = 1
          self.view.layoutIfNeeded()
          
        }, completion: nil)
        
    })
    
  }
  
  func setConstraints() {
    
    // Create and add constraints for backgroundImageView
    
    self.backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
    
    // Create and add constraints for backgroundView2
    
    self.backgroundView2.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    self.logoImageViewBottomConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.minorMargin * -1)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/12)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, self.logoImageViewBottomConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    self.profilePictureImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    let profilePictureImageViewCenterYConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.screenFrame.height - (self.loginPageControllerViewHeight + self.menuButtonHeight + (self.minorMargin * 3)) + self.statusBarFrame.height)/2)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewWidthConstraint, profilePictureImageViewHeightConstraint])
    self.view.addConstraints([self.profilePictureImageViewCenterXConstraint, profilePictureImageViewCenterYConstraint])
    
    // Create and add constraints for sloganImageView
    
    self.sloganImageView.translatesAutoresizingMaskIntoConstraints = false
    
    self.sloganImageViewCenterXConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let sloganImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.profilePictureImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    let sloganImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
    
    let sloganImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.sloganImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
    
    self.sloganImageView.addConstraints([sloganImageViewHeightConstraint, sloganImageViewWidthConstraint])
    self.view.addConstraints([self.sloganImageViewCenterXConstraint, sloganImageViewTopConstraint])
    
    // Create and add constraints for tutorialNextButton
    
    self.tutorialNextButton.translatesAutoresizingMaskIntoConstraints = false
    
    let tutorialNextButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: (self.minorMargin + self.majorMargin) * -1)
    
    let tutorialNextButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: self.minorMargin * -1)
    
    let tutorialNextButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.minorMargin + self.majorMargin)
    
    let tutorialNextButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialNextButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
    
    self.tutorialNextButton.addConstraint(tutorialNextButtonHeightConstraint)
    self.view.addConstraints([tutorialNextButtonLeftConstraint, tutorialNextButtonBottomConstraint, tutorialNextButtonRightConstraint])
    
    // Create and add constraints for descriptionLabelView
    
    self.descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
    
    let descriptionLabelViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    self.descriptionLabelViewTopConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -20)
    
    let descriptionLabelViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.descriptionLabelView.heightForView(self.descriptionLabelView.descriptionLabel.text!, font: self.descriptionLabelView.descriptionLabel.font, width: self.screenFrame.width - (self.majorMargin * 2)) + 50)
    
    let descriptionLabelViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionLabelView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2))
    
    self.descriptionLabelView.addConstraints([descriptionLabelViewHeightConstraint, descriptionLabelViewWidthConstraint])
    self.view.addConstraints([descriptionLabelViewCenterXConstraint, self.descriptionLabelViewTopConstraint])
    
    // Create and add constraints for descriptionImageView
    
    self.descriptionImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let descriptionImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
    let descriptionImageViewBottomConstraint = NSLayoutConstraint.init(item: self.descriptionImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.descriptionLabelView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let descriptionImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/4)
    
    let descriptionImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.descriptionImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - (self.majorMargin * 2))
    
    self.descriptionImageView.addConstraints([descriptionImageViewHeightConstraint, descriptionImageViewWidthConstraint])
    self.view.addConstraints([descriptionImageViewCenterXConstraint, descriptionImageViewBottomConstraint])
    
  }
  
  func nextTutorialButtonClicked(_ sender:UIButton) {
    
    self.performSegue(withIdentifier: "tutorialEnded", sender: sender)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tutorialEnded" {
      let destinationVC:EditProfileViewController = segue.destination as! EditProfileViewController
      destinationVC.firstTimeUser = true
    }
  }
    
    func GoToEditProfile(_ sender:UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions(), animations: {
            
            self.descriptionImageView.alpha = 0.0
            self.descriptionLabelViewTopConstraint.constant = -100
            self.tutorialNextButton.setTitle("Set up a Profile", for: UIControlState())
            self.tutorialNextButton.addTarget(self, action: #selector(TutorialViewController.nextTutorialButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            self.descriptionLabelView.titleLabel.text = "CREATE A PROFILE"
            self.descriptionLabelView.descriptionLabel.text = "That way we can get in touch if you win a prize or tell you about suitable open positions. You can edit this at any time."
            self.descriptionLabelView.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
