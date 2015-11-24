//
//  ViewController.swift
//  Breakin2 v1.2
//
//  Created by Jean-Charles Koch on 16/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit
import Charts

class QuizzViewController: UIViewController {
    
    //Links to IB objects
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet weak var catButton: categoryButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quizzScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var containerView2Height: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var switchViewButton: UIView!
    @IBOutlet weak var switchUIView: UIView!
    
    //Initialization of variables
    var timerPage:NSTimer = NSTimer()
    var quizzModel:QuizzModel = QuizzModel()
    var quizzArray:[Question] = [Question]()
    var countSeconds:Int = 00
    var countMinutes:Int = 20
    var displayedQuestionIndex:Int = 0
    var totalNumberOfQuestions:Int = 2
    var answerSwitchButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.quizzScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView2.translatesAutoresizingMaskIntoConstraints = false
        
        //Style of menuLabel UILabel
        self.menuLabel.layer.cornerRadius = 8.0
        self.menuLabel.layer.borderWidth = 1.0
        self.menuLabel.layer.borderColor = UIColor.grayColor().CGColor
        self.menuLabel.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        
        //Style of topMenuView UILabel
        self.topMenuView.layer.cornerRadius = 8.0
        self.topMenuView.layer.borderWidth = 1.0
        self.topMenuView.layer.borderColor = UIColor.whiteColor().CGColor
        self.topMenuView.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        
        //Style of the QuestionLabel
        self.questionNumber.layer.cornerRadius = 8.0
        self.questionNumber.layer.borderWidth = 1.0
        self.questionNumber.layer.borderColor = UIColor.whiteColor().CGColor
        self.questionNumber.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.answerSwitchButton = self.createSwitchButton()
        
        //Style of Previous and Next buttons
        self.previousButton.layer.cornerRadius = 8.0
        self.previousButton.layer.borderWidth = 1.0
        self.previousButton.layer.borderColor = UIColor.grayColor().CGColor
        self.previousButton.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.nextButton.layer.cornerRadius = 8.0
        self.nextButton.layer.borderWidth = 1.0
        self.nextButton.layer.borderColor = UIColor.grayColor().CGColor
        self.nextButton.layer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.previousButton.alpha = 0.4
        
        //Style of the containerViews and scrollView
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView2.translatesAutoresizingMaskIntoConstraints = false
        self.quizzScrollView.contentSize = CGSize(width: self.quizzScrollView.frame.width, height: 750)
        self.containerView2Height.constant = 750
        self.containerViewHeight.constant = 750
        
        //Get questions from JSON file
        self.quizzArray = self.quizzModel.selectQuestions()
        self.displayQuestion(self.quizzArray, indexQuestion: self.displayedQuestionIndex)
        
        //Launch timer
        timerPage = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion(arrayOfQuestions:[Question], indexQuestion:Int) {
        
        //Initialize the containerViews for the question and the answers
        for singleSubview in self.containerView.subviews {
            singleSubview.removeFromSuperview()
        }
        for singleSubview in self.containerView2.subviews {
            singleSubview.removeFromSuperview()
        }
        self.containerView2.alpha = 0.0
        self.containerView.alpha = 0.0
        self.questionNumber.text = "Question \(indexQuestion+1) / \(self.totalNumberOfQuestions+1)"
        
        //Update the view with the new question
        let questionText:String = arrayOfQuestions[indexQuestion].questionText
        let questionLabel:UILabel = self.createTextLabel(self.containerView,constraintRelatesTo: self.containerView)
        questionLabel.text = questionText
        
        //Update the switch button
        self.answerSwitchButton.setTitle("Answers", forState: .Normal)
        self.answerSwitchButton.tag = indexQuestion
        self.answerSwitchButton.addTarget(self, action: "showAnswers:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Update the view with the new figure
        let newChartObject:UIView = self.createChartObject(questionLabel)

        //Set chart constraints
        newChartObject.translatesAutoresizingMaskIntoConstraints = false
        let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: questionLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
        self.containerView.addConstraints([leftMargin,rightMargin,topMargin])
        let graphHeight:NSLayoutConstraint = NSLayoutConstraint(item: newChartObject, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500)
        newChartObject.addConstraint(graphHeight)

    }
    
    func createChartObject(topBlockPosition:UIView) -> UIView {
        
        //Define chart Axis
        var months: [String]!
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        //Select and display chartType
        let chartType:String = self.quizzArray[self.answerSwitchButton.tag].chartDescription
        if (chartType=="barChart") {
            let chartObject:BarChartView = BarChartView()
            self.setBarChart(chartObject, dataPoints: months, values: unitsSold)
            self.containerView.addSubview(chartObject)
            return chartObject
        }
        else if (chartType=="pieChart") {
            let chartObject:PieChartView = PieChartView()
            self.setPieChart(chartObject, dataPoints: months, values: unitsSold)
            self.containerView.addSubview(chartObject)
            return chartObject
        }
        else if (chartType=="lineChart") {
            let chartObject:LineChartView = LineChartView()
            self.setLineChart(chartObject, dataPoints: months, values: unitsSold)
            self.containerView.addSubview(chartObject)
            return chartObject
        }
        else {
            return UIView()
        }
    }
    
    func setBarChart(chartView:BarChartView, dataPoints: [String], values: [Double]) -> BarChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        
        chartView.descriptionText = ""
        //chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartView.xAxis.labelPosition = .Bottom
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        chartView.rightAxis.addLimitLine(ll)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    func setPieChart(chartView:PieChartView, dataPoints: [String], values: [Double]) -> PieChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        chartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }

        pieChartDataSet.colors = colors
        chartView.descriptionText = ""
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    func setLineChart(chartView:LineChartView, dataPoints: [String], values: [Double]) -> LineChartView {
        chartView.noDataText = "Error while loading data."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        chartView.data = lineChartData
        
        chartView.descriptionText = ""
        lineChartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartView.xAxis.labelPosition = .Bottom
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        chartView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return chartView
    }
    
    func displayAnswersInView(arrayOfAnswers:[String]) {
        
        //Create a UIVIew per answer
        let buttonHeight:Int = 40
        var i:Int = 0
        for i=0; i<arrayOfAnswers.count;i++ {
            let answerUIButton:UIView = UIView()
            let answerUILabel:UILabel = UILabel()
            let answerNumber:UILabel = UILabel()
            answerUIButton.translatesAutoresizingMaskIntoConstraints = false
            answerUILabel.translatesAutoresizingMaskIntoConstraints = false
            answerNumber.translatesAutoresizingMaskIntoConstraints = false
            self.containerView2.addSubview(answerUIButton)
            answerUIButton.addSubview(answerUILabel)
            answerUIButton.addSubview(answerNumber)
            answerNumber.text = String(i+1)
            answerNumber.textAlignment = NSTextAlignment.Center
            answerNumber.textColor = UIColor.whiteColor()
            answerNumber.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            answerUILabel.text = String(arrayOfAnswers[i])
            answerUILabel.textAlignment = NSTextAlignment.Center
            answerUILabel.textColor = UIColor.whiteColor()
            answerUILabel.numberOfLines = 0
            answerUILabel.adjustsFontSizeToFitWidth = true
            answerUIButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            answerUILabel.font = UIFont(name: "HelveticaNeue", size: 15.0)

            //Set constraints to UIViews
            let topMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: CGFloat(i*(buttonHeight+5)))
            let rightMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: CGFloat(-20))
            let leftMargin:NSLayoutConstraint = NSLayoutConstraint(item: answerUIButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.containerView2, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: CGFloat(20))
            self.containerView2.addConstraints([topMargin,rightMargin,leftMargin])
            
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
            
            let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "answerIsSelected:")
            answerUIButton.addGestureRecognizer(tapGesture)

            //Animate transition
            //leftMargin.constant = 1000
            //self.quizzScrollView.layoutIfNeeded()
            //UIView.animateWithDuration(0.04*Double(i+1), animations: {
            //    leftMargin.constant = 20
            //    self.quizzScrollView.layoutIfNeeded()
            //})
        }

    }

    func answerIsSelected(gesture:UITapGestureRecognizer) {
        let buttonTapped:UIView? = gesture.view 
        if let actualButton = buttonTapped {
            for singleView in self.containerView2.subviews {
                singleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                actualButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                }, completion: nil)
        }
    }
    
    func createTextLabel(superViewName:UIView, constraintRelatesTo:UIView) -> UILabel {
        //Create and initialize the Label
        let newTextLabel:UILabel = UILabel()
        newTextLabel.translatesAutoresizingMaskIntoConstraints = false
        superViewName.addSubview(newTextLabel)
        newTextLabel.text = "Could not load any question; quick test to see if the height of the label automatically increase depending on the size of the contained string included in the question JSON file"
        newTextLabel.textAlignment = NSTextAlignment.Center
        newTextLabel.textColor = UIColor.blackColor()
        newTextLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        newTextLabel.numberOfLines = 0
        
        //Set autolayout constraints within container view
        let marginTop:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: constraintRelatesTo, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        let marginLeft:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: superViewName, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        let marginRight:NSLayoutConstraint = NSLayoutConstraint(item: newTextLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: superViewName, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        superViewName.addConstraints([marginLeft,marginRight,marginTop])
        
        //Transition
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 1.0
            }, completion: nil)
        
        //Return the created Label
        return newTextLabel
    }
    
    func createSwitchButton() -> UIButton {

        //Create and initialize containerView
        self.switchUIView.layer.cornerRadius = 6.0
        self.switchUIView.layer.backgroundColor = UIColor.blackColor().CGColor
        self.switchUIView.translatesAutoresizingMaskIntoConstraints = false

        //Initialize left button
        let labelButton:paddingLabel = paddingLabel()
        self.switchUIView.addSubview(labelButton)
        labelButton.translatesAutoresizingMaskIntoConstraints = false
        let contLeft:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let contTop:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let contBottom:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.switchUIView.addConstraints([contLeft,contTop,contBottom])
        let labelWidth:NSLayoutConstraint = NSLayoutConstraint(item: labelButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        labelButton.addConstraint(labelWidth)
        labelButton.textColor = UIColor.whiteColor()
        labelButton.backgroundColor = UIColor.blackColor()
        labelButton.font = UIFont(name: "HelveticaNeue-Bold", size: 10.0)
        labelButton.text = "Go To:"
        labelButton.layer.cornerRadius = 6.0
        labelButton.layer.masksToBounds = true
        
        //Initialize right button
        let textButton:UIButton = UIButton()
        self.switchUIView.addSubview(textButton)
        textButton.translatesAutoresizingMaskIntoConstraints = false
        let constRight:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let constTop:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let constBottom:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.switchUIView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.switchUIView.addConstraints([constRight,constTop,constBottom])
        let textWidth:NSLayoutConstraint = NSLayoutConstraint(item: textButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 70)
        textButton.addConstraint(textWidth)
        textButton.titleLabel?.textColor = UIColor.whiteColor()
        textButton.backgroundColor = UIColor.grayColor()
        textButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10.0)
        textButton.layer.cornerRadius = 6.0
        textButton.titleLabel?.textAlignment = NSTextAlignment.Center
        textButton.layer.masksToBounds = true
        
        return textButton
    }
    
    func showAnswers(sender:UIButton) {
        for singleSubview in self.containerView2.subviews {
            singleSubview.removeFromSuperview()
        }
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 0.0
            self.containerView2.alpha = 1.0
            }, completion: nil)
        let arrayOA:[String] = self.quizzArray[sender.tag].answersText
        displayAnswersInView(arrayOA)
        self.answerSwitchButton.setTitle("Question", forState: .Normal)
        self.answerSwitchButton.removeTarget(self, action: "showAnswers:", forControlEvents: UIControlEvents.TouchUpInside)
        self.answerSwitchButton.addTarget(self, action: "showQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func showQuestion(sender:UIButton) {
        self.answerSwitchButton.removeTarget(self, action: "showQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.containerView.alpha = 1.0
            self.containerView2.alpha = 0.0
            }, completion: nil)
        self.answerSwitchButton.setTitle("Answers", forState: .Normal)
        self.answerSwitchButton.addTarget(self, action: "showAnswers:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func updateTimer() {
        if (self.countSeconds-1<0) {
            if (self.countMinutes+self.countSeconds==0) {
                self.timerPage.invalidate()
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
        timerLabel.text = newLabel
    }
    
    @IBAction func previousQ(sender: UIButton) {
        if self.displayedQuestionIndex-1 >= 0 {
            self.displayedQuestionIndex--
            updateViewWithNewQuestion(self.displayedQuestionIndex)
        }
    }
    
    @IBAction func nextQ(sender: UIButton) {
        if self.displayedQuestionIndex+1 <= self.totalNumberOfQuestions {
            self.displayedQuestionIndex++
            updateViewWithNewQuestion(self.displayedQuestionIndex)
        }
    }
    
    func updateViewWithNewQuestion(questionToDisplay:Int) {
        if questionToDisplay==self.totalNumberOfQuestions {
            self.nextButton.alpha = 0.4
        }
        else if questionToDisplay==0 {
            self.previousButton.alpha = 0.4
        }
        else {
            self.nextButton.alpha = 1.0
            self.previousButton.alpha = 1.0
        }
        self.displayQuestion(self.quizzArray, indexQuestion: questionToDisplay)
    }


}

