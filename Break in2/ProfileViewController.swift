//
//  ProfileViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/07/2016.
//  Copyright © 2016 Appside. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftSpinner
import Parse
import ParseUI

class ProfileViewController: UIViewController {
    
    // Declare and intialize views
    var backgroundImageView:UIImageView = UIImageView()
    var mainView:UIView = UIView()
    var logoImageView:UIImageView = UIImageView()
    var backButtonImageVIew:UIImageView = UIImageView()
    var screenFrame:CGRect = CGRect()
    var statusBarFrame:CGRect = CGRect()
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    var backButtonHeight:CGFloat = 0
    var backButton:UIButton = UIButton()
    var pageDescription:UILabel = UILabel()
    var pageDescriptionSub:UILabel = UILabel()
    var profileScrollView:UIView = UIView()
    var profileContentView:UIView = UIView()
    let tutorialNextButton:UIButton = UIButton()
    var descriptionLabelView:TutorialDescriptionView = TutorialDescriptionView()
    
    let profileEntryHeight:Int = 40
    let nbOfProfileEntries:Int = 3
    var entry1:UITextField = UITextField()
    var entry2:UITextField = UITextField()
    var entry3:UITextField = UITextField()
    
    var saveProfileButton:UIButton = UIButton()
    let menuButtonHeight:CGFloat = 50
    var firstTimeUser:Bool = false
    var tutorialPageNumber:Int = 0
    var textSize:CGFloat = 15
    
    let defaults = NSUserDefaults.standardUserDefaults()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.textSize = self.view.getTextSize(15)
        
        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Initialize size variables
        self.screenFrame = UIScreen.mainScreen().bounds
        self.statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.backButtonHeight = UIScreen.mainScreen().bounds.width/12
        
        //Background View
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.image = UIImage.init(named: "homeBG")
        self.backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.view.addSubview(self.mainView)
        
        //Main View
        self.mainView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.mainView.backgroundColor = UIColor.blackColor()
        self.mainView.alpha = 0.8
        self.view.sendSubviewToBack(self.backgroundImageView)
        
        //Logo ImageVIew
        self.view.addSubview(self.logoImageView)
        self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
        self.logoImageView.clipsToBounds = true
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        
        let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
        
        self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
        self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
        
        //Back Button
        self.view.addSubview(self.backButton)
        self.backButton.setImage(UIImage.init(named: "back")!, forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: #selector(ProfileViewController.goBackToSettingsMenu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
      if self.firstTimeUser {
        self.backButton.alpha = 0
      }
      else {
        self.backButton.alpha = 1
      }
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        
        let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        
        let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
        self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
      
        //pageDescription set up
        self.view.addSubview(self.pageDescription)
        self.pageDescription.translatesAutoresizingMaskIntoConstraints = false
        
        let pageDescriptionCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let pageDescriptionTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight)
        
        let pageDescriptionHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        let pageDescriptionWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
        
        self.pageDescription.addConstraints([pageDescriptionHeightConstraint, pageDescriptionWidthConstraint])
        self.view.addConstraints([pageDescriptionCenterXConstraint, pageDescriptionTopConstraint])
        
        self.pageDescription.text = "PERSONAL DETAILS"
        self.pageDescription.textColor = UIColor.whiteColor()
        self.pageDescription.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.pageDescription.textAlignment = NSTextAlignment.Center
        
        //pageDescriptionSub set up
        self.view.addSubview(self.pageDescriptionSub)
        self.pageDescriptionSub.translatesAutoresizingMaskIntoConstraints = false
        
        let pageDescriptionSubCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let pageDescriptionSubTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + 4*self.minorMargin + self.backButtonHeight + 20)
        
        let pageDescriptionSubHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        let pageDescriptionSubWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
        
        self.pageDescriptionSub.addConstraints([pageDescriptionSubHeightConstraint, pageDescriptionSubWidthConstraint])
        self.view.addConstraints([pageDescriptionSubCenterXConstraint, pageDescriptionSubTopConstraint])
        
        self.pageDescriptionSub.text = "This will help us tailor your experience"
        self.pageDescriptionSub.textColor = UIColor.whiteColor()
        self.pageDescriptionSub.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.pageDescriptionSub.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(self.profileScrollView)
        self.profileScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.profileScrollView.setConstraintsToSuperview(Int(self.statusBarFrame.height + 6*self.minorMargin + self.backButtonHeight + 40), bottom: 3*Int(self.minorMargin)+Int(self.menuButtonHeight), left: Int(self.minorMargin), right: Int(self.minorMargin))
        
        self.profileScrollView.addSubview(self.profileContentView)
        self.profileContentView.translatesAutoresizingMaskIntoConstraints = false
        self.profileContentView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.profileContentView.userInteractionEnabled = true
        
        //Save Button
        self.view.addSubview(self.saveProfileButton)
        self.saveProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        let saveProfileButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
        
        let saveProfileButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2*self.minorMargin)
        
        let saveProfileButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 2*self.minorMargin * -1)
        
        let saveProfileButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
        
        self.saveProfileButton.addConstraint(saveProfileButtonHeightConstraint)
        self.view.addConstraints([saveProfileButtonLeftConstraint, saveProfileButtonRightConstraint, saveProfileButtonBottomConstraint])
        
        self.saveProfileButton.backgroundColor = UIColor.turquoiseColor()
        self.saveProfileButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
      if self.firstTimeUser {
        self.saveProfileButton.setTitle("Save & Continue", forState: UIControlState.Normal)
      }
      else {
        self.saveProfileButton.setTitle("Save Profile", forState: UIControlState.Normal)
      }
        self.saveProfileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.saveProfileButton.addTarget(self, action: #selector(ProfileViewController.saveProfile(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //Create profile entries - just copy past to add a new entry
        self.createNewEntry(self.entry1, IndexEntry: 1)
        self.createNewEntry(self.entry2, IndexEntry: 2)
        self.createNewEntry(self.entry3, IndexEntry: 3)
        
        let profileFirstName = self.defaults.objectForKey("profileFirstName") as! String
        let profileLastName = self.defaults.objectForKey("profileLastName") as! String
        let profileEmail = self.defaults.objectForKey("profileEmail") as! String
        
        if (profileFirstName == "") {
            
            self.entry1.attributedPlaceholder = NSAttributedString(string:"First Name", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
            
        }else{
            
            self.entry1.text = profileFirstName
            
        }
        
        if (profileLastName == "") {
            
            self.entry2.attributedPlaceholder = NSAttributedString(string:"Surname", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
            
        }else{
            
            self.entry2.text = profileLastName
            
        }
        
        if (profileEmail == "") {
            
            self.entry3.attributedPlaceholder = NSAttributedString(string:"Email address", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
            
        }else{
            
            self.entry3.text = profileEmail
            
        }
        
        
    }
    
    func createNewEntry(EntryImageView:UITextField, IndexEntry:Int) {
        
        self.profileContentView.addSubview(EntryImageView)
        EntryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        EntryImageView.userInteractionEnabled = true
        
        let EntryCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: EntryImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let EntryTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: EntryImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.profileContentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.minorMargin*CGFloat(IndexEntry)+CGFloat(self.profileEntryHeight*(IndexEntry-1)))
        let EntryHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: EntryImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(self.profileEntryHeight))
        let EntryWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: EntryImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*4)
        
        EntryImageView.addConstraints([EntryHeightConstraint, EntryWidthConstraint])
        self.profileContentView.addConstraints([EntryTopConstraint])
        self.view.addConstraints([EntryCenterXConstraint])
        
        EntryImageView.textColor = UIColor.whiteColor()
        EntryImageView.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        EntryImageView.textAlignment = NSTextAlignment.Center
        
        let borderBottom:UIImageView = UIImageView()
        EntryImageView.addSubview(borderBottom)
        borderBottom.backgroundColor = UIColor.whiteColor()
        borderBottom.setConstraintsToSuperview(self.profileEntryHeight-1, bottom: 0, left: 0, right: 0)
    }
    
    func goBackToSettingsMenu(sender: UIButton) {
        var alertMessage:String = String()
        alertMessage = "Any unsaved change will be lost."
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Continue", target:self, selector:#selector(ProfileViewController.goBackToSettings(_:)))
        backAlert.showTitle(
            "Return to Settings", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
    }
    
    func goBackToSettings(sender: UIButton) {
        self.performSegueWithIdentifier("backSettingsSegue", sender: nil)
    }
    
    func saveProfile(sender: UIButton) {
        
        var entry1Value:String = String()
        var entry2Value:String = String()
        var entry3Value:String = String()
        var alertMessage:String = String()
        var showErrorMessage:Bool = false
        
        entry1Value = entry1.text!
        entry2Value = entry2.text!
        entry3Value = entry3.text!
        
        //Check entry1Value (Name)
        if entry3Value.isEmpty {
            alertMessage = alertMessage + "No email address" + "\n"
            showErrorMessage = true
        } else {
            if !isValidEmail(entry3Value) {
                alertMessage = alertMessage + "Invalid email address." + "\n"
                showErrorMessage = true
            }
        }
        if entry2Value.isEmpty {
            alertMessage = alertMessage + "No surname." + "\n"
            showErrorMessage = true
        }
        if entry1Value.isEmpty {
            alertMessage = alertMessage + "No name." + "\n"
            showErrorMessage = true
        }
        if !checkName(entry1Value) {
            alertMessage = alertMessage + "Invalid name." + "\n"
            showErrorMessage = true
        }
        if !checkName(entry2Value) {
            alertMessage = alertMessage + "Invalid surname." + "\n"
            showErrorMessage = true
        }
        if showErrorMessage == true {
            
            //Show Error Message
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let backAlert = SCLAlertView(appearance: appearance)
            backAlert.showTitle(
                "Return", // Title of view
                subTitle: alertMessage, // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
        } else{
          
          //Save changes to Parse
          // Name: entry1Value
          // Surname: entry2Value
          // Email address: entry3Value
            
          SwiftSpinner.show("Saving changes")
            
            let currentUser = PFUser.currentUser()!
            //let objID = currentUser.objectId
            let username = currentUser.username
            let query = PFQuery(className: PF_USER_CLASS_NAME)
            query.whereKey(PF_USER_USERNAME, equalTo: username!)
            //query.getObjectInBackgroundWithId(objID!)
            query.getFirstObjectInBackgroundWithBlock({ (user: PFObject?, error: NSError?) -> Void in
                
                if error == nil {
                    
                    user![PF_USER_EMAIL] = entry3Value
                    user![PF_USER_FULLNAME_LOWER] = entry1Value + entry2Value
                    
                    user?.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            
                            self.defaults.setObject(entry1Value, forKey: "profileFirstName")
                            self.defaults.setObject(entry2Value, forKey: "profileLastName")
                            self.defaults.setObject(entry3Value, forKey: "profileEmail")
                            
                            SwiftSpinner.show("Career Preferences Saved", animated: false).addTapHandler({
                                
                                SwiftSpinner.hide()
                                //self.hideSettingsMenuView(sender)
                                
                                }, subtitle: "Tap to return to settings")
                            
                        } else {
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                SwiftSpinner.hide()
                                //self.hideSettingsMenuView(sender)
                                
                                }, subtitle: "Preferences unsaved, tap to return to settings")
                            
                        }
                        
                    })
                    
                }else{
                    
                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                        
                        SwiftSpinner.hide()
                        //self.hideSettingsMenuView(sender)
                        
                        }, subtitle: "Preferences unsaved, to return to settings")
                    
                }
            })

            
          
          if self.firstTimeUser {
            self.performSegueWithIdentifier("tutorialEnded", sender: sender)
          }
          else {
            // Segue back to Settings?
          }
            
          
            
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func checkName(testStr:String) -> Bool {
        let letters = NSCharacterSet.letterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var letterCount = 0
        var digitCount = 0
        for uni in testStr.unicodeScalars {
            if letters.longCharacterIsMember(uni.value) {
                letterCount += 1
            } else if digits.longCharacterIsMember(uni.value) {
                digitCount += 1
            }
        }
        if letterCount == testStr.characters.count {
            return true
        } else {
            return false
        }
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "tutorialEnded" {
      let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
      destinationVC.firstTimeUser = true
      destinationVC.segueFromLoginView = false
    }
  }
}