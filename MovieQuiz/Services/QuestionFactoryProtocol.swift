//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 15.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    func requestNextQuestion()
    
    func resetPreviousIndexes()
    
    var delegate: QuestionFactoryDelegate? { get set }
    
}
