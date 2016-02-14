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
import Parse
import SwiftSpinner

class numericalReasoningViewController: QuestionViewController, UIScrollViewDelegate {
    
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
    var timeTimer:NSTimer = NSTimer()
    let descriptionSwipeLabel:UILabel = UILabel()
    let mainView:UIView = UIView()
    let questionView:UIView = UIView()
    let graphView:UIView = UIView()
    var quizzModel:JSONModel = JSONModel()
    var quizzArray:[numericalQuestion] = [numericalQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 19
    let questionLabel:UITextView = UITextView()
    var allowedSeconds:Int = Int()
    var allowedMinutes:Int = Int()
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let answerView:UIView = UIView()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    var graphTitle:UILabel = UILabel()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false
    var graphContent:UIView = UIView()
    
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
      
        //Screen size and constraints
        let screenFrame:CGRect = UIScreen.mainScreen().bounds
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
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "homeBG")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroungUIView.addSubview(imageViewBackground)
        self.backgroungUIView.sendSubviewToBack(imageViewBackground)
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "back")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25*self.heightRatio)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 40*self.widthRatio)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35*self.heightRatio)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*self.widthRatio)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([questionViewRightMargin,questionViewTopMargin])
        self.view.bringSubviewToFront(self.menuBackButton)
        
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        questionMenuLabel.textAlignment = NSTextAlignment.Center
        self.questionMenuLabel.textColor = UIColor.whiteColor()
        
        //Initialize swipeMenuTopBar UIView
        self.swipeUIView.addSubview(self.swipeMenuTopBar)
        self.swipeMenuTopBar.translatesAutoresizingMaskIntoConstraints = false
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10*self.heightRatio)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10*self.widthRatio)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10*self.widthRatio)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = String(format: "%02d", self.countMinutes) + " : " + String(format: "%02d", self.countSeconds)
        self.timeLabel.setConstraintsToSuperview(0, bottom: Int(30*self.heightRatio), left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: self.view.getTextSize(18))
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(Int(30*self.heightRatio), bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Swipe up for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: self.view.getTextSize(14))
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.Center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(Int(80*self.heightRatio), bottom: Int(70*self.heightRatio), left: 0, right: 0)
        
        //Initialize mainView, questionView and GraphView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(Int(75*self.heightRatio), bottom: Int(85*self.heightRatio), left: Int(20*self.widthRatio), right: Int(20*self.widthRatio))
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(self.graphContent)
        self.graphContent.addSubview(self.graphView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        self.graphContent.translatesAutoresizingMaskIntoConstraints = false
        
        let graphContentTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphContent, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 90*self.heightRatio)
        let graphContentRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphContent, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphContentLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphContent, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let graphContentBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.graphContent, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([graphContentTop,graphContentRight,graphContentLeft,graphContentBottom])
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        self.qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75*self.heightRatio)
        self.mainView.addConstraint(qViewHeight)
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(round(self.questionView.frame.height-self.questionLabel.frame.height)/2), bottom: 0, left: Int(5*self.widthRatio), right: Int(5*self.widthRatio))
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Light",size: self.view.getTextSize(16))
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.questionView.layer.cornerRadius = 8.0
        self.graphContent.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.graphContent.layer.cornerRadius = 8.0
        
        self.graphContent.addSubview(self.graphTitle)
        self.graphTitle.translatesAutoresizingMaskIntoConstraints = false
        self.graphTitle.numberOfLines = 0
        let graphTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5*self.heightRatio)
        let graphTitleRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10*self.widthRatio)
        let graphTitleLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        self.graphContent.addConstraints([graphTitleTop,graphTitleRight,graphTitleLeft])
        let graphTitleHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35*self.heightRatio)
        self.graphTitle.addConstraint(graphTitleHeight)
        self.graphTitle.textAlignment = NSTextAlignment.Left
        self.graphTitle.font = UIFont(name: "HelveticaNeue-Italic", size: self.view.getTextSize(14))
        self.graphTitle.textColor = UIColor.whiteColor()
        
        //Update top constraint
        let graphViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50*self.heightRatio)
        let graphViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let graphViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphContent, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.graphContent.addConstraints([graphViewTop,graphViewRight,graphViewLeft,graphViewBottom])
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 325*self.heightRatio)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20*self.widthRatio))
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20*self.widthRatio))
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 45*self.heightRatio)
        nextUIView.addConstraint(heightLabelConstraint)
        nextUIView.addSubview(self.nextButton)
        self.nextButton.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let tapGestureNext:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("nextQuestion:"))
        tapGestureNext.numberOfTapsRequired = 1
        nextUIView.addGestureRecognizer(tapGestureNext)
        
        //Set answersArray
        var answerIndex:Int = 0
        for answerIndex=0;answerIndex<=self.totalNumberOfQuestions;answerIndex++ {
            let fixedNumber:Int = 20
            self.selectedAnswers.append(fixedNumber)
        }
        
        //Display questions
        self.displayedQuestionIndex = 0
        self.quizzArray = self.quizzModel.selectNumericalReasoning(self.totalNumberOfQuestions+1)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 390*self.heightRatio)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 320*self.heightRatio)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20*self.widthRatio)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.whiteColor()
        self.swipeUIView.layer.cornerRadius = 8.0
        var swipeUpGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
        var swipeDownGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeUpGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("showSwipeMenu:"))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        self.swipeUIView.addGestureRecognizer(swipeUpGesture)
        swipeDownGesture = UISwipeGestureRecognizer.init(target: self, action: Selector("hideSwipeMenu:"))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.swipeUIView.addGestureRecognizer(swipeDownGesture)
        
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
            self.tutoDescriptionSep.backgroundColor = UIColor.whiteColor()
            self.tutoDescription.addSubview(self.tutoDescriptionSep2)
            self.tutoDescriptionSep2.backgroundColor = UIColor.whiteColor()
            
            self.tutoView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
            
            self.tutoDescription.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionCenterY:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: (300/2-60)*self.heightRatio)
            let tutoDescriptionLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let tutoDescriptionRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -50*self.widthRatio)
            self.tutoView.addConstraints([tutoDescriptionCenterY,tutoDescriptionLeft,tutoDescriptionRight])
            let tutoDescriptionHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescription, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300*self.heightRatio)
            self.tutoDescription.addConstraint(tutoDescriptionHeight)
            
            self.tutoNextButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoNextButtonBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -10*self.heightRatio)
            let tutoNextButtonLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 40*self.widthRatio)
            let tutoNextButtonRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -40*self.widthRatio)
            self.tutoView.addConstraints([tutoNextButtonBottom,tutoNextButtonLeft,tutoNextButtonRight])
            let tutoNextButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoNextButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.heightRatio)
            self.tutoNextButton.addConstraint(tutoNextButtonHeight)
            
            self.tutoSkipButton.translatesAutoresizingMaskIntoConstraints = false
            let tutoSkipButtonTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: (25+(self.view.frame.width/12)+5)*self.heightRatio)
            let tutoSkipButtonCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.tutoView.addConstraints([tutoSkipButtonTop,tutoSkipButtonCenterX])
            let tutoSkipButtonHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20*self.heightRatio)
            let tutoSkipButtonWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoSkipButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200*self.widthRatio)
            self.tutoSkipButton.addConstraints([tutoSkipButtonHeight,tutoSkipButtonWidth])
            
            self.tutoDescriptionTitle.setConstraintsToSuperview(0, bottom: Int(285*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep.setConstraintsToSuperview(Int(17*self.heightRatio), bottom: Int(282*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionTitle2.setConstraintsToSuperview(Int(160*self.heightRatio), bottom: Int(125*self.heightRatio), left: 0, right: 0)
            self.tutoDescriptionSep2.setConstraintsToSuperview(Int(177*self.heightRatio), bottom: Int(122*self.heightRatio), left: 0, right: 0)
            
            self.tutoDescriptionText.translatesAutoresizingMaskIntoConstraints = false
            let tutoDescriptionTextTop:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20*self.heightRatio)
            let tutoDescriptionTextLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionTextRight:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionTextTop,tutoDescriptionTextLeft,tutoDescriptionTextRight])
            let tutoDescriptionText2Top:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 180*self.heightRatio)
            let tutoDescriptionText2Left:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let tutoDescriptionText2Right:NSLayoutConstraint = NSLayoutConstraint(item: self.tutoDescriptionText2, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoDescription, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.tutoDescription.addConstraints([tutoDescriptionText2Top,tutoDescriptionText2Left,tutoDescriptionText2Right])
            
            self.tutoDescriptionText2.translatesAutoresizingMaskIntoConstraints = false
            self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
            let logoImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let logoImageViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25*self.heightRatio)
            let logoImageViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.view.frame.width/12)*self.heightRatio)
            let logoImageViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (self.view.frame.width-40)*self.widthRatio)
            self.logoImageView.addConstraints([logoImageViewHeight, logoImageViewWidth])
            self.tutoView.addConstraints([logoImageViewCenterX, logoImageViewTop])
            
            //Finger ImageView
            self.tutorialFingerImageView.image = UIImage.init(named: "fingbutton")
            self.tutorialFingerImageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.tutorialFingerImageView.translatesAutoresizingMaskIntoConstraints = false
            let descriptionImageViewCenterX:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            let descriptionImageViewCenterY:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.tutoView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -self.view.frame.width/8-100*self.heightRatio)
            let descriptionImageViewHeight:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/4)
            let descriptionImageViewWidth:NSLayoutConstraint = NSLayoutConstraint.init(item: self.tutorialFingerImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 10*self.widthRatio)
            self.tutorialFingerImageView.addConstraints([descriptionImageViewHeight, descriptionImageViewWidth])
            self.tutoView.addConstraints([descriptionImageViewCenterX, descriptionImageViewCenterY])
            
            //Tutorial Title
            let labelString:String = String("NUMERICAL TEST")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 10, length: NSString(string: labelString).length-10))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
            self.logoImageView.attributedText = attributedString
            
            //Design
            self.logoImageView.textAlignment = NSTextAlignment.Center
            self.tutoView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
            self.tutoDescriptionTitle.textColor = UIColor.whiteColor()
            self.tutoDescriptionTitle.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.Justified
            self.tutoDescriptionTitle.numberOfLines = 0
            self.tutoDescriptionText.textColor = UIColor.whiteColor()
            self.tutoDescriptionText.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescriptionText.textAlignment = NSTextAlignment.Left
            self.tutoDescriptionText.numberOfLines = 0
            self.tutoDescriptionTitle2.textColor = UIColor.whiteColor()
            self.tutoDescriptionTitle2.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoDescriptionTitle2.textAlignment = NSTextAlignment.Justified
            self.tutoDescriptionTitle2.numberOfLines = 0
            self.tutoDescriptionText2.textColor = UIColor.whiteColor()
            self.tutoDescriptionText2.font = UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(15))
            self.tutoDescriptionText2.textAlignment = NSTextAlignment.Left
            self.tutoDescriptionText2.numberOfLines = 0
            self.tutoNextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            self.tutoNextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.tutoNextButton.setTitle("Continue", forState: .Normal)
            self.tutoNextButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            self.tutoNextButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoNextButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tutoNext:"))
            self.tutoNextButton.addGestureRecognizer(tutoNextButtonTap)
            self.tutoSkipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.tutoSkipButton.setTitle("Skip the Tutorial", forState: .Normal)
            self.tutoSkipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: self.view.getTextSize(15))
            self.tutoSkipButton.titleLabel?.textAlignment = NSTextAlignment.Center
            let tutoSkipButtonTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tutoSkip:"))
            self.tutoSkipButton.addGestureRecognizer(tutoSkipButtonTap)
            
            //Set tutorial text
            self.tutoDescriptionTitle.text = "Test Description:"
            self.tutoDescriptionText.text = "You will be tested on your ability to read and understand numerical charts and tables in a limited amount of time. You will have \(self.allowedMinutes) minutes to answer up to \(self.totalNumberOfQuestions+1) questions."
            self.tutoDescriptionTitle2.text = "Our Recommendation:"
            self.tutoDescriptionText2.text = "We recommend that you achieve a score of at least 85% on the Hard difficulty level before taking the real test."
            self.graphView.alpha = 0.0
            
            //Set Tutorial page
            self.tutoPage = 1
            
        } else {
            //Launch timer
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        }
        
    }
    
    func tutoNext(sender:UITapGestureRecognizer) {
        self.tutoPage++
        if self.tutoPage==2 {
            self.tutoDescriptionSep2.alpha = 0
            self.tutoDescriptionText2.alpha = 0
            self.tutoDescriptionTitle2.alpha = 0
            self.tutoDescriptionText.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.alpha = 0.0
            self.tutorialFingerImageView.alpha = 0.0
            self.tutoDescriptionText.text = "A graph will appear with a question at the top of the screen. To answer it, swipe up the answer menu at the bottom of the screen and select an answer."
        }
        if self.tutoPage==3 {
            self.tutoSkipButton.alpha = 0.0
            self.tutoDescriptionText.alpha = 0.0
            self.tutoDescriptionSep.alpha = 0.0
            self.view.bringSubviewToFront(self.mainView)
            self.view.bringSubviewToFront(self.swipeUIView)
            self.graphView.alpha = 1.0
            self.nextButton.text = "Continue"
        }
        if self.tutoPage==4 {
            self.hideSwipeMenu(UISwipeGestureRecognizer())
            self.graphView.alpha = 0.0
            self.view.bringSubviewToFront(self.tutoView)
            self.nextButton.text = "Next"
            self.tutoSkipButton.alpha = 1.0
            self.tutoDescriptionTitle.alpha = 1.0
            self.tutoDescriptionSep.alpha = 1.0
            self.tutoDescriptionText.alpha = 1.0
            self.tutoDescriptionTitle.textAlignment = NSTextAlignment.Center
            self.tutoDescriptionTitle.text = "Ready to Start ?"
            self.tutoDescriptionText.text = "You are now ready to Start the test. Practice hard, and remember: both your final score and speed matter when it comes to selecting candidates !"
            self.tutoNextButton.setTitle("Start Test", forState: .Normal)
        }
        if self.tutoPage==5 {
            self.tutoView.alpha = 0.0
            self.graphView.alpha = 1.0
            self.selectedAnswers[self.displayedQuestionIndex] = 20
            self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            self.showTutorial = false
            self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        }
        
    }
    
    func tutoSkip(sender:UITapGestureRecognizer) {
        self.graphView.alpha = 1.0
        self.showTutorial = false
        self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.tutoView.alpha = 0.0
            }, completion: nil)
    }
    
    //Show Swipe Menu
    func showSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
            self.view.layoutIfNeeded()
            self.graphView.alpha = 0.0
            self.descriptionSwipeLabel.text = "Swipe down for Question"
            self.graphTitle.alpha = 0.0
            self.graphContent.alpha = 0.0
            }, completion: nil)
    }
    
    //Hie Swipe Menu
    func hideSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
            self.view.layoutIfNeeded()
            self.graphView.alpha = 1.0
            self.descriptionSwipeLabel.text = "Swipe up for Answers"
            self.graphTitle.alpha = 1.0
            self.graphContent.alpha = 1.0
            }, completion: nil)
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=21
            }
            self.timeTimer.invalidate()
            self.nextQuestion(UITapGestureRecognizer(target: self, action: Selector("nextQuestion:")))
        }
        else {
        if (self.countSeconds-1<0) {
            if (self.countMinutes+self.countSeconds==0) {
                self.timeTimer.invalidate()
            }
            else {
                self.countMinutes--
                self.countSeconds = 59
            }
        }
        else {
            self.countSeconds--
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
    
    func backHome(sender:UITapGestureRecognizer) {
        var alertMessage:String = String()
        if (self.isTestComplete==false) {
            alertMessage = "Are you sure you want to return home? All progress will be lost!"
        } else {
            alertMessage = "Are you sure you want to return home?"
        }
        
        let backAlert = SCLAlertView()
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
        backAlert.showCloseButton = false
        
    }
    
    func goBack(){
        self.performSegueWithIdentifier("backHomeSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "backHomeSegue" {
            self.timeTimer.invalidate()
            let destinationVC:HomeViewController = segue.destinationViewController as! HomeViewController
            destinationVC.segueFromLoginView = false
        }
        
    }
    
    func displayQuestion(arrayOfQuestions:[numericalQuestion], indexQuestion:Int) {
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.questionMenuLabel.attributedText = attributedString
        self.questionMenuLabel.attributedText = attributedString

        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].question
        self.questionLabel.text = questionText
        
        // add answers to SwipeUIVIew
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answers
        let buttonHeight:Int = Int(45*self.heightRatio)
        var i:Int = 0
        
        for i=0; i<arrayAnswers.count;i++ {
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
            answerNumber.setTitle(String(i+1), forState: .Normal)
            answerNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            answerNumber.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            answerNumber.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.text = String(arrayAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.whiteColor()
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+4)))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20)*self.widthRatio)
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20)*self.widthRatio)
            self.answerView.addConstraints([topMargin,rightMargin,leftMargin])
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraint(heightConstraint)
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
            answerUIButton.addGestureRecognizer(tapGesture)
            
            //Update graph
            for existingView in self.graphView.subviews {
                existingView.removeFromSuperview()
            }
            let newChartObject = self.createChartObject(indexQuestion)
            newChartObject.translatesAutoresizingMaskIntoConstraints = false
            let newChartObjectLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let newChartObjectRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let newChartObjectTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let newChartObjectBottomMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.graphView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            self.graphView.addConstraints([newChartObjectLeftMargin,newChartObjectRightMargin,newChartObjectTopMargin,newChartObjectBottomMargin])
        }
    }
    
    func answerIsSelected(gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            for singleView in self.answerView.subviews {
                for labelView1 in singleView.subviews {
                    if let labelsView = labelView1 as? UILabel {
                        labelsView.backgroundColor = UIColor.whiteColor()
                        labelsView.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                    }
                }
            }
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                for labels in actualButton.subviews {
                    if let labelView = labels as? UILabel {
                        labelView.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
                        labelView.textColor = UIColor.whiteColor()
                    }
                    if let btnView = labels as? UIButton {
                        self.selectedAnswers[self.displayedQuestionIndex] = Int(btnView.tag)
                    }
                }
                }, completion: nil)
        }
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        
        //Check if button pressed during tutorial ?
        if self.tutoPage==3 {
            self.tutoNext(UITapGestureRecognizer())
        } else {
            
        // If no answer is selected, show Alert
        if self.selectedAnswers[self.displayedQuestionIndex]==20 {
            let exitAlert = SCLAlertView()
            exitAlert.showError("No Answer Selected", subTitle: "Please Select An Answer Before Proceeding")
        }
        else {
            //Else go to next question
            //Go to the feedback screen
            if self.displayedQuestionIndex + 1 > self.totalNumberOfQuestions {
                
                if self.resultsUploaded==false {
                    //Stop Timer
                    self.timeTimer.invalidate()
                    
                    //Upload Results to Parse
                    var i:Int = 0
                    var nbCorrectAnswers:Int = 0
                    for i=0;i<self.selectedAnswers.count;i++ {
                        if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                            nbCorrectAnswers++
                        }
                    }
                    self.scoreRatio = (Float(nbCorrectAnswers) / Float(self.selectedAnswers.count)) * 100
                    //Add: test type (numerical / verbal ...)
                    
                    var timeTaken:Float = Float(60 * self.allowedMinutes + self.allowedSeconds) - Float(60 * self.countMinutes + self.countSeconds)
                    timeTaken = timeTaken/Float(self.selectedAnswers.count)
                    
                    SwiftSpinner.show("Saving Results")
                    
                    let user = PFUser.currentUser()
                    let analytics = PFObject(className: PF_NUMREAS_CLASS_NAME)
                    analytics[PF_NUMREAS_USER] = user
                    analytics[PF_NUMREAS_SCORE] = self.scoreRatio
                    analytics[PF_NUMREAS_TIME] = timeTaken
                    analytics[PF_NUMREAS_USERNAME] = user![PF_USER_USERNAME]
                    
                    analytics.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            
                            SwiftSpinner.show("Results Saved", animated: false).addTapHandler({
                                SwiftSpinner.hide()
                                self.resultsUploaded = true
                                self.feedbackScreen()
                                }, subtitle: "Tap to proceed to feedback screen")
                            
                        } else {
                            
                            SwiftSpinner.show("Connection Error", animated: false).addTapHandler({
                                
                                SwiftSpinner.hide()
                                self.feedbackScreen()
                                
                                }, subtitle: "Results unsaved, tap to proceed to feedback")
                            
                        }
                    })
                self.nextButton.text = "Return to Feedback Screen"
                }
                else {
                    self.feedbackScreen()
                    self.nextButton.text = "Return to Feedback Screen"
                }
            }
                //Continue to the next question
            else {
                UIView.animateWithDuration(1, animations: {
                    self.swipeMenuBottomConstraint.constant = 320*self.heightRatio
                    self.view.layoutIfNeeded()
                    self.graphView.alpha = 1.0
                    self.graphContent.alpha = 1.0
                    self.descriptionSwipeLabel.text = "Swipe up for Answers"
                    self.graphTitle.alpha = 1.0
                    }, completion: nil)
                self.displayedQuestionIndex++
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.nextButton.text = "Complete Test"
                }
                self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            }
        }
        }
    }
    
    func createChartObject(questionIndex:Int) -> UIView {
        
        //Select and display chartType
        let chartType:String = self.quizzArray[questionIndex].chartType
        
        if (chartType=="bar") {
            let chartObject:BarChartView = BarChartView()
            
            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            self.graphTitle.text = self.quizzArray[questionIndex].axisNames[1]
            chartObject.descriptionText = ""
            
            chartObject.xAxis.labelPosition = .Top
            chartObject.xAxis.setLabelsToSkip(0)
            chartObject.xAxis.avoidFirstLastClippingEnabled = true
            
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            chartObject.gridBackgroundColor = UIColor(white: 0, alpha: 0)
            chartObject.xAxis.labelTextColor = UIColor.whiteColor()
            chartObject.leftAxis.labelTextColor = UIColor.whiteColor()
            chartObject.rightAxis.labelTextColor = UIColor.whiteColor()
            
            //Add chart bars
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].barSegmentNames
            let yUnits = self.quizzArray[questionIndex].yAxis
            let legendString:[String] = self.quizzArray[questionIndex].xAxis
            self.setBarChart(chartObject, dataPoints: xValues, values: yUnits, setLegendNames: legendString)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            chartObject.legend.wordWrapEnabled = true
            self.graphView.addSubview(chartObject)
            
            chartObject.userInteractionEnabled = true
            chartObject.pinchZoomEnabled = true
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13))!
            chartObject.rightAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(5))!
            chartObject.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(5))!
            chartObject.leftAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.rightAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13))!
            chartObject.doubleTapToZoomEnabled = false
            chartObject.pinchZoomEnabled = true
            
            return chartObject
        }
            
        else if (chartType=="pie") {
            let chartObject:PieChartView = PieChartView()
            
            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            self.graphTitle.text = self.quizzArray[questionIndex].chartTitle
            chartObject.descriptionText = ""
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            
            //Add Pie Chart
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].pieSegmentNames
            let yUnits = self.quizzArray[questionIndex].pieSegmentPercentages
            self.setPieChart(chartObject, dataPoints: xValues, values: yUnits)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            chartObject.legend.wordWrapEnabled = true
            self.graphView.addSubview(chartObject)
            
            chartObject.userInteractionEnabled = true
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13))!
            chartObject.legend.enabled = false
            
            return chartObject
        }
            
        else if (chartType=="line") {
            let chartObject:LineChartView = LineChartView()
            
            //Define chart settings
            chartObject.noDataText = "Error while loading data."
            self.graphTitle.text = self.quizzArray[questionIndex].axisNames[1]
            chartObject.descriptionText = ""
            chartObject.xAxis.labelPosition = .Top
            chartObject.xAxis.setLabelsToSkip(0)
            chartObject.xAxis.avoidFirstLastClippingEnabled = true
            
            chartObject.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
            chartObject.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            chartObject.gridBackgroundColor = UIColor(white: 0, alpha: 0)
            chartObject.xAxis.labelTextColor = UIColor.whiteColor()
            chartObject.leftAxis.labelTextColor = UIColor.whiteColor()
            chartObject.rightAxis.labelTextColor = UIColor.whiteColor()
            
            //Add chart lines
            var xValues:[String]!
            xValues = self.quizzArray[questionIndex].xAxis
            let yUnits = self.quizzArray[questionIndex].yAxis
            let legendString:[String] = self.quizzArray[questionIndex].lineNames
            self.setLineChart(chartObject, dataPoints: xValues, values: yUnits, setLegendNames: legendString)
            
            //Return chart UIView
            chartObject.legend.textColor = UIColor.whiteColor()
            chartObject.legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
            chartObject.legend.form = ChartLegend.ChartLegendForm.Circle
            chartObject.legend.direction = ChartLegend.ChartLegendDirection.LeftToRight
            chartObject.legend.wordWrapEnabled = true
            self.graphView.addSubview(chartObject)
            
            chartObject.userInteractionEnabled = true
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13))!
            chartObject.rightAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(5))!
            chartObject.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(5))!
            chartObject.leftAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.rightAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13))!
            chartObject.doubleTapToZoomEnabled = false
            chartObject.pinchZoomEnabled = true
            
            return chartObject
        }
            
        else {
            return UIView()
        }
        
    }
    
    func setBarChart(chartView:BarChartView, dataPoints: [String], values: [[Double]], setLegendNames:[String]) -> BarChartView {
        chartView.noDataText = "Error while loading data."
        
        var colorsChart:[UIColor] = [UIColor]()
        let color1:UIColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        let color2:UIColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
        let color3:UIColor = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        let color4:UIColor = UIColor.orangeColor()
        let color5:UIColor = UIColor.blackColor()
        let color6:UIColor = UIColor.grayColor()
        colorsChart = [color1, color2, color3, color4,color5, color6]
        
        var dataEntries: [ChartDataEntry] = []
        var y:Int = 0
        var chartDataSets:[BarChartDataSet] = [BarChartDataSet]()
        
        for y=0;y<values.count;y++ {
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[y][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: setLegendNames[y])
            //let ll = ChartLimitLine(limit: 10.0, label: "Target")
            //chartView.rightAxis.addLimitLine(ll)
            chartDataSet.setColor(colorsChart[y])
            chartDataSets.append(chartDataSet)
            dataEntries.removeAll()
        }
        
        let chartData = BarChartData(xVals: dataPoints, dataSets: chartDataSets)
        chartView.data = chartData
        chartData.setValueTextColor(UIColor.whiteColor())
        chartData.setValueFont(UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13)))
        chartView.autoScaleMinMaxEnabled = true
        
        return chartView
        
    }
    
    func setPieChart(chartView:PieChartView, dataPoints: [String], values: [Double]) -> PieChartView {
        
        let color1:UIColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        let color2:UIColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
        let color3:UIColor = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        let color4:UIColor = UIColor.orangeColor()
        let color5:UIColor = UIColor.blackColor()
        let color6:UIColor = UIColor.grayColor()
        
        var colorsChart:[UIColor] = [UIColor]()
        colorsChart = [color1, color2, color3, color4,color5, color6]
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        var colors: [UIColor] = []
        for y in 0..<dataPoints.count {
            colors.append(colorsChart[y])
        }
        chartView.data = pieChartData
        pieChartDataSet.colors = colors
        pieChartData.setValueFont(UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13)))
        
        return chartView
    }
    
    func setLineChart(chartView:LineChartView, dataPoints: [String], values: [[Double]], setLegendNames:[String]) -> LineChartView {
        
        var colorsChart:[UIColor] = [UIColor]()
        let color1:UIColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        let color2:UIColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
        let color3:UIColor = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        let color4:UIColor = UIColor.orangeColor()
        let color5:UIColor = UIColor.blackColor()
        let color6:UIColor = UIColor.grayColor()
        colorsChart = [color1, color2, color3, color4,color5, color6]
        var dataEntries: [ChartDataEntry] = []
        var y:Int = 0
        var lineChartDataSets:[LineChartDataSet] = [LineChartDataSet]()
        
        for y=0;y<values.count;y++ {
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[y][i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: setLegendNames[y])
            lineChartDataSet.setColor(colorsChart[y])
            lineChartDataSet.setCircleColor(colorsChart[y])
            lineChartDataSet.fillColor = colorsChart[y]
            lineChartDataSets.append(lineChartDataSet)
            dataEntries.removeAll()
        }
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSets: lineChartDataSets)
        
        chartView.data = lineChartData
        lineChartData.setValueTextColor(UIColor.whiteColor())
        lineChartData.setValueFont(UIFont(name: "HelveticaNeue", size: self.view.getTextSize(13)))
        chartView.data?.highlightEnabled = true
        chartView.autoScaleMinMaxEnabled = true
        
        return chartView
    }
    
    func feedbackScreen() {
        //Display feedback screen here
        self.isTestComplete = true
        var i:Int = 0
        let buttonHeight:Int = Int(40*self.heightRatio)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            let labelString:String = String("SCORE: \(round(self.scoreRatio))%")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: self.view.getTextSize(25))!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(25))!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            if self.scoreRatio<70 {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            else {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 6, length: NSString(string: labelString).length-6))
            }
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: 6))
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
        let topMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10*self.heightRatio)
        let leftMg:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
        self.feebdackScreen.addConstraints([topMg,leftMg])
        
        let widthCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
        let heightCt:NSLayoutConstraint = NSLayoutConstraint(item: topComment, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 15*self.heightRatio)
        topComment.addConstraints([heightCt,widthCt])
        topComment.text = "Select Question For Feedback"
        topComment.numberOfLines = 0
        topComment.textAlignment = NSTextAlignment.Center
        topComment.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
        topComment.textColor = UIColor.whiteColor()
        
        for i=0; i<self.selectedAnswers.count;i++ {
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
            answerNumber.textAlignment = NSTextAlignment.Center
            answerNumber.textColor = UIColor.whiteColor()
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor.whiteColor()
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.getTextSize(15))
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
            if self.quizzArray[i].correctAnswer == self.selectedAnswers[i] {
                answerUILabel.text = "Correct Answer"
                answerNumber.backgroundColor = UIColor.greenColor()
            }
            else {
                answerUILabel.text = "Wrong Answer"
                answerNumber.backgroundColor = UIColor.redColor()
            }
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+5) + 40))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20*self.widthRatio)
            self.feebdackScreen.addConstraints([topMargin,leftMargin])
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80*self.widthRatio)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraints([heightConstraint,widthConstraint])
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50*self.widthRatio)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50*self.widthRatio)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("displayAnswerWithFeedback:"))
            answerUIButton.addGestureRecognizer(tapGesture)
            
        }
        
        self.feebdackScreen.scrollEnabled = true
        let totalHeight:CGFloat = CGFloat((self.selectedAnswers.count+1) * buttonHeight)
        self.feebdackScreen.contentSize = CGSize(width: self.view.frame.width - 40*self.widthRatio, height: totalHeight)
        
    }
    
    func displayAnswerWithFeedback(gesture:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.mainView.alpha = 1.0
            self.swipeUIView.alpha = 1.0
            self.feebdackScreen.alpha = 0.0
            self.questionMenuLabel.textColor = UIColor.blackColor()
            
            var questionFeedback:Int = Int()
            let buttonTapped:UIView? = gesture.view
            if let actualButton = buttonTapped {
                questionFeedback = actualButton.tag
            }
            self.displayQuestion(self.quizzArray, indexQuestion: questionFeedback)
            
            for answerSubView in self.answerView.subviews {
                answerSubView.removeFromSuperview()
            }
            
            UIView.animateWithDuration(1, animations: {
                self.swipeMenuBottomConstraint.constant = 5*self.heightRatio
                self.view.layoutIfNeeded()
                self.graphView.alpha = 0.0
                self.graphContent.alpha = 0.0
                self.descriptionSwipeLabel.text = "Swipe down for Question"
                self.graphTitle.alpha = 0.0
                }, completion: nil)
            
            let feedbackLabel:UITextView = UITextView()
            self.answerView.addSubview(feedbackLabel)
            
            feedbackLabel.setConstraintsToSuperview(Int(10*self.heightRatio), bottom: Int(10*self.heightRatio), left: Int(30*self.widthRatio), right: Int(30*self.widthRatio))
            feedbackLabel.text = self.quizzArray[questionFeedback].explaination
            feedbackLabel.font = UIFont(name: "HelveticaNeue", size: self.view.getTextSize(14))
            
            if self.quizzArray[questionFeedback].correctAnswer == self.selectedAnswers[questionFeedback] {
                self.timeLabel.text = "Correct Answer"
                self.timeLabel.textColor = UIColor.greenColor()
                feedbackLabel.textColor = UIColor.greenColor()
            }
            else {
                self.timeLabel.text = "Wrong Answer"
                self.timeLabel.textColor = UIColor.redColor()
                feedbackLabel.textColor = UIColor.redColor()
            }
            
            }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}