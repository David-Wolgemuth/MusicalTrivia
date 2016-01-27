//
//  RouletteViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/26/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class RouletteViewController: UIViewController, NotationDelegate
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingForOpponentLabel: UILabel!
    
    @IBOutlet weak var timerColorView: UIView!
    
    var currentQuestion = 0
    var timerStopped = false
    
    @IBAction func tempNewQuestionButton(sender: UIButton)
    {
        if questionAsker {
            makeNewQuestion()
        }
    }
    var questionAsker = false
    var questionController: MusicNotationViewController?
    var counter = 10.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        containerView.hidden = true
        activityIndicator.startAnimating()
        Connection.sharedInstance.requestNewGame(self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedStaffNotation" {
            questionController = segue.destinationViewController as? MusicNotationViewController
            questionController?.delegate = self
        }
    }
    func gameStarted(questionAsker: Bool)
    {
        activityIndicator.stopAnimating()
        containerView.hidden = false
        waitingForOpponentLabel.hidden = true
        activityIndicator.hidden = true
        self.questionAsker = questionAsker
        if questionAsker {
            makeNewQuestion()
        } else {
            Connection.sharedInstance.listenForQuestions(self)
        }
    }
    func playerAnswered(answerCorrect correct: Bool)
    {
        timerStopped = true
        Connection.sharedInstance.sendAnswerResult(correct, timeLeft: counter)
        if !questionAsker {
            return
        }
        ++currentQuestion
        if currentQuestion < 7 {
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: <#T##AnyObject#>, selector: <#T##Selector#>, userInfo: <#T##AnyObject?#>, repeats: <#T##Bool#>)
        }
    }
    func makeNewQuestion()
    {
        let question = questionController?.newQuestion()
        Connection.sharedInstance.sendNewQuestion(self, question: question!)
    }
    func incomingQuestion(question: QuestionTuple)
    {
        questionController?.displayQuestion(question)
    }
    func startTimer()
    {
        if timerStopped {
            return
        }
        if counter > 0 {
            counter -= 0.15
        } else {
            playerAnswered(answerCorrect: false)
            questionController?.showAnswer()
        }
        let alpha = CGFloat((10 - counter) * 0.1)
        timerColorView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: alpha)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "startTimer", userInfo: nil, repeats: false)
    }
    func stopTimer()
    {
        print("No Timer To Stop")
    }
}
