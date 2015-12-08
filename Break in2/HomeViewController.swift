//
//  HomeViewController.swift
//  Break in2
//
//  Created by Jonathan Crawford on 08/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import QuartzCore
import Parse
import ParseUI
import SCLAlertView

class HomeViewController: UIViewController {
  
  // Declare and initialize types of careers
  
  let careerTypes:[String] = ["Investment Banking", "Engineering", "Trading", "Sangeet"]
  let careerTypeImages:[String:String] = ["Investment Banking":"briefcase", "Engineering":"engineeringLogo", "Trading":"tradeIcon", "Sangeet":"briefcase"]
  let careersTestTypes:[String:[String]] = ["Investment Banking":["Numerical Reasoning","Logical Reasoning"], "Engineering":["Numerical Reasoning"], "Trading":["Logical Reasoning"], "Sangeet":["Verbal Reasoning","Logical Reasoning"]]
  
  // Declare and initialize views
  
  let logoImageView:UIImageView = UIImageView()
  let profilePictureImageView:UIImageView = UIImageView()
  let statsButton:UIButton = UIButton()
  let settingsButton:UIButton = UIButton()
  let logOutButton:UIButton = UIButton()
  let careersBackgroundView:UIView = UIView()
  let careersScrollView:UIScrollView = UIScrollView()
  var careerButtons:[CareerButton] = [CareerButton]()
  let scrollInfoLabel:UILabel = UILabel()
  
  // Declare and initialize design constants
  
  let screenFrame:CGRect = UIScreen.mainScreen().bounds
  let statusBarFrame:CGRect = UIApplication.sharedApplication().statusBarFrame
  
  let majorMargin:CGFloat = 20
  let minorMargin:CGFloat = 10
  
  let borderWidth:CGFloat = 3
  
  let buttonHeight:CGFloat = 50
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Add background image to HomeViewController's view
    
    self.view.addHomeBG()
    
    // Add logoImageView and profilePictureImageView to HomeViewController view
    
    self.view.addSubview(self.logoImageView)
    self.view.addSubview(self.profilePictureImageView)
    self.view.addSubview(self.statsButton)
    self.view.addSubview(self.settingsButton)
    self.view.addSubview(self.careersBackgroundView)
    self.careersBackgroundView.addSubview(self.logOutButton)
    self.careersBackgroundView.addSubview(self.careersScrollView)
    self.careersBackgroundView.addSubview(self.scrollInfoLabel)
    
    //add actions to buttons
    
    self.logOutButton.addTarget(self, action: "logoutBtnPressed:", forControlEvents: .TouchUpInside)
    self.settingsButton.addTarget(self, action: "settingsBtnPressed:", forControlEvents: .TouchUpInside)
    
    // Create testTypeViews for each testType
    
    for var index:Int = 0 ; index < self.careerTypes.count ; index++ {
      
      let careerButtonAtIndex:CareerButton = CareerButton()
      
      // Set careerButton properties
      
      careerButtonAtIndex.careerTitle = self.careerTypes[index]
      careerButtonAtIndex.careerImage = UIImage.init(named: self.careerTypeImages[self.careerTypes[index]]!)!
      
      careerButtonAtIndex.borderWidth = self.borderWidth
      
      // Call method to display careerButton content
      
      careerButtonAtIndex.displayButton()
      
      // Store each button in the careerButtons array
      
      self.careerButtons.append(careerButtonAtIndex)
      
      // Make each button perform a segue to the TestSelectionViewController
      
      self.careerButtons[index].addTarget(self, action: "careerButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // Add careerButtons to careersScrollView
    
    for careerButtonAtIndex:CareerButton in self.careerButtons {
      
      self.careersScrollView.addSubview(careerButtonAtIndex)
      
    }
    
    // Customize and add content to imageViews
    
    self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
    
    self.profilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFit
    self.profilePictureImageView.image = UIImage.init(named: "planeLogo")!
    
    self.statsButton.contentMode = UIViewContentMode.ScaleAspectFit
    self.statsButton.setImage(UIImage.init(named: "back"), forState: UIControlState.Normal)
    
    self.settingsButton.contentMode = UIViewContentMode.ScaleAspectFit
    self.settingsButton.setImage(UIImage.init(named: "settings"), forState: UIControlState.Normal)
    
    self.logOutButton.backgroundColor = UIColor.turquoiseColor()
    self.logOutButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
    self.logOutButton.setTitle("Log Out", forState: UIControlState.Normal)
    self.logOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
    self.scrollInfoLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    self.scrollInfoLabel.textAlignment = NSTextAlignment.Center
    self.scrollInfoLabel.textColor = UIColor.lightGrayColor()
    self.scrollInfoLabel.text = "Scroll For More Careers"
    
    // Customize careersBackgroundView
    
    self.careersBackgroundView.backgroundColor = UIColor.whiteColor()
    self.careersBackgroundView.layer.cornerRadius = self.minorMargin
    
    // Customize careersScrollView
    
    self.careersScrollView.showsVerticalScrollIndicator = false
    
    // Set constraints
  
    self.setConstraints()
    
  }
  
  func careerButtonClicked(sender:CareerButton) {
    
    self.performSegueWithIdentifier("careerClicked", sender: sender)
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "careerClicked" {
      let nextViewController:TestSelectionViewController = segue.destinationViewController as! TestSelectionViewController
      nextViewController.testTypes = self.careersTestTypes[sender!.careerTitle]!
    }
  }
  
  func setConstraints() {
    
    // Create and add constraints for logoImageView
    
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
    self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
    
    // Create and add constraints for profilePictureImageView
    
    self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let profilePictureImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
    
    let profilePictureImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.logoImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.majorMargin * 2)
    
    let profilePictureImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    let profilePictureImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
    
    self.profilePictureImageView.addConstraints([profilePictureImageViewHeightConstraint, profilePictureImageViewWidthConstraint])
    self.view.addConstraints([profilePictureImageViewCenterXConstraint, profilePictureImageViewTopConstraint])
    
    // Create and add constraints for settingsButton
    
    self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let settingsButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let settingsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let settingsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let settingsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.settingsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    self.settingsButton.addConstraints([settingsButtonHeightConstraint, settingsButtonWidthConstraint])
    self.view.addConstraints([settingsButtonLeftConstraint, settingsButtonTopConstraint])
    
    // Create and add constraints for statsButton
    
    self.statsButton.translatesAutoresizingMaskIntoConstraints = false
    
    let statsButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let statsButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
    
    let statsButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    let statsButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.statsButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
    
    self.statsButton.addConstraints([statsButtonHeightConstraint, statsButtonWidthConstraint])
    self.view.addConstraints([statsButtonRightConstraint, statsButtonTopConstraint])
    
    // Create and add constraints for careersBackgroundView
    
    self.careersBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersBackgroundViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (((self.minorMargin * 6) + (self.buttonHeight * 4.5)) * -1))
    
    let careersBackgroundViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
    
    let careersBackgroundViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.majorMargin * -1)
    
    let careersBackgroundViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([careersBackgroundViewTopConstraint, careersBackgroundViewRightConstraint, careersBackgroundViewLeftConstraint, careersBackgroundViewBottomConstraint])
    
    // Create and add constraints for logOutButton
    
    self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
    
    let logOutButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let logOutButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
    
    let logOutButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let logOutButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logOutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight)
    
    self.logOutButton.addConstraint(logOutButtonHeightConstraint)
    self.view.addConstraints([logOutButtonLeftConstraint, logOutButtonBottomConstraint, logOutButtonRightConstraint])
    
    // Create and add constraints for scrollInfoLabel
    
    self.scrollInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let scrollInfoLabelRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let scrollInfoLabelTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let scrollInfoLabelHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.scrollInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.buttonHeight/2)
    
    self.scrollInfoLabel.addConstraint(scrollInfoLabelHeightConstraint)
    self.view.addConstraints([scrollInfoLabelLeftConstraint, scrollInfoLabelTopConstraint, scrollInfoLabelRightConstraint])
    
    // Create and add constraints for careersScrollView
    
    self.careersScrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let careersScrollViewRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: self.minorMargin * -1)
    
    let careersScrollViewBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.logOutButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin * -1)
    
    let careersScrollViewLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersBackgroundView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.minorMargin)
    
    let careersScrollViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careersScrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
    
    self.view.addConstraints([careersScrollViewLeftConstraint, careersScrollViewBottomConstraint, careersScrollViewRightConstraint, careersScrollViewTopConstraint])
    
    // Create and add constraints for each careerButton and set content size for careersScrollView
    
    for var index:Int = 0 ; index < self.careerButtons.count ; index++ {
      
      self.careerButtons[index].translatesAutoresizingMaskIntoConstraints = false
      
      let careerButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
      
      let careerButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
      
      let careerButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - (2 * (self.majorMargin + self.minorMargin)))
      
      if index == 0 {
        
        let careerButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        self.view.addConstraint(careerButtonTopConstraint)
        
      }
      else {
        
        let careerButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.careerButtons[index - 1], attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: self.minorMargin)
        
        self.view.addConstraint(careerButtonTopConstraint)
        
      }
      
      self.careerButtons[index].addConstraints([careerButtonWidthConstraint, careerButtonHeightConstraint])
      self.view.addConstraint(careerButtonLeftConstraint)
      
      if index == self.careerButtons.count - 1 {
        
        let careerButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.careerButtons[index], attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.careersScrollView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraint(careerButtonBottomConstraint)
        
      }
      
    }
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() != nil) {
            self.loadUser()
        }
        else {
            self.view.loginUser(self)
        }
    }
    
    func loadUser() {

        let user = PFUser.currentUser()!
        
    }
    
    func logoutBtnPressed(sender: UIButton!){
        
        let alertView = SCLAlertView()
//        alertView.addButton("Ok", target:self, selector:Selector("logOut"))
//        alertView.addButton("Cancel") {
//            alertView.clearAllNotice()
//        }
//        alertView.showCloseButton = false
//        alertView.showViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
//        alertView.showWarning("Logout", subTitle: "Are You Sure You Want To Exit?")
        
        alertView.addButton("Ok", target:self, selector:Selector("logOut"))
        alertView.showTitle(
            "Logout", // Title of view
            subTitle: "Are You Sure You Want To Exit?", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Notice, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        alertView.showCloseButton = false
        

    }
    
    func logOut(){
        
        PFUser.logOut()
        self.view.loginUser(self)
        
    }
    
    func settingsBtnPressed(sender: UIButton!){
        
        self.performSegueWithIdentifier("settingsClicked", sender: nil)
        
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