import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate   {
    // MARK: - Lifecycle
    
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alert = AlertPresenter()
    private let statisticService: StatisticService = StatisticServiceImplementation()
    
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var buttonYes: UIButton!
    
    @IBOutlet private weak var buttonNo: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = !currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Actions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        alert.delegate = self
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    // MARK: - Private functions
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Any) {
        guard let errorMessage = error as? String
                ?? (error as? Error)?.localizedDescription else {
            return
        }
        showNetworkError(message: errorMessage)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        
        // создайте и покажите алерт
        let model = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        
        alert.showAlert(model)
        
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      // Попробуйте написать код конвертации самостоятельно
        
        let questionStep = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                      question: model.text,
                                      questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
      // попробуйте написать код показа на экран самостоятельно
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
       // метод красит рамку
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20// толщина рамки
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        buttonYes.isEnabled = false
        buttonNo.isEnabled = false
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self else { return }
           // код, который мы хотим вызвать через 1 секунду
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            self.buttonYes.isEnabled = true
            self.buttonNo.isEnabled = true
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questionsAmount - 1 { // 1
        // идём в состояние "Результат квиза"
          // константа с кнопкой для системного алерта
          questionFactory?.resetPreviousIndexes()
          
          statisticService.store(correct: correctAnswers, total: questionsAmount)
          
          let total = statisticService.gamesCount
          let accuracy = statisticService.totalAccuracy
          let bestGame = statisticService.bestGame
          
          let text = """
              Ваш результат: \(correctAnswers)/\(questionsAmount)
              Количество сыгранных квизов: \(total)
              Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
              Средняя точность: \(String(format: "%.2f", accuracy * 100))%
          """
          
          let alertModel = AlertModel(title: "Этот раунд окончен!",
                                      message: text,
                                      buttonText: "Сыграть еще раз",
                                      completion: { [weak self] in
              self?.resetQuiz() }
          )
          alert.showAlert(alertModel)
          
      } else { // 2
          currentQuestionIndex += 1
          questionFactory?.requestNextQuestion()
      }
        // идём в состояние "Вопрос показан"
    }
    
    private func resetQuiz() {
        
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
