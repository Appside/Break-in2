//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse
import GoogleMobileAds


class BrainBreakerViewController: UIViewController, GADInterstitialDelegate {
    
    var backButton:UIButton = UIButton()
    var helpButton:UIButton = UIButton()
    var statusBarFrame:CGRect = CGRect()
    let majorMargin:CGFloat = 20
    let minorMargin:CGFloat = 10
    var backButtonHeight:CGFloat = CGFloat()
    var screenFrame:CGRect = CGRect()
    var brainBreakerLabel:UILabel = UILabel()
    var nextButton:UIButton = UIButton()
    var brainLogo:UIImageView = UIImageView()
    var flexibleHeight:CGFloat = CGFloat()
    var prizeLabel:UILabel = UILabel()
    var numberOfLives:Int = 2
    var life1:UIImageView = UIImageView()
    var life2:UIImageView = UIImageView()
    var life3:UIImageView = UIImageView()
    var timeRemaining:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Size variables
        self.screenFrame = UIScreen.mainScreen().bounds
        self.statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.backButtonHeight = UIScreen.mainScreen().bounds.width/12
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        self.flexibleHeight = (height-(self.statusBarFrame.height+10*self.minorMargin+5.5*backButtonHeight))/3
        
        //Background Image
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        backgroundImageView.image = UIImage(named: "brainbreakerBG")
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
     
        //Back Button
        self.view.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
        self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
        self.backButton.setImage(UIImage.init(named: "prevButton")!, forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: #selector(BrainBreakerViewController.backHome(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.clipsToBounds = true
        
        //Main Title
        self.view.addSubview(self.brainBreakerLabel)
        self.brainBreakerLabel.translatesAutoresizingMaskIntoConstraints = false
        let brainBreakerLabelCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let brainBreakerLabelTop:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let brainBreakerLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let brainBreakerLabelWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width-4*self.majorMargin - 2*self.backButtonHeight)
        self.brainBreakerLabel.addConstraints([brainBreakerLabelHeight, brainBreakerLabelWidth])
        self.view.addConstraints([brainBreakerLabelCenterX, brainBreakerLabelTop])
        let labelString:String = String("BRAIN BREAKER")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.turquoiseColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.brainBreakerLabel.attributedText = attributedString
        self.brainBreakerLabel.textAlignment = NSTextAlignment.Center
        
        //Help Button
        self.view.addSubview(self.helpButton)
        self.helpButton.translatesAutoresizingMaskIntoConstraints = false
        let helpButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        let helpButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let helpButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let helpButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.helpButton.addConstraints([helpButtonHeightConstraint, helpButtonWidthConstraint])
        self.view.addConstraints([helpButtonRightConstraint, helpButtonTopConstraint])
        self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.helpScreen(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.helpButton.clipsToBounds = true
        self.helpButton.layer.cornerRadius = self.screenFrame.width/24
        self.helpButton.layer.borderWidth = 2
        self.helpButton.layer.borderColor = UIColor.turquoiseColor().CGColor
        self.helpButton.setTitle("?", forState: UIControlState.Normal)
        self.helpButton.setTitleColor(UIColor.turquoiseColor(), forState: UIControlState.Normal)
        self.helpButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 24.0)
        
        //Next Button
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        let nextButtonLabelBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -2*self.minorMargin)
        let nextButtonLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight*1.5)
        let nextButtonLabelLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let nextButtonLabelRight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([nextButtonLabelBottom, nextButtonLabelLeft, nextButtonLabelRight])
        self.nextButton.addConstraints([nextButtonLabelHeight])
        self.nextButton.backgroundColor = UIColor.turquoiseColor()
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.nextButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.nextButton.setTitle("START", forState: UIControlState.Normal)
        self.nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        
        //Brain Breaker Brain Logo
        self.view.addSubview(self.brainLogo)
        self.brainLogo.translatesAutoresizingMaskIntoConstraints = false
        let brainLogoCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainLogo, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let brainLogoTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height + 4*self.minorMargin + self.backButtonHeight)
        let brainLogoHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        let brainLogoWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        self.brainLogo.addConstraints([brainLogoHeightConstraint, brainLogoWidthConstraint])
        self.view.addConstraints([brainLogoTopConstraint,brainLogoCenterX])
        self.brainLogo.image = UIImage.init(named: "brainbreakerBrainLogo")
        self.brainLogo.clipsToBounds = true
        
        //Split remaining height in 3 frames
        let frameTop:UIView = UIView()
        let frameMid:UIView = UIView()
        let frameBottom:UIView = UIView()
        self.view.addSubview(frameTop)
        self.view.addSubview(frameMid)
        self.view.addSubview(frameBottom)
        frameTop.translatesAutoresizingMaskIntoConstraints = false
        frameMid.translatesAutoresizingMaskIntoConstraints = false
        frameBottom.translatesAutoresizingMaskIntoConstraints = false
        
        //Frame 1
        let frameTopTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameTop, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height+6*self.minorMargin+4*self.backButtonHeight)
        let frameTopLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameTop, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameTopRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameTop, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([frameTopTopConstraint,frameTopLeftConstraint,frameTopRightConstraint])
        let frameTopHeight:NSLayoutConstraint = NSLayoutConstraint(item: frameTop, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        frameTop.addConstraint(frameTopHeight)
        
        //Frame 2
        let frameMidTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameMid, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height+6*self.minorMargin+4*self.backButtonHeight+self.flexibleHeight)
        let frameMidLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameMid, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameMidRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameMid, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([frameMidTopConstraint,frameMidLeftConstraint,frameMidRightConstraint])
        let frameMidHeight:NSLayoutConstraint = NSLayoutConstraint(item: frameMid, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        frameMid.addConstraint(frameMidHeight)

        //Frame 3
        let frameBottomTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameBottom, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: self.statusBarFrame.height+6*self.minorMargin+4*self.backButtonHeight+2*self.flexibleHeight)
        let frameBottomLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameBottom, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: self.majorMargin)
        let frameBottomRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: frameBottom, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([frameBottomTopConstraint,frameBottomLeftConstraint,frameBottomRightConstraint])
        let frameBottomHeight:NSLayoutConstraint = NSLayoutConstraint(item: frameBottom, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        frameBottom.addConstraint(frameBottomHeight)
        
        //Frame 1 -- Content
        frameTop.addSubview(self.prizeLabel)
        self.prizeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.prizeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.prizeLabel.text = "ARSENAL TICKETS"
        self.prizeLabel.textAlignment = NSTextAlignment.Center
        self.prizeLabel.textColor = UIColor.turquoiseColor()
        let currentPrize:UILabel =  UILabel()
        frameTop.addSubview(currentPrize)
        currentPrize.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
        currentPrize.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        currentPrize.text = "CURRENT PRIZE"
        currentPrize.textAlignment = NSTextAlignment.Center
        currentPrize.textColor = UIColor.turquoiseColor()
        let borderBottom:UIView = UIView()
        frameTop.addSubview(borderBottom)
        borderBottom.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 2 -- Content
        let livesUIView:UIView = UIView()
        frameMid.addSubview(livesUIView)
        livesUIView.setConstraintsToSuperview(Int(self.flexibleHeight)/2-30, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        
        livesUIView.addSubview(self.life2)
        self.life2.translatesAutoresizingMaskIntoConstraints = false
        let life2CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let life2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life2CenterX,life2Top])
        let life2Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life2.addConstraints([life2Width,life2Height])
        self.life2.image = UIImage(named: "crossSelected")
        self.life2.clipsToBounds = true
        
        livesUIView.addSubview(self.life1)
        self.life1.translatesAutoresizingMaskIntoConstraints = false
        let life1CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -self.backButtonHeight/1.3-2*self.minorMargin)
        let life1Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life1CenterX,life1Top])
        let life1Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life1Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life1.addConstraints([life1Width,life1Height])
        self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
        self.life1.clipsToBounds = true
        
        livesUIView.addSubview(self.life3)
        self.life3.translatesAutoresizingMaskIntoConstraints = false
        let life3CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: self.backButtonHeight/1.3+2*self.minorMargin)
        let life3Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: livesUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life3CenterX,life3Top])
        let life3Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life3Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life3.addConstraints([life3Width,life3Height])
        self.life3.image = UIImage(named: "crossSelected")
        self.life3.clipsToBounds = true
        
        let attemptsLabel:UILabel =  UILabel()
        frameMid.addSubview(attemptsLabel)
        attemptsLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-30, left: 0, right: 0)
        attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        attemptsLabel.text = "NUMBER OF ATTEMPTS REMAINING"
        attemptsLabel.textAlignment = NSTextAlignment.Center
        attemptsLabel.textColor = UIColor.turquoiseColor()
        let borderBottom2:UIView = UIView()
        frameMid.addSubview(borderBottom2)
        borderBottom2.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom2.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 3 -- Content
        frameBottom.addSubview(self.timeRemaining)
        self.timeRemaining.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.timeRemaining.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.timeRemaining.text = "01:00:00"
        self.timeRemaining.textAlignment = NSTextAlignment.Center
        self.timeRemaining.textColor = UIColor.turquoiseColor()
        let timeLabel:UILabel =  UILabel()
        frameBottom.addSubview(timeLabel)
        timeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
        timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        timeLabel.text = "TIME REMAINING BEFORE CLOSING"
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.textColor = UIColor.turquoiseColor()
        
    }
    
    func backHome(sender:UITapGestureRecognizer) {

        let alertMessage:String = "Are you sure you want to return home?"
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:Selector("goBack"))
        backAlert.showTitle(
            "Return to Menu", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
    }
    
    func goBack(){

        self.performSegueWithIdentifier("backHomeSegue", sender: nil)
        
    }
    
    func helpScreen(sender:UITapGestureRecognizer) {

        
        
    }
    
}
    