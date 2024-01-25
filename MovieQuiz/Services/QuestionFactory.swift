//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 09.01.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol  {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    
    private var previousIndexes = Set<Int>()
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement(),
        previousIndexes.count < questions.count else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        if previousIndexes.contains(index) {
            requestNextQuestion()
        } else {
            previousIndexes.insert(index)
            let question = questions[safe: index]
            delegate?.didReceiveNextQuestion(question: question)
        }
    }
    
    func resetPreviousIndexes() {
        previousIndexes.removeAll()
    }
}
