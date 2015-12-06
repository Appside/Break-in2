//
//  question.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class Question {
    
    var questionType:String = String()
    var chartType:String = String()
    var axisNames:[String] = [String]()
    var lineNames:[String] = [String]()
    var xAxis:[String] = [String]()
    var yAxis:[[Double]] = [[Double]()]
    var question:String = String()
    var answers:[String] = [String]()
    var correctAnswer:Int = Int()
    var explaination:String = String()
    var barSegmentOrientation:String = String()
    var barSegmentNames:[String] = [String]()
    var chartTitle:String = String()
    var pieSegmentNames:[String] = [String]()
    var pieSegmentPercentages:[Double] = [Double]()

}