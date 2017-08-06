//
//  quizzPageViewController.swift
//  Break in2
//
//  Created by Jean-Charles Koch on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit
import Charts
import SCLAlertView
import SwiftSpinner
import GoogleMobileAds
import Firebase
import FirebaseDatabase


class verbalReasoningViewController: QuestionViewController, UIScrollViewDelegate, GADInterstitialDelegate {

//**************************************************************************************
//NUMBER 1: VARIABLES
//**************************************************************************************
    
    // Set up Firebase for read / write access
    var ref: DatabaseReference!
    
    //Ad variables
    var interstitialAd:GADInterstitial!
    var testStarted:Bool = Bool()
    var AdBeforeClosing:Bool = false
    let defaults = UserDefaults.standard
    var membershipType:String = String()
    
    //Declare variables
    let backgroungUIView:UIView = UIView()
    let swipeUIView:UIView = UIView()
    var swipeMenuHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var swipeMenuBottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    let menuBackButton:UIView = UIView()
    let questionMenu:UIView = UIView()
    let questionMenuLabel:UILabel = UILabel()
    let swipeMenuTopBar:UIView = UIView()
    let timeLabel:UILabel = UILabel()
    var timeTimer:Timer = Timer()
    let descriptionSwipeLabel:UILabel = UILabel()
    let mainView:UIView = UIView()
    let questionView:UIView = UIView()
    let passageView:UIView = UIView()
    let passageLabel:UITextView = UITextView()
    var quizzModel:JSONModel = JSONModel()
    var quizzArray:[verbalQuestion] = [verbalQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 14
    let questionLabel:UITextView = UITextView()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let answerView:UIView = UIView()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false

    //Screen size
    var widthRatio:CGFloat = CGFloat()
    var heightRatio:CGFloat = CGFloat()
    
    //Tutorial Views
    var showTutorial:Bool = true
    let tutoView:UIView = UIView()
    let tutoDescription:UILabel = UILabel()
    let tutoDescriptionTitle:UILabel = UILabel()
    let tutoDescriptionText:UILabel = UILabel()
    let tutoDescriptionTitle2:UILabel = UILabel()
    let tutoDescriptionText2:UILabel = UILabel()
    let tutoNextButton:UIButton = UIButton()
    let tutoSkipButton:UIButton = UIButton()
    let logoImageView:UILabel = UILabel()
    let tutorialFingerImageView:UIImageView = UIImageView()
    var tutoPage:Int = 0
    let tutoDescriptionSep:UIView = UIView()
    let tutoDescriptionSep2:UIView = UIView()
    let whiteBGView:UIView = UIView()
    let newTutoButton:UILabel = UILabel()
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.membershipType = defaults.object(forKey: "Membership") as! String
        self.interstitialAd = self.createAndLoadInterstitial()
        self.testStarted = false
        self.questionLabel.isEditable = false
        self.passageLabel.isEditable = false
        
        //Screen size and constraints
        let screenFrame:CGRect = UIScreen.main.bounds
        self.widthRatio = screenFrame.size.width / 414
        self.heightRatio = screenFrame.size.height / 736
        
        //Initialize timer depending on difficulty
        if self.difficulty == "H" {
            self.allowedSeconds = 00
            self.allowedMinutes = 20
        }
        else if self.difficulty == "M" {
            self.allowedSeconds = 00
            self.allowedMinutes = 25
        }
        else {
            self.allowedSeconds = 00
            self.allowedMinutes = 30
        }
        
        //Initialize timer
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Initialize backgroun UIView
        self.view.addSubview(self.backgroungUIView)
        self.backgroungUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "hexagonBGDark")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        self.backgroungUIView.addSubview(imageViewBackground)
        self.backgroungUIView.sendSubview(toBack: imageViewBackground)
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 35*self.heightRatio)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20*self.widthRatio)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "back")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30*self.heightRatio)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.backHome(_:)))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width - 40*self.widthRatio)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 35*self.heightRatio)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20*self.widthRatio)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([questionViewRightMargin,questionViewTopMargin])
        self.view.bringSubview(toFront: self.menuBackButton)
        
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        questionMenuLabel.textAlignment = NSTextAlignment.center
        self.questionMenuLabel.textColor = UIColor.white
        
        //Initialize swipeMenuTopBar UIView
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
        self.descriptionSwipeLabel.text = "Tap here for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(14))
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.isUserInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        
        //Initialize mainView, questionView and passageView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(85*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.passageView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.passageView.translatesAutoresizingMaskIntoConstraints = false
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        self.qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 90*self.heightRatio)
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
        passageText.text = "PASSAGE"
        
        //Design of passageView
        self.passageView.addSubview(self.passageLabel)
        self.passageLabel.setConstraintsToSuperview(Int(50*self.heightRatio), bottom: Int(40*self.heightRatio), left: Int(40*self.widthRatio), right: Int(40*self.widthRatio))
        self.passageLabel.textColor = UIColor.black
        self.passageView.backgroundColor = UIColor.white
        self.passageLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(16))
        self.passageLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.passageView.layer.cornerRadius = 10.0
        self.passageLabel.textAlignment = NSTextAlignment.justified
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: 0, left: Int(15*self.widthRatio), right: Int(15*self.widthRatio))
        self.questionLabel.textColor = UIColor.white
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(17))
        self.questionLabel.textAlignment = NSTextAlignment.center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.questionView.layer.cornerRadius = 8.0
        
        //Update top constraint
        let passageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100*self.heightRatio)
        let passageViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let passageViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let passageViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.passageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([passageViewTop,passageViewRight,passageViewLeft,passageViewBottom])
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.white
        self.nextButton.textAlignment = NSTextAlignment.center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 320*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 50*self.heightRatio)
        nextUIView.addConstraint(heightLabelConstraint)
        nextUIView.addSubview(self.nextButton)
        self.nextButton.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.nextQuestion(_:)))
        tapGestureNext.numberOfTapsRequired = 1
        nextUIView.addGestureRecognizer(tapGestureNext)
        
        //Set answersArray
      for _:Int in 0...self.totalNumberOfQuestions {
            let fixedNumber:Int = 20
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        self.quizzArray = self.quizzModel.selectVerbalReasoning(self.totalNumberOfQuestions+1)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 390*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 320*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20*self.widthRatio)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20*self.widthRatio)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.white
        self.swipeUIView.layer.cornerRadius = 8.0
        var swipeUpGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        swipeUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(verbalReasoningViewController.SwipeMenu(_:)))
        self.swipeUIView.addGestureRecognizer(swipeUpGesture)
        
        if self.showTutorial == true {
            
            //Set constraints to each view
            self.tutoView.tag = 999
            self.view.addSubview(self.tutoView)
            self.tutoView.addSubview(self.tutoNextButton)
            self.tutoView.addSubview(self.tutoSkipButton)
            self.tutoView.addSubview(self.tutoDescription)
            self.tutoView.addSubview(self.logoImageView)
            self.tutoView.addSubview(self.tutorialFingerImageView)
            self.tutoDescription.addSubview(self.tutoDescriptionTitle)
            self.tutoDescription.addSubview(self.tutoDescriptionText)
            self.tutoDescription.addSubview(self.tutoDescriptionTitle2)
            self.tutoDescription.addSubview(self.tutoDescriptionText2)
            self.tutoDescription.addSubview(self.tutoDescriptionSep)
            self.tutoDescriptionSep.backgroundColor = UIColor.white
            self.tutoDescription.addSubview(self.tutoDescriptionSep2)
            self.tutoDescriptionSep2.backgroundColor = UIColor.white
            
            self.tutoView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
            
            self.tutoDescription.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: (300/2-60)*self.heightRatio)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 50*self.widthRatio)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -50*self.widthRatio)
            self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -10*self.heightRatio)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 40*self.widthRatio)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -40*self.widthRatio)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            
            self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: (self.view.frame.width/12)+30*self.heightRatio)
            let tutoSkipButtonCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            self.tutoView.addConstraints([tutoSkipButtonTop,tutoSkipButtonCenterX])
            let tutoSkipButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20*self.heightRatio)
            let tutoSkipButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200*self.widthRatio)
            self.tutoSkipButton.addConstraints([tutoSkipButtonHeight,tutoSkipButtonWidth])
            
            self.tutoDescriptionTitle.setConstraintsToSuperview(0, bottom: Int(285*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep.setConstraintsToSuperview(Int(17*self.heightRatio), bottom: Int(282*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionTitle2.setConstraintsToSuperview(Int(160*self.heightRatio), bottom: Int(125*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep2.setConstraintsToSuperview(Int(177*self.heightRatio), bottom: Int(122*self.heightRatio), left: 0, right: 0)
            
            self.tutoDescriptionText.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionTextTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20*self.heightRatio)
            let tutoDescriptionTextLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let tutoDescriptionTextRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionTextTop,tutoDescriptionTextLeft,tutoDescriptionTextRight])
            let tutoDescriptionText2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 180*self.heightRatio)
            let tutoDescriptionText2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            let tutoDescriptionText2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionText2Top,tutoDescriptionText2Left,tutoDescriptionText2Right])
            
            self.tutoDescriptionText2.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
            let logoImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let logoImageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 25*self.heightRatio)
            let logoImageViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width/12)
            let logoImageViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width-40*self.widthRatio)
            self.logoImageView.addConstraints([logoImageViewHeight, logoImageViewWidth])
            self.tutoView.addConstraints([logoImageViewCenterX, logoImageViewTop])
            
            //Finger ImageView
            self.tutorialFingerImageView.image = UIImage.init(named: "fingbutton")
            self.tutorialFingerImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
            let descriptionImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            let descriptionImageViewCenterY:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.tutoView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -self.view.frame.width/8-100*self.heightRatio)
            let descriptionImageViewHeight:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width/4)
            let descriptionImageViewWidth:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width - 10*self.widthRatio)
            self.tutorialFingerImageView.addConstraints([descriptionImageViewHeight, descriptionImageViewWidth])
            self.tutoView.addConstraints([descriptionImageViewCenterX, descriptionImageViewCenterY])
            
            //Tutorial Title
            let labelString:String = String("VERBAL REASONING")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 7, length: NSString(string: labelString).length-7))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
            self.logoImageView.attributedText = attributedString
            
            //Design
            self.logoImageView.textAlignment = NSTextAlignment.center
            self.tutoView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
            self.tutoDescriptionTitle.textColor = UIColor.white
            self.tutoDescriptionTitle.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.justified
            self.tutoDescriptionTitle.numberOfLines = 0
            self.tutoDescriptionText.textColor = UIColor.white
            self.tutoDescriptionText.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescriptionText.textAlignment = NSTextAlignment.left
            self.tutoDescriptionText.numberOfLines = 0
            self.tutoDescriptionTitle2.textColor = UIColor.white
            self.tutoDescriptionTitle2.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoDescriptionTitle2.textAlignment = NSTextAlignment.justified
            self.tutoDescriptionTitle2.numberOfLines = 0
            self.tutoDescriptionText2.textColor = UIColor.white
            self.tutoDescriptionText2.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescriptionText2.textAlignment = NSTextAlignment.left
            self.tutoDescriptionText2.numberOfLines = 0
            self.tutoNextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            self.tutoNextButton.setTitleColor(UIColor.white, for: UIControlState())
            self.tutoNextButton.setTitle("Continue", for: UIControlState())
            self.tutoNextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoNextButton.titleLabel?.textAlignment = NSTextAlignment.center
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.tutoNext(_:)))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            self.tutoSkipButton.setTitleColor(UIColor.white, for: UIControlState())
            self.tutoSkipButton.setTitle("Skip the Tutorial", for: UIControlState())
            self.tutoSkipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.view.getTextSize(15))
            self.tutoSkipButton.titleLabel?.textAlignment = NSTextAlignment.center
            let tutoSkipButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.tutoSkip(_:)))
            self.tutoSkipButton.addGestureRecognizer(tutoSkipButtonTap)
            
            //Set tutorial text
            self.tutoDescriptionTitle.text = "Test Description:"
            self.tutoDescriptionText.text = "You will be tested on your ability to read a passage and answer related questions in a limited amount of time. You will have \(self.allowedMinutes) minutes to answer up to \(self.totalNumberOfQuestions+1) questions."
            self.tutoDescriptionTitle2.text = "Our Recommendation:"
            self.tutoDescriptionText2.text = "We recommend that you are able to score at least 85% on medium difficulty before taking the actual test."
            self.passageView.alpha = 0.0
            
            //Set Tutorial page
            self.tutoPage = 1
            
        } else {
            //Launch timer
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                self.testStarted = true
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verbalReasoningViewController.updateTimer), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func tutoNext(_ sender:UITapGestureRecognizer) {
        self.tutoPage += 1
        if self.tutoPage==2 {
            self.tutoDescriptionSep2.alpha = 0
            self.tutoDescriptionText2.alpha = 0
            self.tutoDescriptionTitle2.alpha = 0
            self.tutoDescriptionText.textAlignment = NSTextAlignment.center
            self.tutoDescriptionTitle.alpha = 0.0
            self.tutorialFingerImageView.alpha = 0.0
            self.tutoDescriptionText.text = "Remember to only answer based on information that is presented in the passage. Tap the answer menu at the bottom of the screen and select from the options provided.\n\nHave a go on the next page..."
        }
        if self.tutoPage==3 {
            self.tutoSkipButton.alpha = 0.0
            self.tutoDescriptionText.alpha = 0.0
            self.tutoDescriptionSep.alpha = 0.0
            self.view.bringSubview(toFront: self.mainView)
            self.view.bringSubview(toFront: self.swipeUIView)
            self.passageView.alpha = 1.0
            self.nextButton.text = "Continue"
        }
        if self.tutoPage==4 {
            self.SwipeMenu(UITapGestureRecognizer())
            self.passageView.alpha = 0.0
            self.view.bringSubview(toFront: self.tutoView)
            self.nextButton.text = "Next"
            self.tutoSkipButton.alpha = 1.0
            self.tutoDescriptionTitle.alpha = 1.0
            self.tutoDescriptionSep.alpha = 1.0
            self.tutoDescriptionText.alpha = 1.0
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.center
            self.tutoDescriptionTitle.text = "Ready to start?"
            self.tutoDescriptionText.text = "You are now ready to start the test. Practice hard, and remember that both speed AND accuracy in the candidate selection process!"
            self.tutoNextButton.setTitle("Start Test", for: UIControlState())
        }
        if self.tutoPage==5 {
            self.tutoView.alpha = 0
            self.passageView.alpha = 1.0
            self.selectedAnswers[self.displayedQuestionIndex] = 20
            self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            self.showTutorial = false
            if self.interstitialAd.isReady && self.membershipType == "Free" {
                self.interstitialAd.present(fromRootViewController: self)
            } else {
                self.testStarted = true
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verbalReasoningViewController.updateTimer), userInfo: nil, repeats: true)
                print("Ad wasn't ready")
            }
        }
        
    }
    
    func tutoSkip(_ sender:UITapGestureRecognizer) {
        self.passageView.alpha = 1.0
        self.showTutorial = false
        if self.interstitialAd.isReady && self.membershipType == "Free" {
            self.interstitialAd.present(fromRootViewController: self)
        } else {
            self.testStarted = true
            self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verbalReasoningViewController.updateTimer), userInfo: nil, repeats: true)
            print("Ad wasn't ready")
        }
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.tutoView.alpha = 0.0
            }, completion: nil)
    }
    
    //Show Swipe Menu
    func SwipeMenu(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            if(self.swipeMenuBottomConstraint.constant == 320*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
                self.view.layoutIfNeeded()
                self.passageView.alpha = 0.0
                self.descriptionSwipeLabel.text = "Tap here for Question"
            }
            else if (self.swipeMenuBottomConstraint.constant == 5*self.heightRatio) {
                self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
                self.view.layoutIfNeeded()
                self.passageView.alpha = 1.0
                self.descriptionSwipeLabel.text = "Tap here for Answers"
            }
            }, completion: nil)
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=21
            }
            self.nextQuestion(UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.nextQuestion(_:))))
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
    
    func backHome(_ sender:UITapGestureRecognizer) {
        var alertMessage:String = String()
        if (self.isTestComplete==false) {
            alertMessage = "Are you sure you want to return home? All progress will be lost!"
        } else {
            alertMessage = "Are you sure you want to return home?"
        }
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let backAlert = SCLAlertView(appearance: appearance)
        backAlert.addButton("Yes", target:self, selector:#selector(verbalReasoningViewController.goBack))
        backAlert.showTitle(
            "Return to Menu", // Title of view
            subTitle: alertMessage, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Cancel", // Optional button value, default: ""
            style: .error, // Styles - Success, Error, Notice, Warning, Info, Edit, Wait
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
            self.performSegue(withIdentifier: "backHomeSegue", sender: nil)
            print("Ad wasn't ready")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backHomeSegue" {
            self.timeTimer.invalidate()
            let destinationVC:HomeViewController = segue.destination as! HomeViewController
            destinationVC.segueFromLoginView = false
        }
        
    }
    
    func displayQuestion(_ arrayOfQuestions:[verbalQuestion], indexQuestion:Int) {
        
        self.swipeMenuBottomConstraint.constant == 320*self.heightRatio
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.questionMenuLabel.attributedText = attributedString
        self.questionMenuLabel.attributedText = attributedString
        self.passageLabel.text = self.quizzArray[indexQuestion].passage
        
        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        
        // add answers to SwipeUIVIew
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.answerIsSelected(_:)))
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
    
    func nextQuestion(_ gesture:UITapGestureRecognizer) {
        
        //Check if button pressed during tutorial ?
        if self.tutoPage==3 {
                self.tutoNext(UITapGestureRecognizer())
        } else {

        // If no answer is selected, show Alert
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
            let exitAlert = SCLAlertView()
            exitAlert.showError("No Answer Selected", subTitle: "Please select an answer before proceeding")
        }
        else {
            //Else go to next question
            //Go to the feedback screen
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    
                    if self.testStarted == true {
                        if self.interstitialAd.isReady && self.membershipType == "Free" {
                            self.interstitialAd.present(fromRootViewController: self)
                        } else {
                            print("Ad wasn't ready")
                            self.testStarted = false
                            self.nextQuestion(UITapGestureRecognizer())
                        }
                    } else {
                        
                    //Upload Results to Parse
                    var nbCorrectAnswers:Int = 0
                      for i:Int in 0..<self.selectedAnswers.count {
                        if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                            nbCorrectAnswers += 1
                        }
                    }
                    self.scoreRatio = (Float(nbCorrectAnswers) / Float(self.selectedAnswers.count)) * 100
                    //Add: test type (numerical / verbal ...)
                    
                    var timeTaken:Float = Float(60 * self.allowedMinutes + self.allowedSeconds) - Float(60 * self.countMinutes + self.countSeconds)
                    timeTaken = timeTaken/Float(self.selectedAnswers.count)
                    
//**************************************************************************************
//CHECK: FIREBASE
//**************************************************************************************
                        
                        SwiftSpinner.show("Saving Results")
                        
                        self.ref = Database.database().reference()
                        
                        if let currentUser = Auth.auth().currentUser {
                            
                            //create score record
                            self.ref.child(FBASE_VERBREAS_CLASS_NAME).child(currentUser.uid).childByAutoId().setValue(
                                [FBASE_VERBREAS_SCORE: self.scoreRatio,
                                 FBASE_VERBREAS_TIME: timeTaken
                                ])
                            
                            SwiftSpinner.show("Results Saved", animated: false).addTapHandler({
                                SwiftSpinner.hide()
                            }, subtitle: "Tap to proceed to feedback screen")
                            
                            self.resultsUploaded = true
                            self.feedbackScreen()
                            
                        }else{
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                SwiftSpinner.hide()
                                
                            }, subtitle: "Results unsaved, tap to proceed to feedback")
                            
                            self.feedbackScreen()
                            
                        }
                        
                }
                } else {
                    self.feedbackScreen()
                }
            }
                //Continue to the next question
            else {
                UIView.animate(withDuration: 1, animations: {
                    self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
                    self.view.layoutIfNeeded()
                    self.passageView.alpha = 1.0
                    self.descriptionSwipeLabel.text = "Tap here for Answers"
                    }, completion: {(bool) in
                        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
                })
                self.passageLabel.setContentOffset(CGPoint.zero, animated: false)
                self.displayedQuestionIndex += 1
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.nextButton.text = "Complete Test"
                }
            }
        }
        }
    }
    
    func feedbackScreen() {
        //Display feedback screen here
        self.isTestComplete = true
        let buttonHeight:Int = Int(40*self.heightRatio)
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            let labelString:String = String("SCORE: \(round(self.scoreRatio))%")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            if self.scoreRatio<70 {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            else {
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location: 0, length: 6))
            self.questionMenuLabel.attributedText = attributedString

            self.mainView.alpha = 0.0
            self.swipeUIView.alpha = 0.0
            self.feebdackScreen.alpha = 1.0
            self.view.addSubview(self.feebdackScreen)
            self.feebdackScreen.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(20*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
            self.feebdackScreen.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.feebdackScreen.layer.cornerRadius = 8.0
            }, completion: nil)
        
        let topComment:UILabel = UILabel()
        self.feebdackScreen.addSubview(topComment)
        topComment.translatesAutoresizingMaskIntoConstraints = false
        let topMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10*self.heightRatio)
        let leftMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20*self.widthRatio)
        self.feebdackScreen.addConstraints([topMg,leftMg])
        
        let widthCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
        let heightCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: 15*self.heightRatio)
        topComment.addConstraints([heightCt,widthCt])
        topComment.text = "Select Question For Feedback"
        topComment.numberOfLines = 0
        topComment.textAlignment = NSTextAlignment.center
        topComment.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        topComment.textColor = UIColor.white
        
      for i:Int in 0..<self.selectedAnswers.count {
            let answerUIButton:UIButton = UIButton()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UILabel = UILabel()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.feebdackScreen.addSubview(answerUIButton)
            answerUIButton.tag = i
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.text = String(i+1)
            answerNumber.textAlignment = NSTextAlignment.center
            answerNumber.textColor = UIColor.white
            answerUILabel.textAlignment = NSTextAlignment.center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.white
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).cgColor
            
            if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                answerUILabel.text = "Correct Answer"
                answerNumber.backgroundColor = UIColor.green
            }
            else {
                answerUILabel.text = "Wrong Answer"
                answerNumber.backgroundColor = UIColor.red
            }
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(i*(buttonHeight+Int(10*self.heightRatio)) + 40))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20*self.widthRatio)
            self.feebdackScreen.addConstraints([topMargin,leftMargin])
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraints([heightConstraint,widthConstraint])
            
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verbalReasoningViewController.displayAnswerWithFeedback(_:)))
            answerUIButton.addGestureRecognizer(tapGesture)
        self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
        self.passageLabel.setContentOffset(CGPoint.zero, animated: false)
            
        }
        
        self.feebdackScreen.isScrollEnabled = true
        let totalHeight:CGFloat = CGFloat(self.selectedAnswers.count+1) * (CGFloat(buttonHeight) + 10*self.heightRatio)
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40*self.widthRatio), height: totalHeight+30)
        
    }
    
    func displayAnswerWithFeedback(_ gesture:UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.mainView.alpha = 1.0
            self.swipeUIView.alpha = 1.0
            self.feebdackScreen.alpha = 0.0
            self.questionMenuLabel.textColor = UIColor.black
            
            var questionFeedback:Int = Int()
            let buttonTapped:UIView? = gesture.view
            if let actualButton = buttonTapped {
                questionFeedback = actualButton.tag
            }
            self.displayQuestion(self.quizzArray, indexQuestion: questionFeedback)
            
            for answerSubView in self.answerView.subviews {
                answerSubView.removeFromSuperview()
            }
            
            self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
                self.passageView.alpha = 1.0
                self.descriptionSwipeLabel.text = "Tap here for Explanation"
                self.nextButton.text = "Return to Results"
                }, completion: nil)
            
            let feedbackLabel:UITextView = UITextView()
            self.answerView.addSubview(feedbackLabel)
            
            feedbackLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: Int(10*self.heightRatio), left: Int(30*self.widthRatio), right: Int(30*self.widthRatio))
            feedbackLabel.text = self.quizzArray[questionFeedback].explanation
            feedbackLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(14))
            
            if self.quizzArray[questionFeedback].correctAnswer == self.selectedAnswers[questionFeedback] {
                self.timeLabel.text = "Correct Answer"
                self.timeLabel.textColor = UIColor.green
                feedbackLabel.textColor = UIColor.green
            }
            else {
                self.timeLabel.text = "Wrong Answer"
                self.timeLabel.textColor = UIColor.red
                feedbackLabel.textColor = UIColor.red
            }
            
            }, completion: nil)
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: AD_ID_VERBAL)
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
            self.performSegue(withIdentifier: "backHomeSegue", sender: nil)
        } else {
            if self.testStarted == false {
                self.testStarted = true
                self.timeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verbalReasoningViewController.updateTimer), userInfo: nil, repeats: true)
            } else if self.testStarted == true {
                self.testStarted = false
                self.nextQuestion(UITapGestureRecognizer())
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
