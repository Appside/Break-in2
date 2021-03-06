//
//  EditProfileViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftSpinner
import Eureka
import Firebase
import FirebaseDatabase

class EditProfileViewController : FormViewController {
    
//---------------------------------------------------------------
// STEP 0: GLOBAL VARIABLES
//---------------------------------------------------------------
    
    // Set up Firebase for read / write access
    var ref: DatabaseReference!
    
    var statusBarFrame:CGRect = CGRect()
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    var backButton:UIButton = UIButton()
    var backButtonHeight:CGFloat = 0
    var screenFrame:CGRect = CGRect()
    var logoImageView:UILabel = UILabel()
    var firstTimeUser:Bool = false
    var pageDescription:UILabel = UILabel()
    var pageDescriptionSub:UILabel = UILabel()
    var saveProfileButton:UIButton = UIButton()
    let menuButtonHeight:CGFloat = 50
    let defaults = UserDefaults.standard
    var buttonTitle:String = String()
    var fieldsColor:UIColor = UIColor()
    var skinType:Int = 2
    
    var profileFirstName:String = String()
    var profileLastName:String = String()
    var profileEmail:String = String()
    var profilePhone:String = String()
    var profileUniversity:String = String()
    var profileCourse:String = String()
    var profileDegree:String = String()
    var profilePosition:String = String()
    var shareInfoAllowed:Bool? = Bool()
    var recommendedBy:String = String()
    var sourceRecommendation:[String] = [String]()
    var check:Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textString1:String = "WHO TOLD YOU ABOUT US?"
        let textHeight1:CGFloat = self.view.heightForView(textString1, font: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, width: self.view.frame.width-50)
        
        let textString2:String = "SHARE YOUR PROFILE WITH PROSPECTIVE EMPLOYERS"
        let textHeight2:CGFloat = self.view.heightForView(textString2, font: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, width: self.view.frame.width-50)
        
        let textString3:String = "TELL US ABOUT YOURSELF"
        let textHeight3:CGFloat = self.view.heightForView(textString3, font: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, width: self.view.frame.width-50)
        
        let textString4:String = "FIELDS MARKED AS (*) ARE MANDATORY"
        let textHeight4:CGFloat = self.view.heightForView(textString4, font: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, width: self.view.frame.width-50)
        
        //check if user is logged in
        checkIfUserIsLoggedIn()
        
        //Status Bar Background
        let NewView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        self.view.addSubview(NewView)
        
        if self.firstTimeUser == true {
            self.skinType = 1
        }
        if self.skinType == 1 {
            self.tableView?.backgroundColor = UIColor.black
            self.fieldsColor = UIColor(white: 0.0, alpha: 0.0)
            NewView.backgroundColor = UIColor.black
        } else {
            self.tableView?.backgroundColor = UIColor.turquoiseColor()
            self.fieldsColor = UIColor(red: 50/255, green: 120/255, blue: 123/255, alpha: 0.35)
            NewView.backgroundColor = UIColor.turquoiseColor()
        }
        
        self.screenFrame = UIScreen.main.bounds
        self.statusBarFrame = UIApplication.shared.statusBarFrame
        self.backButtonHeight = UIScreen.main.bounds.width/12
        
        if self.firstTimeUser {
            self.buttonTitle = "Save & Continue"
        }
        else {
            self.buttonTitle = "Save Profile"
        }
        
        self.profileFirstName = self.defaults.object(forKey: "profileFirstName") as? String ?? String()
        self.profileLastName = self.defaults.object(forKey: "profileLastName") as? String ?? String()
        self.profileEmail = self.defaults.object(forKey: "profileEmail") as? String ?? String()
        self.profilePhone = self.defaults.object(forKey: "profilePhone") as? String ?? String()
        self.profileUniversity = self.defaults.object(forKey: "profileUniversity") as? String ?? String()
        self.profileCourse = self.defaults.object(forKey: "profileCourse") as? String ?? String()
        self.profileDegree = self.defaults.object(forKey: "profileDegree") as? String ?? String()
        self.profilePosition = self.defaults.object(forKey: "profilePosition") as? String ?? String()
        self.shareInfoAllowed = self.defaults.object(forKey: "shareInfoAllowed") as? Bool ?? Bool()
        self.recommendedBy = self.defaults.object(forKey: "recommendedBy") as? String ?? String()
        
        form =

        Section(){ section in
            var header = HeaderFooterView<ProfileHeaderUIView>(.class)
            header.height = {self.statusBarFrame.height + 6*self.minorMargin + self.backButtonHeight + 40}
            header.onSetupView = { view, _ in
                view.addSubview(self.logoImageView)
                self.logoImageView.contentMode = UIViewContentMode.scaleAspectFit
                let labelString:String = String("BREAKIN2")
                let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(26))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(26))!, range: NSRange(location: 5, length: NSString(string: labelString).length-5))
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
                self.logoImageView.attributedText = attributedString
                self.logoImageView.clipsToBounds = true
                self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
                
                let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                
                let logoImageViewTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
                
                let logoImageViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
                
                let logoImageViewWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width/3)
                
                self.logoImageView.addConstraints([logoImageViewHeightConstraint, logoImageViewWidthConstraint])
                view.addConstraints([logoImageViewCenterXConstraint, logoImageViewTopConstraint])
                
                //Back Button
                view.addSubview(self.backButton)
                self.backButton.setImage(UIImage.init(named: "back")!, for: UIControlState.normal)
                self.backButton.addTarget(self, action: #selector(EditProfileViewController.goBackToSettingsMenu(_:)), for: UIControlEvents.touchUpInside)
                self.backButton.clipsToBounds = true
                if self.firstTimeUser {
                    self.backButton.alpha = 0
                }
                else {
                    self.backButton.alpha = 1
                }
                self.backButton.translatesAutoresizingMaskIntoConstraints = false
                
                let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
                
                let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
                
                let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
                
                let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
                
                self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
                view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
                
                //pageDescription set up
                view.addSubview(self.pageDescription)
                self.pageDescription.translatesAutoresizingMaskIntoConstraints = false
                
                let pageDescriptionCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                
                let pageDescriptionTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight)
                
                let pageDescriptionHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
                
                let pageDescriptionWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescription, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
                
                self.pageDescription.addConstraints([pageDescriptionHeightConstraint, pageDescriptionWidthConstraint])
                view.addConstraints([pageDescriptionCenterXConstraint, pageDescriptionTopConstraint])
                
                self.pageDescription.text = "EDIT PROFILE DETAILS"
                self.pageDescription.textColor = UIColor.white
                self.pageDescription.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
                self.pageDescription.textAlignment = NSTextAlignment.center
                
                //pageDescriptionSub set up
                view.addSubview(self.pageDescriptionSub)
                self.pageDescriptionSub.translatesAutoresizingMaskIntoConstraints = false
                
                let pageDescriptionSubCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                
                let pageDescriptionSubTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + 4*self.minorMargin + self.backButtonHeight + 20)
                
                let pageDescriptionSubHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
                
                let pageDescriptionSubWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.pageDescriptionSub, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.screenFrame.width - self.minorMargin*2)
                
                self.pageDescriptionSub.addConstraints([pageDescriptionSubHeightConstraint, pageDescriptionSubWidthConstraint])
                view.addConstraints([pageDescriptionSubCenterXConstraint, pageDescriptionSubTopConstraint])
                
                self.pageDescriptionSub.text = "This will help us tailor your experience"
                self.pageDescriptionSub.textColor = UIColor.white
                self.pageDescriptionSub.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                self.pageDescriptionSub.textAlignment = NSTextAlignment.center
                
            }
            section.header = header
            }
            
            <<< LabelRow(){
                $0.title = "Personal Details\n" +
                            "line 2"
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
                    if self.skinType == 1 {
                        cell.backgroundColor = UIColor.black
                        cell.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.8)
                    } else if self.skinType == 2{
                        cell.backgroundColor = UIColor.turquoiseColor()
                    }
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                }
            
            +++ Section { section in
                var header = HeaderFooterView<ProfileHeaderUIView>(.class)
                header.height = {textHeight4}
                header.onSetupView = { view, _ in
                    // Commonly used to setup texts inside the view
                    // Don't change the view hierarchy or size here!
                    let textView:UILabel = UILabel()
                    textView.numberOfLines = 0
                    textView.text = textString4
                    view.addSubview(textView)
                    textView.setConstraintsToSuperview(0, bottom: 0, left: 13, right: 13)
                    textView.textColor = UIColor(white: 1.0, alpha: 0.8)
                    textView.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
                }
                section.header = header
            }

            <<< NameRow("FirstName"){
                $0.title = "First Name *"
                $0.placeholder = "Type Last Name"
                $0.value = self.profileFirstName
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.textField.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.textField.textColor = UIColor.white
            }
            
            <<< NameRow("LastName"){
                $0.title = "Last Name *"
                $0.placeholder = "Type Last Name"
                $0.value = self.profileLastName
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.textField.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.textField.textColor = UIColor.white
            }
            
            <<< EmailRow("Email"){
                $0.title = "Email Address *"
                $0.placeholder = "Type Email Address"
                $0.value = self.profileEmail
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.textField.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.textField.textColor = UIColor.white
            }
            
            <<< PhoneRow("Phone"){
                $0.title = "Phone"
                $0.placeholder = "Type Phone"
                $0.value = self.profilePhone
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.textField.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.textField.textColor = UIColor.white
                }.onChange { row in
                    if row.value != nil{
                    self.profilePhone = row.value!
                    }
            }
            
            +++ LabelRow(){
                $0.title = "Academic Background"
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
                    if self.skinType == 1 {
                        cell.backgroundColor = UIColor.black
                        cell.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.8)
                    } else if self.skinType == 2{
                        cell.backgroundColor = UIColor.turquoiseColor()
                    }
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                }
            
            +++ Section { section in
                var header = HeaderFooterView<ProfileHeaderUIView>(.class)
                header.height = {textHeight3}
                header.onSetupView = { view, _ in
                    // Commonly used to setup texts inside the view
                    // Don't change the view hierarchy or size here!
                    let textView:UILabel = UILabel()
                    textView.numberOfLines = 0
                    textView.text = textString3
                    view.addSubview(textView)
                    textView.setConstraintsToSuperview(0, bottom: 0, left: 13, right: 13)
                    textView.textColor = UIColor(white: 1.0, alpha: 0.8)
                    textView.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
                }
                section.header = header
            }
            
            <<< NameRow("University"){
                $0.title = "University"
                $0.placeholder = "Type here"
                $0.value = self.profileUniversity
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.textField.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.textField.textColor = UIColor.white
                }.onChange { row in
                    if row.value != nil {
                    self.profileUniversity = row.value!
                    }
            }
            
            <<< ActionSheetRow<String>("Course") {
                $0.title = "Course Of Study"
                $0.baseValue = "click here"
                $0.selectorTitle = "What are you studying?"
                $0.options = ["Economics / Finance", "Engineering", "Mathematics / Sciences", "Computing", "Arts / Languages", "Other"]
                $0.value = self.profileCourse
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                }.onChange { row in
                    if row.value != nil {
                    self.profileCourse = row.value!
                    }
            }
            
            <<< ActionSheetRow<String>("Degree") {
                $0.title = "Degree Type"
                $0.selectorTitle = "What's your level of study?"
                $0.options = ["Bachelors","Masters","PhD"]
                $0.value = self.profileDegree
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                }.onChange { row in
                    self.profileDegree = row.value!
            }
            
            <<< ActionSheetRow<String>("Position") {
                $0.title = "Desired Position"
                $0.selectorTitle = "What are you looking for?"
                $0.options = ["Summer Internship","Off-cycle Internship","Full Time"]
                $0.value = self.profilePosition
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                }.onChange { row in
                    self.profilePosition = row.value!
            }
        
            +++ LabelRow(){
                $0.title = "Account Information"
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
                    if self.skinType == 1 {
                        cell.backgroundColor = UIColor.black
                        cell.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 0.8)
                    } else if self.skinType == 2{
                        cell.backgroundColor = UIColor.turquoiseColor()
                    }
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
            }

            +++ Section { section in
                var header = HeaderFooterView<ProfileHeaderUIView>(.class)
                header.height = {textHeight2}
                header.onSetupView = { view, _ in
                    // Commonly used to setup texts inside the view
                    // Don't change the view hierarchy or size here!
                    let textView:UILabel = UILabel()
                    textView.numberOfLines = 0
                    textView.text = textString2
                    view.addSubview(textView)
                    textView.setConstraintsToSuperview(0, bottom: 0, left: 13, right: 13)
                    textView.textColor = UIColor(white: 1.0, alpha: 0.8)
                    textView.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
                }
                section.header = header
            }
            
            <<< SwitchRow("switchRowTag"){
                $0.title = "Share My Profile"
                
                self.check = self.defaults.object(forKey: "checkSwitch") as? Int ?? Int()
                
                if self.check != 63 {
                    $0.value = true
                }else{
                    $0.value = self.shareInfoAllowed
                }
                
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = self.fieldsColor
                }.onChange { row in
                    
                    self.check = 63
                    self.defaults.set(self.check, forKey: "checkSwitch")
                    self.shareInfoAllowed = row.value!
            }
            <<< LabelRow(){
                
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag:"switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "You have allowed us to share your profile."
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: 12.0)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = self.fieldsColor
            }
        
            +++ Section { section in
                var header = HeaderFooterView<ProfileHeaderUIView>(.class)
                header.height = {textHeight1}
                header.onSetupView = { view, _ in
                    // Commonly used to setup texts inside the view
                    // Don't change the view hierarchy or size here!
                    let textView:UILabel = UILabel()
                    textView.numberOfLines = 0
                    textView.text = textString1
                    view.addSubview(textView)
                    textView.setConstraintsToSuperview(0, bottom: 0, left: 13, right: 13)
                    textView.textColor = UIColor(white: 1.0, alpha: 0.8)
                    textView.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
                }
                section.header = header
            }
            
            <<< ActionSheetRow<String>("RecommendedBy") {
                $0.title = "Recommendation"
                $0.selectorTitle = "Who recommended you?"
                $0.options = self.sourceRecommendation
                $0.value = self.recommendedBy
                }.cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    cell.backgroundColor = self.fieldsColor
                    row.options = self.sourceRecommendation
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.tintColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
                    row.options = self.sourceRecommendation
                }.onChange { row in
                    self.recommendedBy = row.value!
            }
            
            +++ ButtonRow() { (row: ButtonRow) -> Void in
                row.title = self.buttonTitle
                }.onCellSelection({ (cell, row) in
                    self.saveProfile(UIButton())
                }).cellSetup{ cell, row in
                    cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
                    if self.skinType == 1 {
                        let turquoiseView = UIView()
                        turquoiseView.backgroundColor = .turquoiseColor()
                        cell.backgroundView = turquoiseView
                    }
                }.cellUpdate { cell, row in
                    if self.skinType == 1 {
                        cell.textLabel?.textColor = UIColor.white
                    } else if self.skinType == 2{
                        cell.textLabel?.textColor = UIColor.turquoiseColor()
                    }
        }
    
    }

    func goBackToSettingsMenu(_ sender: UIButton) {
        var alertMessage:String = String()
        alertMessage = "Any unsaved change will be lost."
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Continue", target:self, selector:#selector(EditProfileViewController.goBackToSettings(_:)))
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
            self.view.alpha = 0
            //self.settingsMenuView.alpha = 0
            //self.settingsMenuViewTopConstraint.constant = self.screenFrame.height
            self.view.layoutIfNeeded()
            
            }, completion: {(Bool) in
                
                self.performSegue(withIdentifier: "toSettings", sender: nil)
                
        })
        
    }
    
    func saveProfile(_ sender: UIButton) {
        
        var alertMessage:String = String()
        var showErrorMessage:Bool = false
        
        if let newRow:NameRow = form.rowBy(tag:"FirstName") {
            if let newEntry = newRow.value {
                self.profileFirstName = newEntry
            } else {
                alertMessage = alertMessage + "Invalid First Name" + "\n"
                showErrorMessage = true
            }
        }
        
        if let newRow:NameRow = form.rowBy(tag:"LastName") {
            if let newEntry = newRow.value {
                self.profileLastName = newEntry
            } else {
                alertMessage = alertMessage + "Invalid Last Name" + "\n"
                showErrorMessage = true
            }
        }
        
        if let newRow:EmailRow = form.rowBy(tag:"Email") {
            if let newEntry = newRow.value {
                self.profileEmail = newEntry
                if !isValidEmail(self.profileEmail) {
                    alertMessage = alertMessage + "Invalid Email Address" + "\n"
                    showErrorMessage = true
                }
            } else {
                alertMessage = alertMessage + "No name." + "\n"
                showErrorMessage = true
            }
        }
        
        if let newRow:PhoneRow = form.rowBy(tag:"Phone") {
            if let newEntry = newRow.value {
                self.profilePhone = newEntry
                if self.profilePhone != "" && !phoneNumberValidation(value: self.profilePhone) {
                    alertMessage = alertMessage + "Invalid Phone Number" + "\n"
                    showErrorMessage = true
                }
            }
        }
        
        if showErrorMessage == true {
            
            //Show Error Message
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let backAlert = SCLAlertView(appearance: appearance)
            backAlert.showTitle(
                "Return", // Title of view
                subTitle: alertMessage, // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
        } else{
            
            SwiftSpinner.show("Saving changes")
            
            self.ref = Database.database().reference()
            
            if let currentUser = Auth.auth().currentUser {
            
                var membershipType:String = String()
                var premiumSwitch:Bool = Bool()
                var freeSwitch:Bool = Bool()
                
                membershipType = self.defaults.object(forKey: "Membership") as! String
                
                if membershipType == "Premium" {
                    
                    premiumSwitch = true
                    freeSwitch = false
                    
                }else{
                    
                    premiumSwitch = false
                    freeSwitch = true
                    membershipType = "Free"
                    
                }
                
                
                let key = self.ref.child(FBASE_USER_NODE).child(currentUser.uid).key
                
                let post =
                    [FBASE_USER_FULLNAME: currentUser.displayName,
                     FBASE_USER_USERID: currentUser.uid,
                     FBASE_USER_EMAIL: self.profileEmail,
                     FBASE_USER_FIRST_NAME: self.profileFirstName,
                     FBASE_USER_SURNAME: self.profileLastName,
                     FBASE_USER_PHONE: self.profilePhone,
                     FBASE_USER_UNIVERSITY: self.profileUniversity,
                     FBASE_USER_COURSE: self.profileCourse,
                     FBASE_USER_DEGREE: self.profileDegree,
                     FBASE_USER_POSITION: self.profilePosition,
                     FBASE_USER_SHARE_INFO_ALLOWED: self.shareInfoAllowed,
                     FBASE_USER_RECOMMENDED_BY: self.recommendedBy,
                     FBASE_USER_FREEMEMBERSHIP: freeSwitch,
                     FBASE_USER_PAIDMEMBERSHIP: premiumSwitch,
                    ] as [String : Any]
                
                let childUpdate = ["Users/\(key)": post]
                self.ref.updateChildValues(childUpdate)
                
                self.defaults.set(self.profileFirstName, forKey: "profileFirstName")
                self.defaults.set(self.profileLastName, forKey: "profileLastName")
                self.defaults.set(self.profileEmail, forKey: "profileEmail")
                self.defaults.set(self.profilePhone, forKey: "profilePhone")
                self.defaults.set(self.profileUniversity, forKey: "profileUniversity")
                self.defaults.set(self.profileCourse, forKey: "profileCourse")
                self.defaults.set(self.profileDegree, forKey: "profileDegree")
                self.defaults.set(self.profilePosition, forKey: "profilePosition")
                self.defaults.set(self.shareInfoAllowed, forKey: "shareInfoAllowed")
                self.defaults.set(self.recommendedBy, forKey: "recommendedBy")
                
                SwiftSpinner.show("Preferences Saved", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    self.goBackToSettings(sender)
                    //self.hideSettingsMenuView(sender)
                    
                }, subtitle: "Tap to return to settings")

                
            }else{
                
                SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                    
                    SwiftSpinner.hide()
                    //self.hideSettingsMenuView(sender)
                    
                }, subtitle: "Preferences unsaved, to return to settings")
                
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
    
    func phoneNumberValidation(value: String) -> Bool {
        if value.isPhoneNumber == true {
            return true
        }else {
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
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
     
        navigationController?.popViewController(animated: true)
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            self.ref = Database.database().reference()
            self.ref.child(FBASE_RECOMMENDATIONS_NODE).queryOrderedByKey().observe(.value, with: {
                
                (snapshot) in
                
                if snapshot.exists() {
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        self.sourceRecommendation.append(rest.value as! String)
                    }
                    
                }
                
            })

        }
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }

}

class ProfileHeaderUIView:UIView {
    
}
