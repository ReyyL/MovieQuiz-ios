//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 09.01.2024.
//

import UIKit

struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
