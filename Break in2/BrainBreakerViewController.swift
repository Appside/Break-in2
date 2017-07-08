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
import SwiftSpinner

class BrainBreakerViewController: UIViewController, GADInterstitialDelegate {
    
    //Ad variables
    var interstitialAd:GADInterstitial!
    var testStarted:Bool = Bool()
    var AdBeforeClosing:Bool = false
    let defaults = UserDefaults.standard
    var membershipType:String = String()
    
    //Other variables
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
    var welcomeMenu:UIView = UIView()
    var helpMenu:UIView = UIView()
    var mainView:UIView = UIView()
    var questionType:String = String()
    var passage:String = String()
    var question:String = String()
    var answers:[String] = [String]()
    var correctAnswer:Int = Int()
    var explanation:String = String()
    var attemptsRemaining:Int = Int()
    var currentPrize:String = String()
    var questionNumber:Int = Int()
    let swipeUIView:UIView = UIView()
    var swipeMenuHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var swipeMenuBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
    let swipeMenuTopBar:UIView = UIView()
    let timeLabel:UILabel = UILabel()
    let descriptionSwipeLabel:UILabel = UILabel()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    let answerView:UIView = UIView()
    let questionView:UIView = UIView()
    let passageView:UIView = UIView()
    let passageLabel:UITextView = UITextView()
    let questionLabel:UITextView = UITextView()
    let submitButton:UILabel = UILabel()
    var quizzArray:[verbalQuestion] = [verbalQuestion]()
    var totalNumberOfQuestions:Int = 0
    var displayedQuestionIndex:Int = 0
    var selectedAnswers:[Int] = [Int]()
    var testEnded:Bool = false
    var timeTimer:Timer = Timer()
    var startTime:CFAbsoluteTime = CFAbsoluteTime()
    var time:Int = Int()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var newLabel:String = String()
    var timer:Timer = Timer()
    var frameTop:UIView = UIView()
    var frameMid:UIView = UIView()
    var frameBottom:UIView = UIView()
    var brainBreakerAlreadySolved:Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Ad loading
        self.membershipType = defaults.object(forKey: "Membership") as! String
        self.interstitialAd = self.createAndLoadInterstitial()
        self.testStarted = false
        self.questionLabel.isEditable = false
        self.passageLabel.isEditable = false
        
        //Size variables
        self.screenFrame = UIScreen.main.bounds
        self.statusBarFrame = UIApplication.shared.statusBarFrame
        self.backButtonHeight = UIScreen.main.bounds.width/12
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        self.flexibleHeight = (height-(self.statusBarFrame.height+10*self.minorMargin+5.5*backButtonHeight))/3
        self.widthRatio = self.screenFrame.size.width / 414
        self.heightRatio = self.screenFrame.size.height / 736
        
        //Initialize timer
        self.allowedSeconds = 00
        self.allowedMinutes = self.defaults.integer(forKey: "MinutesToAnswerBrainBreaker")
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Current Prize and BB variables
        self.questionType = self.defaults.object(forKey: "BrainBreakerQuestionType") as? String ?? String()
        self.passage = self.defaults.object(forKey: "BrainBreakerPassage") as? String ?? String()
        self.question = self.defaults.object(forKey: "BrainBreakerQuestion") as? String ?? String()
        self.answers = self.defaults.object(forKey: "BrainBreakerAnswers") as? [String] ?? [String]()
        self.correctAnswer = self.defaults.integer(forKey: "BrainBreakerCorrectAnswerIndex")
        self.explanation = self.defaults.object(forKey: "BrainBreakerExplanation") as? String ?? String()
        self.attemptsRemaining = self.defaults.integer(forKey: "NoOfBrainBreakerLives")
        self.currentPrize = self.defaults.object(forKey: "BrainBreakerTestPrize") as? String ?? String()
        self.questionNumber = self.defaults.integer(forKey: "BrainBreakerQuestionNumber")
        self.brainBreakerAlreadySolved = self.defaults.bool(forKey: "brainBreakerAnsweredCorrectly") as Bool ?? Bool()
        
        //Background Image
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundImageView.image = UIImage(named: "brainbreakerBG")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
        backgroundImageView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
     
        //Back Button
        self.view.addSubview(self.backButton)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonLeftConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let backButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let backButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let backButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.backButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.backButton.addConstraints([backButtonHeightConstraint, backButtonWidthConstraint])
        self.view.addConstraints([backButtonLeftConstraint, backButtonTopConstraint])
        self.backButton.setImage(UIImage.init(named: "prevButton")!, for: UIControlState())
        self.backButton.addTarget(self, action: #selector(BrainBreakerViewController.backHome(_:)), for: UIControlEvents.touchUpInside)
        self.backButton.clipsToBounds = true
        
        //Main Title
        self.view.addSubview(self.brainBreakerLabel)
        self.brainBreakerLabel.translatesAutoresizingMaskIntoConstraints = false
        let brainBreakerLabelCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let brainBreakerLabelTop:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let brainBreakerLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let brainBreakerLabelWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.brainBreakerLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width-4*self.majorMargin - 2*self.backButtonHeight)
        self.brainBreakerLabel.addConstraints([brainBreakerLabelHeight, brainBreakerLabelWidth])
        self.view.addConstraints([brainBreakerLabelCenterX, brainBreakerLabelTop])
        let labelString:String = String("BRAIN BREAKER")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.turquoiseColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.brainBreakerLabel.attributedText = attributedString
        self.brainBreakerLabel.textAlignment = NSTextAlignment.center
        
        //Help Button
        self.view.addSubview(self.helpButton)
        self.helpButton.translatesAutoresizingMaskIntoConstraints = false
        let helpButtonRightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -self.majorMargin)
        let helpButtonTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.statusBarFrame.height + self.minorMargin)
        let helpButtonHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        let helpButtonWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.helpButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight)
        self.helpButton.addConstraints([helpButtonHeightConstraint, helpButtonWidthConstraint])
        self.view.addConstraints([helpButtonRightConstraint, helpButtonTopConstraint])
        self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.ShowHelpScreen(_:)), for: UIControlEvents.touchUpInside)
        self.helpButton.clipsToBounds = true
        self.helpButton.layer.cornerRadius = self.screenFrame.width/24
        self.helpButton.layer.borderWidth = 2
        self.helpButton.layer.borderColor = UIColor.turquoiseColor().cgColor
        self.helpButton.setTitle("?", for: UIControlState())
        self.helpButton.setTitleColor(UIColor.turquoiseColor(), for: UIControlState())
        self.helpButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 24.0)

        //Add Welcome Menu
        self.view.addSubview(self.welcomeMenu)
        self.welcomeMenu.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(3*self.minorMargin+1.5*self.backButtonHeight), left: 0, right: 0)
        
        //Next Button
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        let nextButtonLabelBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -2*self.minorMargin)
        let nextButtonLabelHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight*1.5)
        let nextButtonLabelLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let nextButtonLabelRight:NSLayoutConstraint = NSLayoutConstraint(item: self.nextButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([nextButtonLabelBottom, nextButtonLabelLeft, nextButtonLabelRight])
        self.nextButton.addConstraints([nextButtonLabelHeight])
        self.nextButton.backgroundColor = UIColor.turquoiseColor()
        self.nextButton.setTitleColor(UIColor.white, for: UIControlState())
        self.nextButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        if (self.attemptsRemaining > 0) {
            
            self.nextButton.setTitle("START", for: UIControlState())
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.StartTest(_:)), for: UIControlEvents.touchUpInside)
            
        }else{
            
            self.nextButton.setTitle("RETURN HOME", for: UIControlState())
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBack), for: UIControlEvents.touchUpInside)
            
        }
        
        self.nextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.StartTest(_:)), for: UIControlEvents.touchUpInside)
        
        //Brain Breaker Brain Logo
        self.welcomeMenu.addSubview(self.brainLogo)
        self.brainLogo.translatesAutoresizingMaskIntoConstraints = false
        let brainLogoCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.brainLogo, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let brainLogoTopConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.minorMargin)
        let brainLogoHeightConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        let brainLogoWidthConstraint:NSLayoutConstraint = NSLayoutConstraint.init(item: self.brainLogo, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 3*self.backButtonHeight)
        self.brainLogo.addConstraints([brainLogoHeightConstraint, brainLogoWidthConstraint])
        self.welcomeMenu.addConstraints([brainLogoTopConstraint,brainLogoCenterX])
        self.brainLogo.image = UIImage.init(named: "brainbreakerBrainLogo")
        self.brainLogo.clipsToBounds = true
        
        //Split remaining height in 3 frames
        self.welcomeMenu.addSubview(self.frameTop)
        self.welcomeMenu.addSubview(self.frameMid)
        self.welcomeMenu.addSubview(self.frameBottom)
        self.frameTop.translatesAutoresizingMaskIntoConstraints = false
        self.frameMid.translatesAutoresizingMaskIntoConstraints = false
        self.frameBottom.translatesAutoresizingMaskIntoConstraints = false
        self.frameMid.alpha = 0.0
        
        //Frame 1
        let frameTopTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight)
        let frameTopLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let frameTopRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -self.majorMargin)
        self.welcomeMenu.addConstraints([frameTopTopConstraint,frameTopLeftConstraint,frameTopRightConstraint])
        let frameTopHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameTop, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameTop.addConstraint(frameTopHeight)
        
        //Frame 2
        let frameMidTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight+self.flexibleHeight)
        let frameMidLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let frameMidRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -self.majorMargin)
        self.view.addConstraints([frameMidTopConstraint,frameMidLeftConstraint,frameMidRightConstraint])
        let frameMidHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameMid, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameMid.addConstraint(frameMidHeight)

        //Frame 3
        let frameBottomTopConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 3*self.minorMargin+3*self.backButtonHeight+2*self.flexibleHeight)
        let frameBottomLeftConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let frameBottomRightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.welcomeMenu, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -self.majorMargin)
        self.welcomeMenu.addConstraints([frameBottomTopConstraint,frameBottomLeftConstraint,frameBottomRightConstraint])
        let frameBottomHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.frameBottom, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.flexibleHeight)
        self.frameBottom.addConstraint(frameBottomHeight)
        
        //Frame 1 -- Content
        self.frameTop.addSubview(self.prizeLabel)
        self.prizeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2-50, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.prizeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        self.prizeLabel.text = self.currentPrize.uppercased()
        self.prizeLabel.numberOfLines = 0
        self.prizeLabel.textAlignment = NSTextAlignment.center
        self.prizeLabel.textColor = UIColor.turquoiseColor()
        let currentPrize:UILabel =  UILabel()
        self.frameTop.addSubview(currentPrize)
        currentPrize.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-20, left: 0, right: 0)
        currentPrize.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        currentPrize.text = "CURRENT PRIZE"
        currentPrize.textAlignment = NSTextAlignment.center
        currentPrize.textColor = UIColor.turquoiseColor()
        let borderBottom:UIView = UIView()
        self.frameTop.addSubview(borderBottom)
        borderBottom.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 2 -- Content
        let livesUIView:UIView = UIView()
        self.frameMid.addSubview(livesUIView)
        livesUIView.setConstraintsToSuperview(15, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        
        livesUIView.addSubview(self.life2)
        self.life2.translatesAutoresizingMaskIntoConstraints = false
        let life2CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let life2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life2CenterX,life2Top])
        let life2Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life2Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life2.addConstraints([life2Width,life2Height])
        self.life2.clipsToBounds = true
        
        livesUIView.addSubview(self.life1)
        self.life1.translatesAutoresizingMaskIntoConstraints = false
        let life1CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -self.backButtonHeight/1.3-2*self.minorMargin)
        let life1Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life1CenterX,life1Top])
        let life1Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life1Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life1.addConstraints([life1Width,life1Height])
        self.life1.clipsToBounds = true
        
        livesUIView.addSubview(self.life3)
        self.life3.translatesAutoresizingMaskIntoConstraints = false
        let life3CenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: self.backButtonHeight/1.3+2*self.minorMargin)
        let life3Top:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        livesUIView.addConstraints([life3CenterX,life3Top])
        let life3Width:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        let life3Height:NSLayoutConstraint = NSLayoutConstraint(item: self.life3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
        self.life3.addConstraints([life3Width,life3Height])
        self.life3.clipsToBounds = true
        
        if self.attemptsRemaining == 3 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life3.image = UIImage(named: "tickSelectedBrainbreaker")
        } else if self.attemptsRemaining == 2 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life3.image = UIImage(named: "crossSelected")
        } else if self.attemptsRemaining == 1 {
            self.life1.image = UIImage(named: "tickSelectedBrainbreaker")
            self.life2.image = UIImage(named: "crossSelected")
            self.life3.image = UIImage(named: "crossSelected")
        } else {
            self.life1.image = UIImage(named: "crossSelected")
            self.life2.image = UIImage(named: "crossSelected")
            self.life3.image = UIImage(named: "crossSelected")
        }
        
        let attemptsLabel:UILabel =  UILabel()
        self.frameMid.addSubview(attemptsLabel)
        attemptsLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-30, left: 0, right: 0)
        attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        attemptsLabel.text = "NUMBER OF ATTEMPTS REMAINING"
        attemptsLabel.textAlignment = NSTextAlignment.center
        attemptsLabel.textColor = UIColor.turquoiseColor()
        let borderBottom2:UIView = UIView()
        self.frameMid.addSubview(borderBottom2)
        borderBottom2.setConstraintsToSuperview(Int(self.flexibleHeight)-1, bottom: 0, left: 0, right: 0)
        borderBottom2.backgroundColor = UIColor.turquoiseColor()
        
        //Frame 3 -- Content
        self.frameBottom.addSubview(self.timeRemaining)
        self.timeRemaining.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2, left: 0, right: 0)
        self.timeRemaining.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.timeRemaining.text = "00:00:00"
        self.timeRemaining.textAlignment = NSTextAlignment.center
        self.timeRemaining.textColor = UIColor.turquoiseColor()
        let timeLabel:UILabel =  UILabel()
        self.frameBottom.addSubview(timeLabel)
        timeLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
        timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        timeLabel.text = "TIME REMAINING BEFORE CLOSING"
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.textColor = UIColor.turquoiseColor()
        
        //Set up Help Menu
        self.helpMenu.alpha = 0.0
        self.view.addSubview(self.helpMenu)
        self.helpMenu.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(2*self.minorMargin+1.5*self.backButtonHeight), left: 0, right: 0)
        
        let pageTitle:UILabel = UILabel()
        self.helpMenu.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        let pageTitleCenterX:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let pageTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.flexibleHeight-20)
        let pageTitleLeft:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 4*self.minorMargin)
        let pageTitleRight:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -4*self.minorMargin)
        self.helpMenu.addConstraints([pageTitleCenterX,pageTitleTop,pageTitleLeft,pageTitleRight])
        let pageTitleHeight:NSLayoutConstraint = NSLayoutConstraint(item: pageTitle, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        pageTitle.addConstraint(pageTitleHeight)
        
        pageTitle.font = UIFont(name: "HelveticaNeue-MEDIUM", size: 18)
        pageTitle.textAlignment = NSTextAlignment.center
        pageTitle.textColor = UIColor.turquoiseColor()
        pageTitle.text = "WHAT IS THE BRAIN BREAKER?"
        
        let explanation:UILabel = UILabel()
        self.helpMenu.addSubview(explanation)
        explanation.translatesAutoresizingMaskIntoConstraints = false
        let explanationCenterX:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let explanationTop:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.top, multiplier: 1, constant: self.flexibleHeight+50)
        let explanationLeft:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 4*self.minorMargin)
        let explanationRight:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.helpMenu, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -4*self.minorMargin)
        self.helpMenu.addConstraints([explanationCenterX,explanationTop,explanationLeft,explanationRight])
        let explanationHeight:NSLayoutConstraint = NSLayoutConstraint(item: explanation, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.flexibleHeight+80)
        explanation.addConstraint(explanationHeight)

        explanation.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        explanation.textAlignment = NSTextAlignment.center
        explanation.textColor = UIColor.turquoiseColor()
        explanation.numberOfLines = 0
        
        let attributedString2 = NSMutableAttributedString(string:"The Brain Breaker is a regular challenge which gives you the chance to win great prizes! Free users are provided with one attempt at answering correctly, whilst Premium users are given 3 additional attempts. Get the question right and you will be entered into a prize draw; we will announce the winner on our Facebook page shortly after the deadline.")
        
//        attributedString2.setAsLink("Find us here...", linkURL: UIApplication.tryURL([
//            "fb://profile/1586553761670526", // App
//            "https://www.facebook.com/breakin2app" // Website if app fails
//            ]))
        
        explanation.attributedText = attributedString2
        explanation.isUserInteractionEnabled = true
        
        //Set Up QUestion Menu
        self.mainView.alpha = 0.0
        self.swipeUIView.alpha = 0.0
        
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(self.statusBarFrame.height + 3*self.minorMargin + self.backButtonHeight), bottom: Int(2*self.minorMargin+1.5*self.backButtonHeight), left: Int(self.majorMargin), right: Int(self.majorMargin))
        
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 450*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 380*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: self.majorMargin)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant:-self.majorMargin)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.white
        self.swipeUIView.layer.cornerRadius = 8.0
        var swipeUpGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        swipeUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(BrainBreakerViewController.SwipeMenu(_:)))
        self.swipeUIView.addGestureRecognizer(swipeUpGesture)
        
        self.swipeUIView.addSubview(self.swipeMenuTopBar)
        self.swipeMenuTopBar.translatesAutoresizingMaskIntoConstraints = false
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10*self.heightRatio)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 10*self.widthRatio)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -10*self.widthRatio)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = String(format: "%02d", self.countMinutes) + " : " + String(format: "%02d", self.countSeconds)
        self.timeLabel.setConstraintsToSuperview(0, bottom: Int(30*self.heightRatio), left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(18))
        self.timeLabel.textAlignment = NSTextAlignment.center
        self.timeLabel.textColor = UIColor.red
        self.timeLabel.isUserInteractionEnabled = true
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(Int(30*self.heightRatio), bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Tap for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(14))
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.isUserInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.passageView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.passageView.translatesAutoresizingMaskIntoConstraints = false
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        let qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 90*self.heightRatio)
        self.mainView.addConstraint(qViewHeight)
        //Set passageView topMenu
        let layer1:UIView = UIView()
        let layer2:UIView = UIView()
        self.passageView.addSubview(layer1)
        self.passageView.addSubview(layer2)
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer2.translatesAutoresizingMaskIntoConstraints = false
        let layer1top:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let layer1left:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let layer1right:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let layer1height:NSLayoutConstraint = NSLayoutConstraint(item: layer1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 20*self.heightRatio)
        self.passageView.addConstraints([layer1left,layer1right,layer1top])
        layer1.addConstraint(layer1height)
        let layer2top:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 5*self.heightRatio)
        let layer2left:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let layer2right:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.passageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let layer2height:NSLayoutConstraint = NSLayoutConstraint(item: layer2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 30*self.heightRatio)
        self.passageView.addConstraints([layer2left,layer2right,layer2top])
        layer2.addConstraint(layer2height)
        layer1.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        layer2.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        layer1.layer.cornerRadius = 8.0
        let passageText:UILabel = UILabel()
        layer2.addSubview(passageText)
        passageText.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        passageText.textColor = UIColor.white
        passageText.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(16))
        passageText.textAlignment = NSTextAlignment.center
        passageText.text = "QUESTION"
        self.passageView.addSubview(self.passageLabel)
        self.passageLabel.setConstraintsToSuperview(Int(50*self.heightRatio), bottom: Int(40*self.heightRatio), left: Int(40*self.widthRatio), right: Int(40*self.widthRatio))
        self.passageLabel.textColor = UIColor.black
        self.passageView.backgroundColor = UIColor.white
        self.passageLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(16))
        self.passageLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.passageView.layer.cornerRadius = 10.0
        self.passageLabel.textAlignment = NSTextAlignment.justified
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: 0, left: Int(15*self.widthRatio), right: Int(15*self.widthRatio))
        self.questionLabel.textColor = UIColor.white
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(17))
        self.questionLabel.textAlignment = NSTextAlignment.center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.questionView.layer.cornerRadius = 8.0
        let passageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100*self.heightRatio)
        let passageViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let passageViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let passageViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -15)
        self.mainView.addConstraints([passageViewTop,passageViewRight,passageViewLeft,passageViewBottom])
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.submitButton.textColor = UIColor.white
        self.submitButton.textAlignment = NSTextAlignment.center
        self.submitButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.submitButton.text = "Submit Answer"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 380*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 50*self.heightRatio)
        nextUIView.addConstraint(heightLabelConstraint)
        nextUIView.addSubview(self.submitButton)
        self.submitButton.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BrainBreakerViewController.nextQuestion(_:)))
        tapGestureNext.numberOfTapsRequired = 1
        nextUIView.addGestureRecognizer(tapGestureNext)
        
        //Set answersArray
      for _:Int in 0...self.totalNumberOfQuestions {
            let fixedNumber:Int = 20
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        let newQuestion:verbalQuestion = verbalQuestion()
        //Assign values to the newQuestion
        newQuestion.questionType = self.questionType
        newQuestion.passage = self.passage
        newQuestion.question = self.question
        newQuestion.answers = self.answers
        newQuestion.correctAnswer = self.correctAnswer
        newQuestion.explanation = self.explanation
        self.quizzArray.append(newQuestion)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
    }
    
    func backHome(_ sender: UITapGestureRecognizer) {

        let alertMessage:String = "Are you sure you want to return home?"
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:#selector(BrainBreakerViewController.goBack))
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

        self.AdBeforeClosing = true
        if self.interstitialAd.isReady && self.membershipType == "Free" {
            self.interstitialAd.present(fromRootViewController: self)
        } else {
            self.timeTimer.invalidate()
            self.timer.invalidate()
            self.performSegue(withIdentifier: "backHomeSegue", sender: nil)
            print("Ad wasn't ready")
        }
        
    }
    
    func ShowHelpScreen(_ sender:UITapGestureRecognizer) {

        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 0.0
            self.helpMenu.alpha = 1.0
            self.helpButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.HideHelpScreen(_:)), for: UIControlEvents.touchUpInside)
            self.helpButton.setTitleColor(UIColor.white, for: UIControlState())
            self.helpButton.backgroundColor = UIColor.turquoiseColor()
            self.nextButton.setTitle("FIND US ON FACEBOOK", for: UIControlState())
            self.nextButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), for: UIControlEvents.touchUpInside)
            
            }, completion: nil)
        
    }
    
    func HideHelpScreen(_ sender:UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 1.0
            self.helpMenu.alpha = 0.0
            self.helpButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.helpButton.addTarget(self, action: #selector(BrainBreakerViewController.ShowHelpScreen(_:)), for: UIControlEvents.touchUpInside)
            self.helpButton.setTitleColor(UIColor.turquoiseColor(), for: UIControlState())
            self.helpButton.backgroundColor = UIColor.clear
            //self.nextButton.setTitle("RETURN HOME", forState: UIControlState.Normal)
            
            //let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BrainBreakerViewController.StartTest(_:)))
            //self.nextButton.addGestureRecognizer(tapGesture)
            self.nextButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            if (self.attemptsRemaining > 0) {
                
                self.nextButton.setTitle("START", for: UIControlState())
                self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.StartTest(_:)), for: UIControlEvents.touchUpInside)
                
            }else{
                
                self.nextButton.setTitle("RETURN HOME", for: UIControlState())
                self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBack), for: UIControlEvents.touchUpInside)
                
            }
            
            }, completion: nil)
        
    }
    
    func StartTest(_ sender:UITapGestureRecognizer) {

        let alertMessage:String = "Are you ready?"
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:#selector(BrainBreakerViewController.setUpTest))
        backAlert.showTitle(
            "Start the Challenge", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .Success, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
            colorStyle: 0x22B573,//0x526B7B,//0xD0021B - RED
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    func setUpTest() {
        
        if (self.attemptsRemaining > 0) {
            
            self.attemptsRemaining -= 1
            self.defaults.set(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
            
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                self.testStarted = true
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BrainBreakerViewController.updateTimer), userInfo: nil, repeats: true)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.welcomeMenu.alpha = 0.0
                self.helpMenu.alpha = 0.0
                self.helpButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                self.helpButton.alpha = 0.0
                self.nextButton.alpha = 0.0
                self.mainView.alpha = 1.0
                self.swipeUIView.alpha = 1.0
                
                }, completion: nil)
            
        } else {
            
            var alertMessage:String = String()
            alertMessage = "You have no attempts remaining"
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let backAlert = SCLAlertView(appearance: appearance)
            backAlert.addButton("RETURN HOME", target:self, selector:#selector(BrainBreakerViewController.goBack))
            backAlert.showTitle(
                "Sorry", // Title of view
                subTitle: alertMessage, // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Cancel", // Optional button value, default: ""
                style: .Error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
                colorStyle: 0xD0021B,//0x526B7B,//0xD0021B - RED
                colorTextButton: 0xFFFFFF
            )
        }
        
    }
    
    func SwipeMenu(_ sender: UITapGestureRecognizer) {
     
        UIView.animate(withDuration: 1, animations: {
            if(self.swipeMenuBottomConstraint.constant == 380*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
                self.view.layoutIfNeeded()
                self.descriptionSwipeLabel.text = "Tap here for Question"
                self.mainView.alpha = 0.0
            }
            else if (self.swipeMenuBottomConstraint.constant == 5*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 380*self.heightRatio
                self.view.layoutIfNeeded()
                self.descriptionSwipeLabel.text = "Tap here for Answers"
                self.mainView.alpha = 1.0
            }
            }, completion: nil)
        
    }
    
    func displayQuestion(_ arrayOfQuestions:[verbalQuestion], indexQuestion:Int) {
        
        self.passageLabel.text = self.quizzArray[indexQuestion].passage
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answers
        let buttonHeight:Int = Int(50*self.heightRatio)
        
      for i:Int in 0..<arrayAnswers.count {
            let answerUIButton:UIView = UIView()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UIButton = UIButton()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.answerView.addSubview(answerUIButton)
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.tag = i
            answerNumber.setTitle(String(i+1), for: UIControlState())
            answerNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            answerNumber.setTitleColor(UIColor.white, for: UIControlState())
            answerNumber.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.text = String(arrayAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.white
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).cgColor
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.answerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(i)*(CGFloat(buttonHeight)+10*self.heightRatio))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.answerView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.answerView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
            self.answerView.addConstraints([topMargin,rightMargin,leftMargin])
            
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraint(heightConstraint)
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 50*self.widthRatio)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: answerUIButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BrainBreakerViewController.answerIsSelected(_:)))
            answerUIButton.addGestureRecognizer(tapGesture)
        }
    }
    
    func answerIsSelected(_ gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            for singleView in self.answerView.subviews {
                for labelView1 in singleView.subviews {
                    if let labelsView = labelView1 as? UILabel {
                        labelsView.backgroundColor = UIColor.white
                        labelsView.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                    }
                }
            }
            UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                for labels in actualButton.subviews {
                    if let labelView = labels as? UILabel {
                        labelView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                        labelView.textColor = UIColor.white
                    }
                    if let btnView = labels as? UIButton {
                        self.selectedAnswers[self.displayedQuestionIndex] = Int(btnView.tag)
                    }
                }
                }, completion: nil)
        }
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=21
            }
            self.nextQuestion(UITapGestureRecognizer(target: self, action: #selector(BrainBreakerViewController.nextQuestion(_:))))
            self.timeTimer.invalidate()
        }
        else {
            if (self.countSeconds-1<0) {
                if (self.countMinutes+self.countSeconds==0) {
                    self.timeTimer.invalidate()
                }
                else {
                    self.countMinutes -= 1
                    self.countSeconds = 59
                }
            }
            else {
                self.countSeconds -= 1
            }
            let newMin:String = String(format: "%02d", self.countMinutes)
            let newSec:String = String(format: "%02d", self.countSeconds)
            let newLabel:String = "\(newMin) : \(newSec)"
            self.timeLabel.text = newLabel
            if (self.countMinutes==0 && self.countSeconds==0) {
                self.testEnded = true
            }
        }
    }
    
    func feedbackScreen() {
        
        self.timeTimer.invalidate()
        self.timer.invalidate()
        
        UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.welcomeMenu.alpha = 1.0
            self.helpMenu.alpha = 0.0
            self.helpButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.helpButton.alpha = 0.0
            self.nextButton.alpha = 1.0
            self.mainView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.frameTop.alpha = 1.0
            self.frameMid.alpha = 1.0
            self.frameBottom.alpha = 0.0
            
        }, completion: nil)
        
        self.nextButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
        self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), for: UIControlEvents.touchUpInside)
        self.nextButton.setTitle("RETURN HOME", for: UIControlState())
        
        for view in self.frameMid.subviews {
            view.removeFromSuperview()
        }
        let attemptsLabel:UILabel =  UILabel()
        self.frameMid.addSubview(attemptsLabel)
        attemptsLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        attemptsLabel.textAlignment = NSTextAlignment.center
        attemptsLabel.textColor = UIColor.turquoiseColor()
        attemptsLabel.numberOfLines = 0
        var feedbackDescription:String = "Error - No feedback available"
        
        if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
        
            feedbackDescription = "Well done, you are now in with a chance of winning the Brain Breaker prize! The winner(s) will be announced on our social media pages and we will be in touch by email."
        
        } else if (self.membershipType == "Premium" && self.attemptsRemaining > 1){
        
            feedbackDescription = "Unlucky, please try again to be in with a chance of winning a great prize!\n\nAs a premium user, you have \(self.attemptsRemaining) lives remaining."
        
        } else if (self.membershipType == "Premium" && self.attemptsRemaining == 1){
            
            feedbackDescription = "Unlucky, please try again to be in with a chance of winning a great prize!\n\nAs a premium user, you have \(self.attemptsRemaining) life remaining."
            
        } else if (self.membershipType == "Premium" && self.attemptsRemaining == 0){
            
            feedbackDescription = "Unlucky, there will always be another chance to win when the next Brain Breaker is released"
            
        } else {
            
            feedbackDescription = "Unlucky, there will always be another chance to win when the next Brain Breaker is released\n\nJust to let you know, if you sign up for premium membership, you will be granted 3 fresh attempts."
        }

        attemptsLabel.text = feedbackDescription
        
        for view in self.frameTop.subviews {
            view.removeFromSuperview()
        }
        let resultsLabel:UILabel =  UILabel()
        self.frameTop.addSubview(resultsLabel)
        resultsLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        resultsLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        resultsLabel.textAlignment = NSTextAlignment.center
        resultsLabel.textColor = UIColor.turquoiseColor()
        resultsLabel.numberOfLines = 0
        var resultsDescription:String = "Error - No results available"
        
        if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
            
            resultsDescription = "Correct Answer!"
            
        } else {
            
            resultsDescription = "Wrong Answer!"
        }
        
        resultsLabel.text = resultsDescription
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Call tutoNextPage
        let dateBB = Date().addingTimeInterval(0)
        self.timer = Timer(fireAt: dateBB, interval: 1, target: self, selector: #selector(BrainBreakerViewController.brainBreakerTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
        
        if self.brainBreakerAlreadySolved == true {
            
            for view in self.frameMid.subviews {
                view.removeFromSuperview()
            }

            let livesUIView:UIView = UIView()
            self.frameMid.addSubview(livesUIView)
            livesUIView.setConstraintsToSuperview(15, bottom: Int(self.flexibleHeight)/2-40, left: 0, right: 0)
            
            let Image1:UIImageView =  UIImageView()
            self.frameMid.addSubview(Image1)
            Image1.translatesAutoresizingMaskIntoConstraints = false
            let Image1CenterX:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let Image1Top:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: livesUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            self.frameMid.addConstraints([Image1CenterX,Image1Top])
            let Image1Width:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
            let Image1Height:NSLayoutConstraint = NSLayoutConstraint(item: Image1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.backButtonHeight/1.3)
            Image1.addConstraints([Image1Width,Image1Height])
            Image1.clipsToBounds = true
            Image1.image = UIImage(named: "tickSelected")
            
            let Label1:UILabel =  UILabel()
            self.frameMid.addSubview(Label1)
            Label1.setConstraintsToSuperview(Int(self.flexibleHeight)/2-10, bottom: Int(self.flexibleHeight)/2-10, left: 0, right: 0)
            Label1.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            Label1.textAlignment = NSTextAlignment.center
            Label1.textColor = UIColor.turquoiseColor()
            Label1.numberOfLines = 0
            Label1.text = "CONGRATULATIONS"

            let Label2:UILabel =  UILabel()
            self.frameMid.addSubview(Label2)
            Label2.setConstraintsToSuperview(Int(self.flexibleHeight)/2, bottom: Int(self.flexibleHeight)/2-70, left: 0, right: 0)
            Label2.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            Label2.textAlignment = NSTextAlignment.center
            Label2.textColor = UIColor.turquoiseColor()
            Label2.numberOfLines = 0
            Label2.text = "PRIZEWINNER(S) WILL BE ANNOUNCED ON OUR FACEBOOK PAGE (SELECT THE \"?\" BUTTON)"
            
            self.frameMid.bringSubview(toFront: Label1)
            
            self.nextButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), for: UIControlEvents.touchUpInside)
            self.nextButton.setTitle("RETURN HOME", for: UIControlState())
            
            self.frameMid.alpha = 1.0
            
        } else {
            
            self.frameMid.alpha = 1.0
            
        }
        
    }
    
    func brainBreakerTimer(){
        
        startTime = CFAbsoluteTimeGetCurrent()
        let initialTime: Date = defaults.object(forKey: "BrainBreakerExpirationDate") as! Date
        let diff:CFTimeInterval = initialTime.timeIntervalSinceReferenceDate - startTime
        self.time = Int(diff)
        
        if self.time > 0 {
            let newHour:String = String(format: "%02d", (self.time / 3600))
            let newMin:String = String(format: "%02d", (self.time % 3600) / 60)
            let newSec:String = String(format: "%02d", (self.time % 3600) % 60)
            self.newLabel = "\(newHour) : \(newMin) : \(newSec)"
            self.timeRemaining.text = self.newLabel
            
        }else{
            
            self.frameTop.alpha = 0.0
            self.frameMid.alpha = 1.0
            self.frameBottom.alpha = 0.0
            self.nextButton.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            self.nextButton.addTarget(self, action: #selector(BrainBreakerViewController.goBackHome(_:)), for: UIControlEvents.touchUpInside)
            self.nextButton.setTitle("RETURN HOME", for: UIControlState())
            
            for view in self.frameMid.subviews {
                view.removeFromSuperview()
            }
            let attemptsLabel:UILabel =  UILabel()
            self.frameMid.addSubview(attemptsLabel)
            attemptsLabel.setConstraintsToSuperview(Int(self.flexibleHeight)/2-25, bottom: Int(self.flexibleHeight)/2-25, left: 0, right: 0)
            attemptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            attemptsLabel.text = "Current Brain Breaker Ended, New Question Coming Soon!".uppercased()
            attemptsLabel.textAlignment = NSTextAlignment.center
            attemptsLabel.textColor = UIColor.turquoiseColor()
            attemptsLabel.numberOfLines = 0
            
            self.timer.invalidate()
            self.timeTimer.invalidate()
            
        }
        
    }
    
    func goBackHome(_ sender: UIButton) {
        
        if nextButton.currentTitle == "FIND US ON FACEBOOK" {
            
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/breakin2app")!)
        
        }else{
            
            self.goBack()
            
        }

    }
    
    func nextQuestion(_ gesture:UITapGestureRecognizer) {
        
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
            let exitAlert = SCLAlertView()
            exitAlert.showError("No Answer Selected", subTitle: "Please Select An Answer Before Proceeding")
        }
        else {
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    //Upload Results to Parse
                    var nbCorrectAnswers:Int = 0
                    if self.quizzArray[0].correctAnswer == self.selectedAnswers[0] {
                        nbCorrectAnswers += 1
                        self.defaults.set(true, forKey: "brainBreakerAnsweredCorrectly")
                    }
                    SwiftSpinner.show("Saving Results")
                    let currentUser = PFUser.current()!
                    let query = PFQuery(className: PF_USER_CLASS_NAME)
                    let username = currentUser.username
                    query.whereKey(PF_USER_USERNAME, equalTo: username!)
                    query.getFirstObjectInBackground(block: { (userBB: PFObject?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                            let analytics = PFObject(className: PF_BRAINBREAKER_A_CLASS_NAME)
                            analytics[PF_BRAINBREAKER_A_EMAIL] = userBB![PF_USER_EMAILCOPY]
                            analytics[PF_BRAINBREAKER_A_FULLNAME] = userBB![PF_USER_FULLNAME]
                            analytics[PF_BRAINBREAKER_A_Q_NUMBER] = self.questionNumber
                            analytics[PF_BRAINBREAKER_A_ANSWER_CORRECT] = nbCorrectAnswers
                            
                            analytics.saveInBackground(block: { (succeeded: Bool, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    SwiftSpinner.show("Answer Submitted", animated: false).addTapHandler({
                                        SwiftSpinner.hide()
                                        self.resultsUploaded = true
                                        self.feedbackScreen()
                                        }, subtitle: "Tap to proceed to feedback")
                                    
                                } else {
                                    
                                    SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                        
                                        self.attemptsRemaining += 1
                                        self.defaults.set(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
                                        self.goBack()
                                        SwiftSpinner.hide()
                                        
                                        }, subtitle: "You will not lose a life. Tap to return home.")
                                    
                                }
                            } as! PFBooleanResultBlock)
                            
                        }else{
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                self.attemptsRemaining += 1
                                self.defaults.set(self.attemptsRemaining, forKey: "NoOfBrainBreakerLives")
                                self.goBack()
                                SwiftSpinner.hide()
                                
                                }, subtitle: "You will not lose a life. Tap to return home.")
                            
                        }
                        
                    } as! (PFObject?, Error?) -> Void)
                    
                }else {
                    self.feedbackScreen()
                }
            }
                //Continue to the next question
            else {
                UIView.animate(withDuration: 1, animations: {
                    self.swipeMenuBottomConstraint.constant = 380*self.heightRatio
                    self.view.layoutIfNeeded()
                    self.passageView.alpha = 1.0
                    self.descriptionSwipeLabel.text = "Tap for Answers"
                    }, completion: nil)
                self.displayedQuestionIndex += 1
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.submitButton.text = "Complete Test"
                }
                self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AD_ID_BRAINBREAKER)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "kGADSimulatorID" ]
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        self.interstitialAd = createAndLoadInterstitial()
        if self.AdBeforeClosing == true {
            self.timeTimer.invalidate()
            self.timer.invalidate()
            self.performSegue(withIdentifier: "backHomeSegue", sender: nil)
        } else {
            if self.testStarted == false {
                self.testStarted = true
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BrainBreakerViewController.updateTimer), userInfo: nil, repeats: true)
            } else if self.testStarted == true {
                self.testStarted = false
                self.nextQuestion(UITapGestureRecognizer())
            }
        }
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "backHomeSegue" {
      let destinationVC:HomeViewController = segue.destination as! HomeViewController
      destinationVC.segueFromLoginView = false
    }
    
  }
    
}
    
