//
//  Constants.swift
//  Break in2
//
//  Created by Jonathan Crawford on 24/11/2015.
//  Copyright © 2015 Appside. All rights reserved.
//

import UIKit

/* User class in Parse*/
let PF_USER_CLASS_NAME					= "_User"                   //	Class name
let PF_USER_OBJECTID					= "objectId"				//	String
let PF_USER_USERNAME					= "username"				//	String
let PF_USER_PASSWORD					= "password"				//	String
let PF_USER_EMAIL						= "email"                   //	String
let PF_USER_EMAILCOPY					= "emailCopy"               //	String
let PF_USER_FULLNAME					= "fullname"				//	String
let PF_USER_FULLNAME_LOWER				= "fullname_lower"          //	String
let PF_USER_FACEBOOKID					= "facebookId"              //	String
let PF_USER_PICTURE						= "picture"                 //	File
let PF_USER_THUMBNAIL					= "thumbnail"               //	File
let PF_USER_CAREERPREFS                 = "careerPrefs"             //	Array
let PF_USER_MEMBERSHIP                  = "Membership"              //  String
let PF_USER_NUMBER_LIVES                = "Lives"                   //  Number

/* Analytics class in Parse*/
let PF_ANALYTICS_CLASS_NAME				= "Analytics"				//	Class name
let PF_ANALYTICS_USER					= "user"					//	Pointer to User Class
let PF_ANALYTICS_CREATED				= "createdAt"               //	Date
let PF_ANALYTICS_TIME                   = "time"                    //	Number
let PF_ANALYTICS_USERNAME				= "username"				//	String
let PF_ANALYTICS_CAREER                 = "career"                  //	String
let PF_ANALYTICS_TEST                   = "test"                    //	String
let PF_ANALYTICS_SCORE                  = "score"                   //	Number

/* Numerical Reasoning class in Parse*/
let PF_NUMREAS_CLASS_NAME				= "Numerical_Reasoning"		//	Class name
let PF_NUMREAS_USER                     = "user"					//	Pointer to User Class
let PF_NUMREAS_CREATED                  = "createdAt"               //	Date
let PF_NUMREAS_TIME                     = "time"                    //	Number
let PF_NUMREAS_USERNAME                 = "username"				//	String
let PF_NUMREAS_TEST                     = "test"                    //	String
let PF_NUMREAS_SCORE                    = "score"                   //	Number

/* Verbal Reasoning class in Parse*/
let PF_VERBREAS_CLASS_NAME				= "Verbal_Reasoning"		//	Class name
let PF_VERBREAS_USER                    = "user"					//	Pointer to User Class
let PF_VERBREAS_CREATED                 = "createdAt"               //	Date
let PF_VERBREAS_TIME                    = "time"                    //	Number
let PF_VERBREAS_USERNAME                = "username"				//	String
let PF_VERBREAS_TEST                    = "test"                    //	String
let PF_VERBREAS_SCORE                   = "score"                   //	Number

/* Arithmetic class in Parse*/
let PF_ARITHMETIC_CLASS_NAME            = "Arithmetic"              //	Class name
let PF_ARITHMETIC_USER                  = "user"					//	Pointer to User Class
let PF_ARITHMETIC_CREATED               = "createdAt"               //	Date
let PF_ARITHMETIC_TIME                  = "time"                    //	Number
let PF_ARITHMETIC_USERNAME              = "username"				//	String
let PF_ARITHMETIC_TEST                  = "test"                    //	String
let PF_ARITHMETIC_SCORE                 = "score"                   //	Number

/* Fractions class in Parse*/
let PF_FRACTIONS_CLASS_NAME             = "Fractions"               //	Class name
let PF_FRACTIONS_USER                   = "user"					//	Pointer to User Class
let PF_FRACTIONS_CREATED                = "createdAt"               //	Date
let PF_FRACTIONS_TIME                   = "time"                    //	Number
let PF_FRACTIONS_USERNAME               = "username"				//	String
let PF_FRACTIONS_TEST                   = "test"                    //	String
let PF_FRACTIONS_SCORE                  = "score"                   //	Number

/* Logical class in Parse*/
let PF_LOGICAL_CLASS_NAME               = "Logical_Reasoning"       //	Class name
let PF_LOGICAL_USER                     = "user"					//	Pointer to User Class
let PF_LOGICAL_CREATED                  = "createdAt"               //	Date
let PF_LOGICAL_TIME                     = "time"                    //	Number
let PF_LOGICAL_USERNAME                 = "username"				//	String
let PF_LOGICAL_TEST                     = "test"                    //	String
let PF_LOGICAL_SCORE                    = "score"                   //	Number

/* Sequences class in Parse*/
let PF_SEQUENCE_CLASS_NAME              = "Sequences"               //	Class name
let PF_SEQUENCE_USER                    = "user"					//	Pointer to User Class
let PF_SEQUENCE_CREATED                 = "createdAt"               //	Date
let PF_SEQUENCE_TIME                    = "time"                    //	Number
let PF_SEQUENCE_USERNAME                = "username"				//	String
let PF_SEQUENCE_TEST                    = "test"                    //	String
let PF_SEQUENCE_SCORE                   = "score"                   //	Number

/* Preferences class in Parse*/
let PF_PREFERENCES_CLASS_NAME           = "Preferences"             //	Class name
let PF_PREFERENCES_USER                 = "user"					//	Pointer to User Class
let PF_PREFERENCES_CREATED              = "createdAt"               //	Date
let PF_PREFERENCES_TIME                 = "time"                    //	Number
let PF_PREFERENCES_USERNAME             = "username"				//	String
let PF_PREFERENCES_CAREERPREFS          = "careerPrefs"             //	Array

/* Test voting class in Parse*/
let PF_TESTVOTE_CLASS_NAME              = "New_Test_Vote"           //	Class name
let PF_TESTVOTE_CREATED                 = "createdAt"               //	Date
let PF_TESTVOTE_VOTES                   = "votes"                   //	Number
let PF_TESTVOTE_CAREER                  = "career"                  //	String
let PF_TESTVOTE_TEST                    = "test"                    //	String

/* Brain Breaker Question class in Parse */
let PF_BRAINBREAKER_Q_CLASS_NAME        = "Brain_Breaker_Q"         //	Class name
let PF_BRAINBREAKER_Q_CREATED           = "createdAt"               //	Date
let PF_BRAINBREAKER_Q_QUESTION_TYPE     = "questionType"            //	String
let PF_BRAINBREAKER_Q_QUESTION          = "question"                //	String
let PF_BRAINBREAKER_Q_PASSAGE           = "passage"                 //	String
let PF_BRAINBREAKER_Q_ANSWERS           = "answers"                 //  Array
let PF_BRAINBREAKER_Q_CORRECT_ANSWER    = "correctAnswerIndex"      //  Number
let PF_BRAINBREAKER_Q_EXPLANATION       = "explanation"             //  String
let PF_BRAINBREAKER_Q_Q_NUMBER          = "questionNumber"          //  Number
let PF_BRAINBREAKER_Q_EXPIRATION_DATE   = "expirationDate"          //  Date
let PF_BRAINBREAKER_Q_TEST_PRIZE        = "testPrize"               //  String
let PF_BRAINBREAKER_Q_TIME_REQUIRED     = "timeRequiredMinutes"     //  Number

/* Brain Breaker Answer class in Parse */
let PF_BRAINBREAKER_A_CLASS_NAME		= "Brain_Breaker_A"         //	Class name
let PF_BRAINBREAKER_A_USER              = "user"					//	Pointer to User Class
let PF_BRAINBREAKER_A_USERNAME			= "username"				//	String
let PF_BRAINBREAKER_A_EMAIL				= "email"                   //	String
let PF_BRAINBREAKER_A_FULLNAME			= "fullname"				//	String
let PF_BRAINBREAKER_A_ANSWER_CORRECT    = "answerCorrect"           //  Number
let PF_BRAINBREAKER_A_Q_NUMBER          = "questionNumber"            //  Number

