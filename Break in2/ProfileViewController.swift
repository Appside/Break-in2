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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Background View
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.image = UIImage.init(named: "homeBG")
        self.backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.view.addSubview(self.mainView)
        
        //Main View
        self.mainView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.mainView.backgroundColor = UIColor.blackColor()
        self.mainView.alpha = 0.4
        self.view.sendSubviewToBack(self.backgroundImageView)
        
        //Logo ImageVIew
        self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.logoImageView.image = UIImage.init(named: "textBreakIn2Small")
        self.logoImageView.clipsToBounds = true

        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImageViewCenterXConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        //Back Button
        
        
    }
    
    func goBackToSettingsMenu() {
        var alertMessage:String = String()
        alertMessage = "Any unsaved change will be lost."
        let backAlert = SCLAlertView()
        backAlert.addButton("Continue", target:self, selector:Selector("goBackToSettings"))
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
    
    func goBackToSettings() {
        self.performSegueWithIdentifier("backSettingsSegue", sender: nil)
    }
}