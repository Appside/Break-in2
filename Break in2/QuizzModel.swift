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
            newQuestion.category = currentJsonDictionary["category"] as! String
            newQuestion.subCategory = currentJsonDictionary["subcategory"] as! String
            newQuestion.questionType = currentJsonDictionary["type"] as! String
            newQuestion.questionText = currentJsonDictionary["question"] as! String
            newQuestion.chartDescription = currentJsonDictionary["chart"] as! String
            newQuestion.answersText = currentJsonDictionary["answers"] as! [String]
            newQuestion.correctAnswerInt = currentJsonDictionary["correctAnswer"] as! Int
            newQuestion.solutionString = currentJsonDictionary["answerExplanation"] as! String
            //Add the new Question to the returned array
            arrayOfQuestions.append(newQuestion)
        }
        
        //Return final array
        return arrayOfQuestions
    }
    
    func getjsonfile() -> [NSDictionary] {
     
        //Define JSon file URL
        let fileBundlePath:String? = NSBundle.mainBundle().pathForResource("questiondata", ofType: "json")
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
