//
//  question.swift
//  Breakin2
//
//  Created by Jean-Charles Koch on 11/11/2015.
//  Copyright © 2015 Jean-Charles Koch. All rights reserved.
//

import UIKit

class sequencesList {
    
    var arithmeticReason:Int = Int()
    var geometricReason:Int = Int()
    var sequenceFirstTerm:Int = Int()
    var increment1:Int = Int()
    var increment2:Int = Int()
    var memory1:Int = Int()
    var memory2:Int = Int()
    
    func runSequence(_ sequenceNB:Int, initialNumber:Int) -> Int {
        
        var returnInt:Int = Int()
        
        if sequenceNB==1 {
            returnInt = self.fibonacciSequence(initialNumber)
        }
        if sequenceNB==2 {
            returnInt = self.arithmeticSequence(initialNumber)
        }
        if sequenceNB==3 {
            returnInt = self.geometricSequence(initialNumber)
        }
        if sequenceNB==4 {
            returnInt = self.squareSequence(initialNumber)
        }
        if sequenceNB==5 {
            returnInt = self.primeNumberSequence(initialNumber)
        }
        if sequenceNB==6 {
            returnInt = self.fixedStepsSequence(initialNumber)
        }
        return returnInt
        
    }
    
    func addFeedback(_ sequenceNB:Int) -> String {
        
        var feedbackString:String = String()
        
        if sequenceNB==1 {
            feedbackString = "The terms in this sequence are Fibonacci numbers, meaning that each number in the sequence is equal to the sum of the two previous numbers."
        } else if sequenceNB==2 {
            feedbackString = "This sequence follows an arithmetic progression, which means that the difference between two consecutive numbers is equal to \(self.arithmeticReason)."
        } else if sequenceNB==3 {
            feedbackString = "This sequence follows a geometric progression, which means that the initial value of \(self.sequenceFirstTerm), is either multiplied or divided by the common ratio of \(self.geometricReason)."
        } else if sequenceNB==4 {
            feedbackString = "This sequence represents the squared numbers of consecutive integers."
        } else if sequenceNB==5 {
            feedbackString = "This is a sequence of consecutive prime numbers."
        } else if sequenceNB==6 {
            feedbackString = "The numbers in this sequence, increase by \(self.increment1) and \(self.increment2), alternatively."
        }
        
        return feedbackString
        
    }
    
    func fibonacciSequence(_ requestedIndex:Int) -> Int {
        
        let alpha:Float = 1/sqrt(5)
        let beta:Float = -1*alpha
        let phi1:Float = (1+sqrt(5))/2
        let phi2:Float = (-1/phi1)
        let returnNumber:Float = alpha * powf(phi1, Float(requestedIndex)) + beta * powf(phi2, Float(requestedIndex))
        
        return Int(returnNumber)
    
    }
    
    func arithmeticSequence(_ requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(requestIndex * self.arithmeticReason)
        
        return returnNumber
        
    }
    
    func geometricSequence(_ requestIndex:Int) -> Int {
        
        let returnNumber:Int = Int(Float(self.sequenceFirstTerm) * powf(Float(self.geometricReason), Float(requestIndex)))
        
        return returnNumber
        
    }
    
    func squareSequence(_ requestIndex:Int) -> Int {
        
        let returnNumber:Int = requestIndex * requestIndex
        return returnNumber
        
    }
    
    func primeNumberSequence(_ requestIndex:Int) -> Int {
        
        var prime: Int
        var isPrime: Bool
        var counter = 0
        for (prime = 2;  prime <= 50 && counter < requestIndex;  prime += 1 )
        {
            isPrime = true;
          for divisor:Int in stride(from: 2, to: prime, by: 1)
            {
                if ((prime % divisor) == 0 )
                {
                    isPrime = false
                }
            }
            if (isPrime)
            {
                counter += 1
            }
        }
        
        return prime-1
        
    }
    
    func fixedStepsSequence(_ requestIndex:Int) -> Int {
        
        var returnNumber:Int = Int()
        
        if (self.memory1 == 0) {
            returnNumber = requestIndex
        }
        if self.memory1 == 1 {
            returnNumber = self.memory2 + self.increment1
        }
        if self.memory1 == -1 {
            returnNumber = self.memory2 + self.increment2
        }
        
        
        return returnNumber
        
    }

}
