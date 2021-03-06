//
//  SinglePlayerViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/26/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class SinglePlayerViewController: UIViewController, NotationDelegate
{
    @IBOutlet var noteScoreImages: [UIImageView]!
    
    var delegate: StandardDelegate?
    var currentQuestion = 0
    var questionController: MusicNotationViewController?
    @IBOutlet weak var timerColorView: UIView!
    var counter = 10.0
    var correctCount = 0
    var timerStopped = false
    
    override func viewDidLoad()
    {
        noteScoreImages.sortInPlace { $0.0.tag < $0.1.tag }
        clearScore()
        questionController?.newQuestion()
    }
    
    @IBAction func leaveGamePressed(sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Leave Game?", message: "All Progress Will Be Lost", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave Game", style: .Destructive) {
            UIAlertAction in
            self.timerStopped = true
            self.delegate?.dismissView()
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "EmbedStaffNotation" {
            questionController = segue.destinationViewController as?MusicNotationViewController
            questionController?.delegate = self
        }
    }
    func clearScore()
    {
        for uiImage in noteScoreImages {
            uiImage.image = nil
        }
        correctCount = 0
    }
    func askForNewQuestion()
    {
        let alpha = CGFloat((10 - counter) * 0.1)
        timerStopped = false
        timerColorView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: alpha)
        questionController?.newQuestion()
    }
    func playerAnswered(answerCorrect correct: Bool)
    {
        UserData.incrementQuestionsAnswered(answerIsCorrect: correct)
        
        timerStopped = true
        let image = noteScoreImages[currentQuestion]
        
        if correct {
            ++correctCount
            let points: Int
            if counter > 8 {
                points = 3
                image.image = UIImage(named: "whole-note-score.png")
            } else if counter > 6.5 {
                points = 2
                image.image = UIImage(named: "half-note.png")
            } else {
                points = 1
                image.image = UIImage(named: "quarter-note.png")
            }
            UserData.addPoints(points)
        } else {
            if counter <= 0 {
                image.image = UIImage(named: "whole-rest.png")
            } else {
                image.image = UIImage(named: "quarter-rest.png")
            }
        }
        ++currentQuestion
        counter = 10
        if currentQuestion < 7 {
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "askForNewQuestion", userInfo: nil, repeats: false)
        } else {
            gameOverAlert()
        }
    }
    func gameOverAlert()
    {
        let plural = correctCount != 1 ? "s" : ""
        let title = correctCount == 7 ? "Amazing!" : "Game Over"
        let message = "\(correctCount) Question\(plural) Correctly Answered!"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Menu", style: .Default) {
            UIAlertAction in
            self.delegate?.dismissView()
        })
        alert.addAction(UIAlertAction(title: "New Game", style: .Default) {
            UIAlertAction in
            self.resetGame()
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func resetGame()
    {
        currentQuestion = 0
        clearScore()
        askForNewQuestion()
    }
    func stopTimer()
    {
        timerStopped = true
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
        if currentQuestion < 7 {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "startTimer", userInfo: nil, repeats: false)
        }
    }
}
