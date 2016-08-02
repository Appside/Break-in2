//
//  LogicalModel.swift
//  Break in2
//
//  Created by Sangeet on 17/01/2016.
//  Copyright © 2016 Sangeet Shah. All rights reserved.
//

import UIKit

class LogicalModel: NSObject {
  
  let logicalProblemTypes:[String] = ["basicShapes","shadedShapes","sizedShapes","insideShapes", "cornerShapes"]
  let shapeTypes:[String] = ["Circle","Square","Triangle","Octagon","Rhombus"]
  
  func getLogicalProblem() -> [[LogicalPictureView]] {
    
    let randomProblemNumber:Int = Int(arc4random_uniform(UInt32(self.logicalProblemTypes.count)))
    
    if self.logicalProblemTypes[randomProblemNumber] == "basicShapes" {
      return self.basicShapesProblem()
    }
    else if self.logicalProblemTypes[randomProblemNumber] == "shadedShapes" {
      return self.shadedShapesProblem()
    }
    else if self.logicalProblemTypes[randomProblemNumber] == "sizedShapes" {
      return self.sizedShapesProblem()
    }
    else if self.logicalProblemTypes[randomProblemNumber] == "insideShapes" {
      return self.insideShapesProblem()
    }
    else if self.logicalProblemTypes[randomProblemNumber] == "cornerShapes" {
      return self.cornerShapesProblem()
    }
    else {
      return [[LogicalPictureView]]()
    }
    
  }
  
  func initializeLogicalPictureViews() -> [[LogicalPictureView]] {
    
    var questionShapesArray:[Int] = [Int]()
    var answerShapesArray:[Int] = [Int]()
    var questionLogicalPictureArray:[LogicalPictureView] = [LogicalPictureView]()
    var answerLogicalPictureArray:[LogicalPictureView] = [LogicalPictureView]()
    
    while questionShapesArray.count < 4 {
      
      let randomShapeNumber:Int = Int(arc4random_uniform(UInt32(self.shapeTypes.count)))
      
      if !questionShapesArray.contains(randomShapeNumber) {
        questionShapesArray.append(randomShapeNumber)
      }
    }
    
    answerShapesArray.append(questionShapesArray[0])
    
    while answerShapesArray.count < 4 {
      
      let randomShapeNumber:Int = Int(arc4random_uniform(UInt32(self.shapeTypes.count)))
      
      if !(answerShapesArray[0] == randomShapeNumber) && !answerShapesArray.contains(randomShapeNumber) {
        answerShapesArray.append(randomShapeNumber)
      }
      
    }
    
    for index:Int in questionShapesArray {
      
      let logicalPictureViewAtIndex:LogicalPictureView = LogicalPictureView()
      
      logicalPictureViewAtIndex.shapeToDraw = [self.shapeTypes[index]]
      
      questionLogicalPictureArray.append(logicalPictureViewAtIndex)
      
    }
    for index:Int in answerShapesArray {
      
      let logicalPictureViewAtIndex:LogicalPictureView = LogicalPictureView()
      
      logicalPictureViewAtIndex.shapeToDraw = [self.shapeTypes[index]]
      
      answerLogicalPictureArray.append(logicalPictureViewAtIndex)
      
    }
    
    return [questionLogicalPictureArray,answerLogicalPictureArray]
  }
  
  func basicShapesProblem() -> [[LogicalPictureView]] {
    
    var logicalPictureViews:[[LogicalPictureView]] = self.initializeLogicalPictureViews()
    
    let randomShadedNumber:Int = Int(arc4random_uniform(2))
    
    if randomShadedNumber == 0 {
      
      logicalPictureViews[0][2].shapeToDraw = logicalPictureViews[0][0].shapeToDraw
      logicalPictureViews[0][3].shapeToDraw = logicalPictureViews[0][1].shapeToDraw
      
    }
    else if randomShadedNumber == 1 {
      
      logicalPictureViews[0][3].shapeToDraw = logicalPictureViews[0][0].shapeToDraw
      
      logicalPictureViews[1][0].shapeToDraw = logicalPictureViews[0][1].shapeToDraw
      
      var shapesArray:[String] = [String]()
      for pictureView in logicalPictureViews[1] {
        shapesArray.append(pictureView.shapeToDraw[0])
      }
      
      var randomAnswers:[String] = [String]()
      while randomAnswers.count < 4 {
        var shapeToDraw:String = String()
        shapeToDraw = self.shapeTypes[Int(arc4random_uniform(UInt32(self.shapeTypes.count)))]
        if !randomAnswers.contains(shapeToDraw) && shapeToDraw != logicalPictureViews[1][0].shapeToDraw[0] {
          randomAnswers.append(shapeToDraw)
        }
      }
      for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
        logicalPictureViews[1][i].shapeToDraw[0] = randomAnswers[i]
      }
      
    }
    
    return logicalPictureViews
    
  }
  
  func shadedShapesProblem() -> [[LogicalPictureView]] {
    
    var logicalPictureViews:[[LogicalPictureView]] = self.basicShapesProblem()
    
    let randomShadedNumber:Int = Int(arc4random_uniform(3))
    
    if randomShadedNumber == 0 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].isShaded = true
        logicalPictureViews[0][2].isShaded = true
      }
      else {
        logicalPictureViews[0][1].isShaded = true
        logicalPictureViews[0][3].isShaded = true
      }
      
      if logicalPictureViews[0][0].isShaded {
        logicalPictureViews[1][0].isShaded = true
      }
      
    }
    else if randomShadedNumber == 1 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].isShaded = true
        logicalPictureViews[0][1].isShaded = true
      }
      else {
        logicalPictureViews[0][2].isShaded = true
        logicalPictureViews[0][3].isShaded = true
      }
      
      if logicalPictureViews[0][0].isShaded {
        logicalPictureViews[1][0].isShaded = true
      }
      
    }
    else if randomShadedNumber == 2 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].isShaded = true
        logicalPictureViews[0][1].isShaded = true
        logicalPictureViews[0][2].isShaded = true
      }
      else {
        logicalPictureViews[0][1].isShaded = true
        logicalPictureViews[0][2].isShaded = true
        logicalPictureViews[0][3].isShaded = true
      }
      
    }
    
    for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
      
      let randomNumber2:Int = Int(arc4random_uniform(2))
      if randomNumber2 == 0 {
        logicalPictureViews[1][i].isShaded = true
      }
      
    }
    
    return logicalPictureViews
  }
  
  func sizedShapesProblem() -> [[LogicalPictureView]] {
    
    var logicalPictureViews:[[LogicalPictureView]] = self.basicShapesProblem()
    
    let randomSizeNumber:Int = Int(arc4random_uniform(3))
    
    if randomSizeNumber == 0 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].shapeSize = 3
        logicalPictureViews[0][2].shapeSize = 3
      }
      else {
        logicalPictureViews[0][1].shapeSize = 3
        logicalPictureViews[0][3].shapeSize = 3
      }
      
      logicalPictureViews[1][0].shapeSize = logicalPictureViews[0][0].shapeSize
      
    }
    else if randomSizeNumber == 1 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].shapeSize = 3
        logicalPictureViews[0][1].shapeSize = 2
        logicalPictureViews[0][3].shapeSize = 3
      }
      else {
        logicalPictureViews[0][1].shapeSize = 2
        logicalPictureViews[0][2].shapeSize = 3
      }
      
      logicalPictureViews[1][0].shapeSize = logicalPictureViews[0][1].shapeSize
      
    }
    else if randomSizeNumber == 2 {
      
      let randomNumber:Int = Int(arc4random_uniform(2))
      
      if randomNumber == 0 {
        logicalPictureViews[0][0].shapeSize = 3
        logicalPictureViews[0][1].shapeSize = 3
      }
      else {
        logicalPictureViews[0][2].shapeSize = 3
        logicalPictureViews[0][3].shapeSize = 3
      }
      
      logicalPictureViews[1][0].shapeSize = logicalPictureViews[0][0].shapeSize
      
    }
    
    for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
      
      let randomNumber2:Int = Int(arc4random_uniform(3))
      if randomNumber2 == 0 {
        logicalPictureViews[1][i].shapeSize = 1
      }
      else if randomNumber2 == 1 {
        logicalPictureViews[1][i].shapeSize = 2
      }
      else {
        logicalPictureViews[1][i].shapeSize = 3
      }
      
    }
    
    return logicalPictureViews
  }
  
  func insideShapesProblem() -> [[LogicalPictureView]] {
    
    var logicalPictureViews:[[LogicalPictureView]] = [[LogicalPictureView]]()
    var shapesArray:[String] = [String]()
    
    repeat {
      logicalPictureViews.removeAll()
      shapesArray.removeAll()
      logicalPictureViews = self.basicShapesProblem()
      for logicalPictureView in logicalPictureViews[0] {
        shapesArray.append(logicalPictureView.shapeToDraw[0])
      }
    } while shapesArray.contains("Triangle")
    
    let randomSizeOrderNumber:Int = Int(arc4random_uniform(2))
    
    if randomSizeOrderNumber == 0 {
      for i:Int in 0.stride(to: logicalPictureViews[0].count, by: 1) {
        var shapesToDrawArray:[String] = [String]()
        for j:Int in 0 .stride(to: 3, by: 1) {
          shapesToDrawArray.append(shapesArray[(i + j) % shapesArray.count])
        }
        logicalPictureViews[0][i].shapeToDraw = shapesToDrawArray
      }
      
      logicalPictureViews[1][0].shapeToDraw = logicalPictureViews[0][0].shapeToDraw
      
      var randomAnswers:[[String]] = [[String]]()
      while randomAnswers.count < 4 {
        var shapesToDrawArray:[String] = [String]()
        for index:Int in 0.stride(to: 3, by: 1) {
          shapesToDrawArray.append(shapesArray[Int(arc4random_uniform(UInt32(shapesArray.count)))])
        }
        if shapesToDrawArray != logicalPictureViews[1][0].shapeToDraw {
          randomAnswers.append(shapesToDrawArray)
        }
      }
      for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
        logicalPictureViews[1][i].shapeToDraw = randomAnswers[i]
      }
      
      return logicalPictureViews
      
    }
    else if randomSizeOrderNumber == 1 {
      
      for i:Int in 0.stride(to: logicalPictureViews[0].count, by: 1) {
        var shapesToDrawArray:[String] = [String]()
        for j:Int in ((logicalPictureViews[0].count - i) + 1).stride(to: (logicalPictureViews[0].count - i) - 2, by: -1) {
          shapesToDrawArray.append(shapesArray[j % shapesArray.count])
        }
        logicalPictureViews[0][i].shapeToDraw = shapesToDrawArray
      }
      
      logicalPictureViews[1][0].shapeToDraw = logicalPictureViews[0][0].shapeToDraw
      
      var randomAnswers:[[String]] = [[String]]()
      while randomAnswers.count < 4 {
        var shapesToDrawArray:[String] = [String]()
        for index:Int in 0.stride(to: 3, by: 1) {
          shapesToDrawArray.append(shapesArray[Int(arc4random_uniform(UInt32(shapesArray.count)))])
        }
        if shapesToDrawArray != logicalPictureViews[1][0].shapeToDraw {
          randomAnswers.append(shapesToDrawArray)
        }
      }
      for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
        logicalPictureViews[1][i].shapeToDraw = randomAnswers[i]
      }
      
      return logicalPictureViews
      
    }
    else {
      return [[LogicalPictureView]]()
    }
    
  }
  
  func cornerShapesProblem() -> [[LogicalPictureView]] {
    
    var logicalPictureViews:[[LogicalPictureView]] = self.shadedShapesProblem()
    var shapesArray:[String] = [String]()
    
    for logicalPictureView in logicalPictureViews[0] {
      shapesArray.append(logicalPictureView.shapeToDraw[0])
    }
    
    for i:Int in 0.stride(to: logicalPictureViews[0].count, by: 1) {
      var shapesToDrawArray:[String] = [String]()
      for j:Int in 0.stride(to: 4, by: 1) {
        shapesToDrawArray.append(shapesArray[(i + j) % shapesArray.count])
      }
      logicalPictureViews[0][i].shapeToDraw = shapesToDrawArray
    }
    
    logicalPictureViews[1][0].shapeToDraw = logicalPictureViews[0][0].shapeToDraw
    
    var randomAnswers:[[String]] = [[String]]()
    while randomAnswers.count < 4 {
      var shapesToDrawArray:[String] = [String]()
      for index:Int in 0.stride(to: 4, by: 1) {
        shapesToDrawArray.append(shapesArray[Int(arc4random_uniform(UInt32(shapesArray.count)))])
      }
      if shapesToDrawArray != logicalPictureViews[1][0].shapeToDraw {
        randomAnswers.append(shapesToDrawArray)
      }
    }
    for i:Int in 1.stride(to: logicalPictureViews[1].count, by: 1) {
      logicalPictureViews[1][i].shapeToDraw = randomAnswers[i]
    }
    
    let randomShapeOrderNumber:Int = Int(arc4random_uniform(1))
    
    if randomShapeOrderNumber == 0 {
      return logicalPictureViews
    }
    else {
      return [[LogicalPictureView]]()
    }
    
  }
  
}
