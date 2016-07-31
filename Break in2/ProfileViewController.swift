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
    var profileScrollView:UIScrollView = UIScrollView()
    var profileContentView:UIView = UIView()
 
    let profileEntryHeight:Int = 40
    let nbOfProfileEntries:Int = 3
    var entry1:UITextField = UITextField()
    var entry2:UITextField = UITextField()
    var entry3:UITextField = UITextField()
    
    var saveProfileButton:UIButton = UIButton()
    let menuButtonHeight:CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.backButton.addTarget(self, action: "goBackToSettingsMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
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
        self.profileContentView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        
        let profileContentViewHeight:NSLayoutConstraint = NSLayoutConstraint.init(item: self.profileContentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: self.minorMargin*CGFloat(self.nbOfProfileEntries)+CGFloat(self.profileEntryHeight*(self.nbOfProfileEntries)))
        self.profileContentView.addConstraint(profileContentViewHeight)
        
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
        self.saveProfileButton.setTitle("Save Profile", forState: UIControlState.Normal)
        self.saveProfileButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.saveProfileButton.addTarget(self, action: "saveProfile:", forControlEvents: UIControlEvents.TouchUpInside)

        //Create profile entries - just copy past to add a new entry
        self.createNewEntry(self.entry1, IndexEntry: 1)
        self.createNewEntry(self.entry2, IndexEntry: 2)
        self.createNewEntry(self.entry3, IndexEntry: 3)
        
        self.entry1.text = "Name"
        self.entry2.text = "Surname"
        self.entry3.text = "Email address"
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
        let backAlert = SCLAlertView()
        backAlert.addButton("Continue", target:self, selector:Selector("goBackToSettings:"))
        backAlert.showTitle(
            "Return to Settings", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        backAlert.showCloseButton = false
    }
    
    func goBackToSettings(sender: UIButton) {
        self.performSegueWithIdentifier("backSettingsSegue", sender: nil)
    }
    
    func saveProfile(sender: UIButton) {
        
    }
}