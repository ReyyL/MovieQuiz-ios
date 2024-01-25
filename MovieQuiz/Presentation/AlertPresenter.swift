//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 16.01.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, // заголовок всплывающего окна
                                      message: alertModel.message, // текст во всплывающем окне
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
          // код, который сбрасывает игру и показывает первый вопрос

            alertModel.completion()
        }
        alert.addAction(action)

        // показываем всплывающее окно
        delegate?.present(alert, animated: true, completion: nil)
    }
}

