//
//  quizzModel.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class QuizzModel: NSObject {
    
    func selectQuestions() -> [Question] {
        
        //Initialize variables
        var arrayOfQuestions:[Question] = [Question]()
        
        //Get JSon file
        let jsonObject:[NSDictionary] = self.getjsonfile()
        var index:Int = 0
        for index = 0; index < jsonObject.count; index++ {
            let currentJsonDictionary:NSDictionary = jsonObject[index]
            let newQuestion:Question = Question()
            //Assign values to the newQuestion                                                                                                                                                                                                                                                
            newQuestion.questionType = currentJsonDictionary["questionType"] as! String
            newQuestion.chartType = currentJsonDictionary["chartType"] as! String
            
            if newQuestion.chartType=="bar" {
                newQuestion.axisNames = currentJsonDictionary["axisNames"] as! [String]
                newQuestion.barSegmentOrientation = currentJsonDictionary["barSegmentOrientation"] as! String
                newQuestion.barSegmentNames = currentJsonDictionary["barSegmentNames"] as! [String]
                newQuestion.xAxis = currentJsonDictionary["xAxis"] as! [String]
                newQuestion.yAxis = currentJsonDictionary["yAxis"] as! [[Double]]
            }
            else if newQuestion.chartType=="line" {
                newQuestion.axisNames = currentJsonDictionary["axisNames"] as! [String]
                newQuestion.lineNames = currentJsonDictionary["lineNames"] as! [String]
                newQuestion.xAxis = currentJsonDictionary["xAxis"] as! [String]
                newQuestion.yAxis = currentJsonDictionary["yAxis"] as! [[Double]]
            }
            else if newQuestion.chartType=="pie" {
                newQuestion.chartTitle = currentJsonDictionary["chartTitle"] as! String
                newQuestion.pieSegmentNames = currentJsonDictionary["pieSegmentNames"] as! [String]
                newQuestion.pieSegmentPercentages = currentJsonDictionary["pieSegmentPercentages"] as! [Double]
                
            }
            
            newQuestion.question = currentJsonDictionary["question"] as! String
            newQuestion.answers = currentJsonDictionary["answers"] as! [String]
            newQuestion.correctAnswer = currentJsonDictionary["correctAnswer"] as! Int
            newQuestion.explaination = currentJsonDictionary["explaination"] as! String
            //Add the new Question to the returned array
            arrayOfQuestions.append(newQuestion)
        }
        
        //Return final array
        return arrayOfQuestions
    }
    
    func getjsonfile() -> [NSDictionary] {
     
        //Define JSon file URL
        let fileBundlePath:String? = NSBundle.mainBundle().pathForResource("NumericalReasoning", ofType: "json")
        if let actualFilePath = fileBundlePath {
            //Case where the path has been found
            let urlPath:NSURL = NSURL(fileURLWithPath: actualFilePath)
            let jsonData:NSData? = NSData(contentsOfURL: urlPath)
            if let actualJsonData = jsonData {
                //NSData exist so use NSJSONerialization to parse data
                do {
                    //Data correctly parsed
                    let arrayOfDictionaries:[NSDictionary] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                    return arrayOfDictionaries
                }
                catch {
                    //Error parsing JSON data
                }
            }
            else {
                //NSData does not exist
            }
        }
        else {
            //Case where the path does not exist
        }
        return [NSDictionary]()
    }

}
