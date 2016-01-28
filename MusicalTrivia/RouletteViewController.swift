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
    
    @IBOutlet var noteScoreImages: [UIImageView]!
    @IBOutlet weak var timerColorView: UIView!
    
    var currentQuestion = 0
    var timerStopped = false
    
    var questionAsker = false
    var questionController: MusicNotationViewController?
    var counter = 10.0
    var header: RouletteHeaderViewController?
    var delegate: StandardDelegate?
    
    var score = [0, 0]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        noteScoreImages.sortInPlace { $0.0.tag < $0.1.tag }
        clearScore()
        containerView.hidden = true
        activityIndicator.startAnimating()
        Connection.sharedInstance.requestNewGame(self)
        header!.setScore(score)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedStaffNotation" {
            questionController = segue.destinationViewController as? MusicNotationViewController
            questionController?.delegate = self
        } else if segue.identifier == "EmbedRouletteHeader" {
            header = segue.destinationViewController as? RouletteHeaderViewController
        }
    }
    func clearScore()
    {
        for uiImage in noteScoreImages {
            uiImage.image = nil
        }
    }
    func gameStarted(questionAsker: Bool, opponent: String)
    {
        activityIndicator.stopAnimating()
        containerView.hidden = false
        waitingForOpponentLabel.hidden = true
        activityIndicator.hidden = true
        header?.opponentNameLabel.text = opponent
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
        Connection.sharedInstance.sendAnswerResult(correct, timeLeft: counter, controller: self)
        counter = 10
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
    func answerResultsReceived(results: [Int])
    {
        let image = noteScoreImages[currentQuestion]
        let imageName: String
        switch (results[0], results[1]) {
        case (0, 0):
            imageName = "quarter-rest.png"
        case (0, 3):
            imageName = "whole-rest.png"
        case (3, 0):
            imageName = "whole-note-score.png"
        case (1, 2):
            imageName = "quarter-note.png"
        case (2, 1):
            imageName = "half-note.png"
        default:
            imageName = "broken"
            print("results: \(results)")
        }
        image.image = UIImage(named: imageName)
        score[0] += results[0]
        score[1] += results[1]
        header?.setScore(score)
        
        ++currentQuestion
        if !questionAsker {
            return
        }
        if currentQuestion < 7 {
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "makeNewQuestion", userInfo: nil, repeats: false)
        } else {
            gameOverAlert()
        }
    }
    func gameOverAlert()
    {
        let won = score[0] > score[1] ? "Won" : "Lost"
        let message = "Final Score: \(score[0]) - \(score[1])"
        let alert = UIAlertController(title: "You \(won)!", message: message, preferredStyle:  .Alert)
        alert.addAction(UIAlertAction(title: "Back to Menu", style: .Default) {
            UIAlertAction in
            self.delegate?.dismissView()
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    func startTimer()
    {
        timerStopped = false
        runTimer()
    }
    func runTimer()
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
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "runTimer", userInfo: nil, repeats: false)
    }
    func stopTimer()
    {
        timerStopped = true
    }
}
