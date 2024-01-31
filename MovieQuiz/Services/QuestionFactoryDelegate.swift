//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 15.01.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {// 1
    
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
} 
