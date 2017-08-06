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
import Eureka
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
//---------------------------------------------------------------
// STEP 0: GLOBAL VARIABLES
//---------------------------------------------------------------
    
    // Set up Firebase for read / write access
    var ref: DatabaseReference!
    
    // Declare and intialize views
    var backgroundImageView:UIImageView = UIImageView()
    var mainView:UIView = UIView()
    var logoImageView:UILabel = UILabel()
    var backButtonImageVIew:UIImageView = UIImageView()
    var screenFrame:CGRect = CGRect()
    var statusBarFrame:CGRect = CGRect()
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    var backButtonHeight:CGFloat = 0
    var backButton:UIButton = UIButton()
    var pageDescription:UILabel = UILabel()
    var pageDescriptionSub:UILabel = UILabel()
    var profileView:UIView = UIView()
    var ProfileForm:EditProfileViewController = EditProfileViewController()
    let tutorialNextButton:UIButton = UIButton()
    var descriptionLabelView:TutorialDescriptionView = TutorialDescriptionView()
    
    var saveProfileButton:UIButton = UIButton()
    let menuButtonHeight:CGFloat = 50
    var firstTimeUser:Bool = false
    var tutorialPageNumber:Int = 0
    var textSize:CGFloat = 15
    
    let defaults = UserDefaults.standard
    
//---------------------------------------------------------------
// STEP 1: VIEW DID LOAD
//---------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textSize = self.view.getTextSize(15)
        
        //Hide Keyboard
        self.hideKeyboardWhenTappedAround()
        
        //Initialize size variables
        self.screenFrame = UIScreen.main.bounds
        self.statusBarFrame = UIApplication.shared.statusBarFrame
        self.backButtonHeight = UIScreen.main.bounds.width/12
        
        //Background View
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.image = UIImage.init(named: "homeBG")
        self.backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.view.addSubview(self.mainView)
        
        //Main View
        self.mainView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.mainView.backgroundColor = UIColor.black
        self.mainView.alpha = 0.8
        self.view.sendSubview(toBack: self.backgroundImageView)
        
        //Logo ImageVIew
        self.view.addSubview(self.logoImageView)
        self.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        let labelString:String = String("BREAKIN2")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(26))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(26))!, range: NSRange(location: 5, length: NSString(string: labelString).length-5))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.logoImageView.attributedText = attributedString
        self.logoImageView.clipsToBounds = true
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        
        let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
        
        self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
        self.view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
        
        //Back Button
        self.view.addSubview(self.backButton)
        self.backButton.setImage(UIImage.init(named: "back")!, for: UIControlState())
        self.backButton.addTarget(self, action: #selector(ProfileViewController.goBackToSettingsMenu(_:)), for: UIControlEvents.touchUpInside)
        self.backButton.clipsToBounds = true
        if self.firstTimeUser {
            self.backButton.alpha = 0
        }
        else {
            self.backButton.alpha = 1
        }
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        
        let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        
        let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        
        self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
        self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
        
        //pageDescription set up
        self.view.addSubview(self.pageDescription)
        self.pageDescription.translatesAutoresizingMaskIntoConstraints = false
        
        let pageDescriptionCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let pageDescriptionTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight)
        
        let pageDescriptionHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        
        let pageDescriptionWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
        
        self.pageDescription.addConstraints([pageDescriptionHeightConstraint, pageDescriptionWidthConstraint])
        self.view.addConstraints([pageDescriptionCenterXConstraint, pageDescriptionTopConstraint])
        
        self.pageDescription.text = "EDIT PROFILE DETAILS"
        self.pageDescription.textColor = UIColor.white
        self.pageDescription.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.pageDescription.textAlignment = NSTextAlignment.center
        
        //pageDescriptionSub set up
        self.view.addSubview(self.pageDescriptionSub)
        self.pageDescriptionSub.translatesAutoresizingMaskIntoConstraints = false
        
        let pageDescriptionSubCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let pageDescriptionSubTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + 4*self.minorMargin + self.backButtonHeight + 20)
        
        let pageDescriptionSubHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        
        let pageDescriptionSubWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
        
        self.pageDescriptionSub.addConstraints([pageDescriptionSubHeightConstraint, pageDescriptionSubWidthConstraint])
        self.view.addConstraints([pageDescriptionSubCenterXConstraint, pageDescriptionSubTopConstraint])
        
        self.pageDescriptionSub.text = "This will help us tailor your experience"
        self.pageDescriptionSub.textColor = UIColor.white
        self.pageDescriptionSub.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.pageDescriptionSub.textAlignment = NSTextAlignment.center
        
        //Save Button
        self.view.addSubview(self.saveProfileButton)
        self.saveProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        let saveProfileButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.menuButtonHeight)
        
        let saveProfileButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 2*self.minorMargin)
        
        let saveProfileButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 2*self.minorMargin * -1)
        
        let saveProfileButtonBottomConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.saveProfileButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: (self.minorMargin * 2) * -1)
        
        self.saveProfileButton.addConstraint(saveProfileButtonHeightConstraint)
        self.view.addConstraints([saveProfileButtonLeftConstraint, saveProfileButtonRightConstraint, saveProfileButtonBottomConstraint])
        
        self.saveProfileButton.backgroundColor = UIColor.turquoiseColor()
        self.saveProfileButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        if self.firstTimeUser {
            self.saveProfileButton.setTitle("Save & Continue", for: UIControlState())
        }
        else {
            self.saveProfileButton.setTitle("Save Profile", for: UIControlState())
        }
        self.saveProfileButton.setTitleColor(UIColor.white, for: UIControlState())
        self.saveProfileButton.addTarget(self, action: #selector(ProfileViewController.saveProfile(_:)), for: UIControlEvents.touchUpInside)
        
        //Create profile entries - just copy past to add a new entry
        
        let profileFirstName = self.defaults.object(forKey: "profileFirstName") as? String ?? String()
        let profileLastName = self.defaults.object(forKey: "profileLastName") as? String ?? String()
        let profileEmail = self.defaults.object(forKey: "profileEmail") as? String ?? String()
        
        self.addChildViewController(self.ProfileForm)
        self.view.addSubview(self.ProfileForm.view)
        self.ProfileForm.didMove(toParentViewController: self)
        self.ProfileForm.view.setConstraintsToSuperview(Int(self.statusBarFrame.height + 6*self.minorMargin + self.backButtonHeight + 40), bottom: 3*Int(self.minorMargin)+Int(self.menuButtonHeight), left: Int(self.minorMargin*2), right: Int(self.minorMargin*2))
        
    }
    
    func goBackToSettingsMenu(_ sender: UIButton) {
        var alertMessage:String = String()
        alertMessage = "Any unsaved change will be lost."
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Continue", target:self, selector:#selector(ProfileViewController.goBackToSettings(_:)))
        backAlert.showTitle(
            "Return to Settings", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
    }
    
    func goBackToSettings(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            //self.chooseCareersView.alpha = 0
            self.backButton.alpha = 0
            self.mainView.alpha = 0
            //self.settingsMenuView.alpha = 0
            //self.settingsMenuViewTopConstraint.constant = self.screenFrame.height
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
                
                self.performSegue(withIdentifier: "toSettings", sender: nil)
                
        })
        
    }
    
    func saveProfile(_ sender: UIButton) {
        
        let entry1Value:String = String()
        let entry2Value:String = String()
        let entry3Value:String = String()
        var alertMessage:String = String()
        var showErrorMessage:Bool = false
        
        //Check entry1Value (Name)
        if entry3Value.isEmpty {
            alertMessage = alertMessage + "Please fill in your email address." + "\n"
            showErrorMessage = true
        } else {
            if !isValidEmail(entry3Value) {
                alertMessage = alertMessage + "Invalid email address." + "\n"
                showErrorMessage = true
            }
        }
        if entry2Value.isEmpty {
            alertMessage = alertMessage + "Please fill in your surname." + "\n"
            showErrorMessage = true
        }
        if entry1Value.isEmpty {
            alertMessage = alertMessage + "Please fill in your first name." + "\n"
            showErrorMessage = true
        }
        if !checkName(entry1Value) {
            alertMessage = alertMessage + "Invalid first name." + "\n"
            showErrorMessage = true
        }
        if !checkName(entry2Value) {
            alertMessage = alertMessage + "Invalid surname." + "\n"
            showErrorMessage = true
        }
        if showErrorMessage == true {
            
            //Show Error Message
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let backAlert = SCLAlertView(appearance: appearance)
            backAlert.showTitle(
                "Mandatory Fields Incomplete", // Title of view
                subTitle: alertMessage, // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
        } else{
            
            //Save changes to Firebase
            SwiftSpinner.show("Saving changes")
            
            self.ref = Database.database().reference()
            
            if let currentUser = Auth.auth().currentUser {
                self.ref.child(FBASE_USER_NODE).child(currentUser.uid).child(FBASE_USER_EMAIL).setValue(entry3Value)
                
                    self.ref.child(FBASE_USER_NODE).child(currentUser.uid).child(FBASE_USER_FULLNAME).setValue(entry1Value + " " + entry2Value)
                
                    self.ref.child(FBASE_USER_NODE).child(currentUser.uid).child(FBASE_USER_FIRST_NAME).setValue(entry1Value)
                
                    self.ref.child(FBASE_USER_NODE).child(currentUser.uid).child(FBASE_USER_SURNAME).setValue(entry2Value)
                
                self.defaults.set(entry1Value, forKey: "profileFirstName")
                self.defaults.set(entry2Value, forKey: "profileLastName")
                self.defaults.set(entry3Value, forKey: "profileEmail")
                
                SwiftSpinner.show("Career Preferences Saved", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    self.goBackToSettings(sender)
                    //self.hideSettingsMenuView(sender)
                    
                }, subtitle: "Tap to return to settings")
                
            }else{
                
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    //self.hideSettingsMenuView(sender)
                    
                }, subtitle: "Preferences unsaved, tap to return to settings")
                
            }
            
            if self.firstTimeUser {
                self.performSegue(withIdentifier: "tutorialEnded", sender: sender)
            }
            else {
                // Segue back to Settings?
            }
            
            
        }
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func checkName(_ testStr:String) -> Bool {
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        var letterCount = 0
        var digitCount = 0
        for uni in testStr.unicodeScalars {
            if letters.contains(UnicodeScalar(uni.value)!) {
                letterCount += 1
            } else if digits.contains(UnicodeScalar(uni.value)!) {
                digitCount += 1
            }
        }
        if letterCount == testStr.characters.count {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tutorialEnded" {
            let destinationVC:HomeViewController = segue.destination as! HomeViewController
            destinationVC.firstTimeUser = true
            destinationVC.segueFromLoginView = false
        }
    }
    
}
