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

class arithmeticReasoningViewController: UIViewController, UIScrollViewDelegate {
    
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
    let mainView:UIView = UIView()
    var quizzModel:JSONModel = JSONModel()
    var quizzArray:[arithmeticQuestion] = [arithmeticQuestion]()
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 19
    var allowedSeconds:Int = 00
    var allowedMinutes:Int = 20
    var countSeconds:Int = Int()
    var countMinutes:Int = Int()
    let nextButton:UILabel = UILabel()
    var selectedAnswers:[Int] = [Int]()
    var qViewHeight:NSLayoutConstraint = NSLayoutConstraint()
    let feebdackScreen:UIScrollView = UIScrollView()
    var scoreRatio:Float = Float()
    var isTestComplete:Bool = false
    var resultsUploaded:Bool = false
    var testEnded:Bool = false
    var answerView:UIView = UIView()
    var questionRect:UIView = UIView()
    
    //ViewDidLoad call
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize timer
        self.countSeconds = self.allowedSeconds
        self.countMinutes = self.allowedMinutes
        
        //Initialize backgroun UIView
        self.view.addSubview(self.backgroungUIView)
        self.backgroungUIView.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "arithmeticBG")
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroungUIView.addSubview(imageViewBackground)
        self.backgroungUIView.sendSubviewToBack(imageViewBackground)
        
        //Initialize back home button
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
        
        //Initialize questionNumber Label
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
        let swipeMenuTopBarHeight:NSLayoutConstraint = NSLayoutConstraint(item: self.swipeMenuTopBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
        self.swipeMenuTopBar.addConstraint(swipeMenuTopBarHeight)
        self.swipeMenuTopBar.addSubview(self.timeLabel)
        self.timeLabel.text = "\(self.countMinutes):\(self.countSeconds)"
        self.timeLabel.setConstraintsToSuperview(0, bottom: 0, left: 0, right: 0)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold",size: 18.0)
        self.timeLabel.textAlignment = NSTextAlignment.Center
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.userInteractionEnabled = true
        
        //Initialize mainView and answerView
        self.view.addSubview(self.mainView)
        self.mainView.setConstraintsToSuperview(75, bottom: 130, left: 20, right: 20)
        self.mainView.addSubview(self.answerView)
        self.answerView.translatesAutoresizingMaskIntoConstraints = false
        let answerViewTop:NSLayoutConstraint = NSLayoutConstraint(item: self.answerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let answerViewRight:NSLayoutConstraint = NSLayoutConstraint(item: self.answerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let answerViewBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.answerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.mainView.addConstraints([answerViewTop,answerViewRight,answerViewBottom])
        let answerViewWidth:NSLayoutConstraint = NSLayoutConstraint(item: self.answerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 75)
        self.answerView.addConstraint(answerViewWidth)
        self.mainView.addSubview(self.questionRect)
        self.questionRect.translatesAutoresizingMaskIntoConstraints = false
        let questionRectTop:NSLayoutConstraint = NSLayoutConstraint(item: self.questionRect, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
        let questionRectBottom:NSLayoutConstraint = NSLayoutConstraint(item: self.questionRect, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let questionRectRight:NSLayoutConstraint = NSLayoutConstraint(item: self.questionRect, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -85)
        let questionRectLeft:NSLayoutConstraint = NSLayoutConstraint(item: self.questionRect, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.mainView.addConstraints([questionRectTop,questionRectRight,questionRectBottom,questionRectLeft])
        
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
        let topLabelMargin:NSLayoutConstraint = NSLayoutConstraint(item: nextUIView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.swipeUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 50)
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
        self.quizzArray = self.quizzModel.selectArithmeticReasoning(self.totalNumberOfQuestions+1)
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        //Launch timer
        timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
        //Initialize swipeUIView
        self.view.addSubview(self.swipeUIView)
        self.swipeUIView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeMenuHeightConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
        self.swipeUIView.addConstraint(self.swipeMenuHeightConstraint)
        self.swipeMenuBottomConstraint = NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        let leftMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let rightMargin:NSLayoutConstraint =  NSLayoutConstraint(item: self.swipeUIView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        self.view.addConstraints([leftMargin,rightMargin,self.swipeMenuBottomConstraint])
        self.swipeUIView.backgroundColor = UIColor.whiteColor()
        self.swipeUIView.layer.cornerRadius = 8.0
    }
    
    func updateTimer() {
        if self.testEnded {
            self.displayedQuestionIndex = self.totalNumberOfQuestions
            if self.selectedAnswers[self.displayedQuestionIndex]==20 {
                self.selectedAnswers[self.displayedQuestionIndex]=19
            }
            self.nextQuestion(UITapGestureRecognizer(target: self, action: Selector("nextQuestion:")))
            self.timeTimer.invalidate()
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
    
    func displayQuestion(arrayOfQuestions:[arithmeticQuestion], indexQuestion:Int) {
        
        //Initialize labels
        let labelString:String = String("QUESTION \(indexQuestion+1)/\(self.totalNumberOfQuestions+1)")
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: labelString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 25.0)!, range: NSRange(location: 0, length: NSString(string: labelString).length))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Medium", size: 25.0)!, range: NSRange(location: 9, length: NSString(string: labelString).length-9))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0, length: NSString(string: labelString).length))
        self.questionMenuLabel.attributedText = attributedString
        self.questionMenuLabel.attributedText = attributedString

        // add answers to SwipeUIVIew
        for answerSubView in self.answerView.subviews {
            answerSubView.removeFromSuperview()
        }
        let arrayAnswers:[String] = self.quizzArray[indexQuestion].answers
        let questionAsked:String = self.quizzArray[indexQuestion].question
        let buttonHeight:Int = 75
        var i:Int = 0
        
        for i=0; i<arrayAnswers.count;i++ {
            let answerNumber:UIButton = UIButton()
            let matchingQuestionLabel:UIButton = UIButton()
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            matchingQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
            self.answerView.addSubview(answerNumber)
            self.questionRect.addSubview(matchingQuestionLabel)

            answerNumber.tag = i
            answerNumber.setTitle(arrayAnswers[i], forState: .Normal)
            answerNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            answerNumber.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
            answerNumber.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
            answerNumber.layer.borderWidth = 2.0
            answerNumber.layer.borderColor = UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0).CGColor
            answerNumber.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
            
            matchingQuestionLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
            matchingQuestionLabel.setTitleColor(UIColor(red: 82/255, green: 107/255, blue: 123/255, alpha: 1.0), forState: .Normal)
            matchingQuestionLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-LightBold", size: 20.0)
            matchingQuestionLabel.tag = i
            matchingQuestionLabel.setTitle(questionAsked, forState: .Normal)
            matchingQuestionLabel.alpha = 0.0
            
            let topM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.questionRect, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10)))
            let leftM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.questionRect, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let rightM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.questionRect, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.questionRect.addConstraints([topM,leftM,rightM])
            let heightM:NSLayoutConstraint = NSLayoutConstraint(item: matchingQuestionLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            matchingQuestionLabel.addConstraint(heightM)
            
            let topMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+10)))
            let leftMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let rightMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.answerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            self.answerView.addConstraints([topMM,leftMM,rightMM])
            let heightMM:NSLayoutConstraint = NSLayoutConstraint(item: answerNumber, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight))
            answerNumber.addConstraint(heightMM)
    
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("answerIsSelected:"))
            answerNumber.addGestureRecognizer(tapGesture)
        }
    }
    
    func answerIsSelected(gesture:UITapGestureRecognizer) {
        for buttons in self.answerView.subviews {
            if let anyButton = buttons as? UIButton {
                anyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
            }
        }
        for buttons in self.questionRect.subviews {
            if let anyButton = buttons as? UIButton {
                anyButton.alpha = 0.0
            }
        }
        let buttonTapped:UIView? = gesture.view
        if let actualButton = buttonTapped {
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                actualButton.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
                self.selectedAnswers[self.displayedQuestionIndex] = Int(actualButton.tag)
                for buttons in self.questionRect.subviews {
                    if let corrButton = buttons as? UIButton {
                        if corrButton.tag == actualButton.tag {
                            corrButton.alpha = 1.0
                        }
                    }
                }
            }, completion: nil)
        }
    }
    
    func nextQuestion(gesture:UITapGestureRecognizer) {
        
        // If no answer is selected, show Alert
        if self.selectedAnswers[self.displayedQuestionIndex] == 20 {
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
                }
                else {
                    self.feedbackScreen()
                }
            }
                //Continue to the next question
            else {
                self.displayedQuestionIndex++
                if self.displayedQuestionIndex==self.totalNumberOfQuestions{
                    //Switch Button text to "Complete"
                    self.nextButton.text = "Complete Test"
                }
                self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
            }
        }
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
        self.feebdackScreen.contentSize = CGSize(width: (self.view.frame.width - 40), height: totalHeight+10)
        
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
            
            let feedbackLabel:UITextView = UITextView()
            self.answerView.addSubview(feedbackLabel)
            
            feedbackLabel.setConstraintsToSuperview(10, bottom: 10, left: 30, right: 30)
            feedbackLabel.text = String(self.quizzArray[questionFeedback].correctAnswer)
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