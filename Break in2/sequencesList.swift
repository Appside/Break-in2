//
//  question.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class sequencesList {
    
    var sequenceReason:Int = Int()
    var sequenceFirstTerm:Int = Int()
    
    func runSequence(sequenceNB:Int, initialNumber:Int) -> Int {
        
        var returnInt:Int = Int()
        
        if sequenceNB==1 {
            returnInt = self.fibonacciSequence(initialNumber)
        }
        if sequenceNB==2 {
            returnInt = self.arithmeticSequence(initialNumber)
        }
        if sequenceNB==3 {
            returnInt = self.arithmeticSequence(initialNumber)
        }
        
        return returnInt
        
    }
    
    func addFeedback(sequenceNB:Int) -> String {
        
        var feedbackString:String = String()
        
        if sequenceNB==1 {
            feedbackString = "The terms in this sequence are Fibonacci numbers, meaning that each number in the sequence is equal to the sum of the two previous numbers."
        } else if sequenceNB==2 {
            feedbackString = "This sequence follows an arithmetic progression, the common difference of successive numbers being equal to \(self.sequenceReason)."
        } else if sequenceNB==3 {
            feedbackString = "This sequence follows a geometric progression with initial value \(self.sequenceFirstTerm) and common ratio \(self.sequenceReason)."
        }
        
        return feedbackString
        
    }
    
    func fibonacciSequence(requestedIndex:Int) -> Int {
        
        let alpha:Float = 1/sqrt(5)
        let beta:Float = -1*alpha
        let phi1:Float = (1+sqrt(5))/2
        let phi2:Float = (-1/phi1)
        let returnNumber:Float = alpha * powf(phi1, Float(requestedIndex)) + beta * powf(phi2, Float(requestedIndex))
        
        return Int(returnNumber)
    
    }
    
    func arithmeticSequence(requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(requestIndex * self.sequenceReason)
        
        return returnNumber
        
    }
    
    func geometricSequence(requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(Float(self.sequenceFirstTerm) * powf(Float(self.sequenceReason), Float(requestIndex)))
        
        return returnNumber
        
    }

}