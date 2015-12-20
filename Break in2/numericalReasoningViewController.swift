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

class numericalReasoningViewController: UIViewController, UIScrollViewDelegate {
    
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
    var quizzModel:QuizzModel = QuizzModel()
    var quizzArray:[numericalQuestion] = [numericalQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 4
    let questionLabel:UITextView = UITextView()
    var allowedSeconds:Int = 00
    var allowedMinutes:Int = 20
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
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize timer
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        
        //Initialize backgroun UIView
        self.view.addSubview(self.backgroungUIView)
        self.backgroungUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.backgroungUIView.addHomeBG()
        
        //Initialize menuBackButton UIView
        self.view.addSubview(self.menuBackButton)
        self.menuBackButton.translatesAutoresizingMaskIntoConstraints = false
        let topMenuViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let topMenuViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75)
        let topMenuViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let topMenuViewLeftMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.menuBackButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        self.menuBackButton.addConstraints([topMenuViewHeight, topMenuViewWidth])
        self.view.addConstraints([topMenuViewLeftMargin,topMenuViewTopMargin])
        self.menuBackButton.layer.cornerRadius = 8.0
        let menuBackImageVIew:UIImageView = UIImageView()
        menuBackImageVIew.image = UIImage(named: "back")
        menuBackImageVIew.translatesAutoresizingMaskIntoConstraints = false
        self.menuBackButton.addSubview(menuBackImageVIew)
        let arrowTop:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant:0)
        let arrowLeft:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.menuBackButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant:0)
        let arrowHeight:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:UIScreen.mainScreen().bounds.width/14)
        let arrowWidth:NSLayoutConstraint = NSLayoutConstraint(item: menuBackImageVIew, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant:UIScreen.mainScreen().bounds.width/14)
        self.menuBackButton.addConstraints([arrowTop,arrowLeft])
        menuBackImageVIew.addConstraints([arrowHeight,arrowWidth])
        let tapGestureBackHome:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("backHome:"))
        tapGestureBackHome.numberOfTapsRequired = 1
        self.menuBackButton.addGestureRecognizer(tapGestureBackHome)
        
        //Initialize questionMenu UIView
        self.view.addSubview(self.questionMenu)
        self.questionMenu.translatesAutoresizingMaskIntoConstraints = false
        let questionViewHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
        let questionViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 115)
        let questionViewTopMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        let questionViewRightMargin:NSLayoutConstraint = NSLayoutConstraint(item: self.questionMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        self.questionMenu.addConstraints([questionViewHeight, questionViewWidth])
        self.view.addConstraints([questionViewRightMargin,questionViewTopMargin])
        self.menuBackButton.bringSubviewToFront(self.questionMenu)
        
        self.questionMenu.addSubview(self.questionMenuLabel)
        self.questionMenuLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 75)
        questionMenuLabel.textAlignment = NSTextAlignment.Center
        self.questionMenuLabel.textColor = UIColor.whiteColor()
        
        
        //Initialize swipeMenuTopBar UIView
        self.swipeUIView.addSubview(self.swipeMenuTopBar)
        self.swipeMenuTopBar.translatesAutoresizingMaskIntoConstraints = false
        let swipeMenuTopBarTop:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let swipeMenuTopBarLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        let swipeMenuTopBarRight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
        self.swipeUIView.addConstraints([swipeMenuTopBarTop,swipeMenuTopBarLeft,swipeMenuTopBarRight])
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = "--:--"
        self.timeLabel.setConstraintsToSuperview(0, bottom: 30, left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: 18.0)
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        self.swipeMenuTopBar.addSubview(self.descriptionSwipeLabel)
        self.descriptionSwipeLabel.setConstraintsToSuperview(30, bottom: 0, left: 0, right: 0)
        self.descriptionSwipeLabel.text = "Swipe up for Answers"
        self.descriptionSwipeLabel.font = UIFont(name: "HelveticaNeue-Medium",size: 14.0)
        self.descriptionSwipeLabel.textAlignment = NSTextAlignment.Center
        self.descriptionSwipeLabel.textColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.descriptionSwipeLabel.userInteractionEnabled = true
        self.swipeUIView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        self.answerView.setConstraintsToSuperview(80, bottom: 70, left: 0, right: 0)
        
        //Initialize mainView, questionView and GraphView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(75, bottom: 85, left: 20, right: 20)
        let graphContent:UIView = UIView()
        self.mainView.addSubview(self.questionView)
        self.mainView.addSubview(graphContent)
        graphContent.addSubview(self.graphView)
        self.questionView.translatesAutoresizingMaskIntoConstraints = false
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphContent.translatesAutoresizingMaskIntoConstraints = false
        
        let graphContentTop:NSLayoutConstraint = NSLayoutConstraint(item: graphContent, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 90)
        let graphContentRight:NSLayoutConstraint = NSLayoutConstraint(item: graphContent, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphContentLeft:NSLayoutConstraint = NSLayoutConstraint(item: graphContent, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let graphContentBottom:NSLayoutConstraint = NSLayoutConstraint(item: graphContent, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([graphContentTop,graphContentRight,graphContentLeft,graphContentBottom])
        
        let questionViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let questionViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let questionViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionViewTop,questionViewRight,questionViewLeft])
        self.qViewHeight = NSLayoutConstraint(item: self.questionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75)
        self.mainView.addConstraint(qViewHeight)
        
        //update questionView
        self.questionView.addSubview(self.questionLabel)
        self.questionLabel.setConstraintsToSuperview(Int(round(self.questionView.frame.height-self.questionLabel.frame.height)/2), bottom: 0, left: 5, right: 5)
        self.questionLabel.textColor = UIColor.whiteColor()
        self.questionLabel.font = UIFont(name: "HelveticaNeue-Light",size: 16.0)
        self.questionLabel.textAlignment = NSTextAlignment.Center
        self.questionLabel.backgroundColor = UIColor(white: 0, alpha: 0)
        self.questionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.questionView.layer.cornerRadius = 8.0
        graphContent.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        graphContent.layer.cornerRadius = 8.0
        
        graphContent.addSubview(self.graphTitle)
        self.graphTitle.translatesAutoresizingMaskIntoConstraints = false
        self.graphTitle.numberOfLines = 0
        let graphTitleTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
        let graphTitleRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        let graphTitleLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        graphContent.addConstraints([graphTitleTop,graphTitleRight,graphTitleLeft])
        let graphTitleHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphTitle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35)
        self.graphTitle.addConstraint(graphTitleHeight)
        self.graphTitle.textAlignment = NSTextAlignment.Left
        self.graphTitle.font = UIFont(name: "HelveticaNeue-Italic", size: 14.0)
        self.graphTitle.textColor = UIColor.whiteColor()
        
        //Update top constraint
        let graphViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50)
        let graphViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let graphViewLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let graphViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: graphContent, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        graphContent.addConstraints([graphViewTop,graphViewRight,graphViewLeft,graphViewBottom])
        
        //Create nextButton
        let nextUIView:UIView = UIView()
        self.swipeUIView.addSubview(nextUIView)
        nextUIView.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.backgroundColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0)
        self.nextButton.textColor = UIColor.whiteColor()
        self.nextButton.textAlignment = NSTextAlignment.Center
        self.nextButton.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.nextButton.text = "Next"
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 320)
        let rightLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
        let leftLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
        self.swipeUIView.addConstraints([topLabelMargin,rightLabelMargin,leftLabelMargin])
        let heightLabelConstraint:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 50)
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
        
        //Launch timer
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 390)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 320)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
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
    }
    
    //Show Swipe Menu
    func showSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 5
            self.view.layoutIfNeeded()
            self.graphView.alpha = 0.0
            self.descriptionSwipeLabel.text = "Swipe down for Question"
            self.graphTitle.alpha = 0.0
            }, completion: nil)
    }
    
    //Hie Swipe Menu
    func hideSwipeMenu(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(1, animations: {
            self.swipeMenuBottomConstraint.constant = 320
            self.view.layoutIfNeeded()
            self.graphView.alpha = 1.0
            self.descriptionSwipeLabel.text = "Swipe up for Answers"
            self.graphTitle.alpha = 1.0
            }, completion: nil)
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=19
            }
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
    
    
    func displayQuestion(arrayOfQuestions:[numericalQuestion], indexQuestion:Int) {
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25.0)!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 25.0)!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
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
        let buttonHeight:Int = 50
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
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            answerUIButton.layer.borderWidth = 3.0
            answerUIButton.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            
            //Set constraints to answerViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10)))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
            self.answerView.addConstraints([topMargin,rightMargin,leftMargin])
            
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraint(heightConstraint)
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
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
                    let timeTaken:Int = ( 60 * self.allowedMinutes + self.allowedSeconds) - (60 * self.countMinutes + self.countSeconds)
                    
                    let waitAlert:SCLAlertViewResponder = SCLAlertView().showSuccess("Test Completed", subTitle: "Saving Results...")
                    let saveError = SCLAlertView()
                    
                    let user = PFUser.currentUser()
                    let analytics = PFObject(className: PF_ANALYTICS_CLASS_NAME)
                    analytics[PF_ANALYTICS_USER] = user
                    analytics[PF_ANALYTICS_SCORE] = self.scoreRatio
                    analytics[PF_ANALYTICS_TIME] = timeTaken
                    
                    analytics.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            waitAlert.setTitle("Test Completed")
                            waitAlert.setSubTitle("Continue to feedback")
                            self.resultsUploaded = true
                            self.feedbackScreen()
                            
                        } else {
                            
                            saveError.showError("Error", subTitle: "Try again")
                            
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
                    self.swipeMenuBottomConstraint.constant = 320
                    self.view.layoutIfNeeded()
                    self.graphView.alpha = 1.0
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
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: 13.0)!
            chartObject.rightAxis.labelFont = UIFont(name: "HelveticaNeue", size: 5.0)!
            chartObject.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: 5.0)!
            chartObject.leftAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.rightAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 13.0)!
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
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: 13.0)!
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
            chartObject.legend.font = UIFont(name: "HelveticaNeue", size: 13.0)!
            chartObject.rightAxis.labelFont = UIFont(name: "HelveticaNeue", size: 5.0)!
            chartObject.leftAxis.labelFont = UIFont(name: "HelveticaNeue", size: 5.0)!
            chartObject.leftAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.rightAxis.labelTextColor = UIColor(white: 0.0, alpha: 0.0)
            chartObject.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 13.0)!
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
        chartData.setValueFont(UIFont(name: "HelveticaNeue", size: 13.0))
        
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
        pieChartData.setValueFont(UIFont(name: "HelveticaNeue", size: 13.0))
        
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
        lineChartData.setValueFont(UIFont(name: "HelveticaNeue", size: 13.0))
        chartView.data?.highlightEnabled = true
        
        return chartView
    }
    
    func feedbackScreen() {
        //Display feedback screen here
        self.isTestComplete = true
        var i:Int = 0
        let buttonHeight:Int = 40
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            let labelString:String = String("SCORE: \(round(self.scoreRatio))%")
            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25.0)!, range: NSRange(location: 0, length: NSString(string: labelString).length))
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 25.0)!, range: NSRange(location: 6, length: NSString(string: labelString).length-6))
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
            self.feebdackScreen.setConstraintsToSuperview(75, bottom: 20, left: 20, right: 20)
            self.feebdackScreen.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.feebdackScreen.layer.cornerRadius = 8.0
            }, completion: nil)
        
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
            answerUILabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
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
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10) + 20))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.feebdackScreen, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            self.feebdackScreen.addConstraints([topMargin,leftMargin])
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width - 80)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: CGFloat(buttonHeight))
            answerUIButton.addConstraints([heightConstraint,widthConstraint])
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 50)
            let bottomM:NSLayoutConstraint = NSLayoutConstraint(item: answerUILabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topM,rightM,leftM,bottomM])
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let bottomMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: answerUIButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            answerUIButton.addConstraints([topMM,leftMM,bottomMM])
            let widthMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
            answerNumber.addConstraint(widthMM)
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("displayAnswerWithFeedback:"))
            answerUIButton.addGestureRecognizer(tapGesture)
            
        }
        
        self.feebdackScreen.scrollEnabled = true
        let totalHeight:CGFloat = CGFloat((self.selectedAnswers.count+1) * (buttonHeight + 10))
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40), height: totalHeight + 10)
        
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
                self.swipeMenuBottomConstraint.constant = 5
                self.view.layoutIfNeeded()
                self.graphView.alpha = 0.0
                self.descriptionSwipeLabel.text = "Swipe down for Question"
                self.graphTitle.alpha = 0.0
                }, completion: nil)
            
            let feedbackLabel:UITextView = UITextView()
            self.answerView.addSubview(feedbackLabel)
            
            feedbackLabel.setConstraintsToSuperview(10, bottom: 10, left: 30, right: 30)
            feedbackLabel.text = self.quizzArray[questionFeedback].explaination
            feedbackLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
            
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