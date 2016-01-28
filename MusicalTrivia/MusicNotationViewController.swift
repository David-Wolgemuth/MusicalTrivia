//
//  ViewController.swift
//  MusicalNotation
//
//  Created by David Wolgemuth on 1/22/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

protocol NotationDelegate
{
    func playerAnswered(answerCorrect correct: Bool)
    func startTimer()
    func stopTimer()
}

enum Answer {
    case Unanswered
    case Correct
    case Incorrect
}

typealias QuestionTuple = (type: String, answer: AnyObject, choices: [String])

class MusicNotationViewController: UIViewController
{
    // General Constants
    let rowHeight = 82
    let offsetX = 280
    let spaceX = 60
    var delegate: NotationDelegate?
    var answered = Answer.Unanswered
    
    var currentAnswer: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for button in AnswerButtons {
            button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func buttonClicked(sender: UIButton!)
    {
        if answered != .Unanswered {
            return
        }
        if sender.titleLabel?.text == currentAnswer {
            sender.backgroundColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            answered = .Correct
        } else {
            sender.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0.7, alpha: 1)
            showAnswer()
            answered = .Incorrect
        }
        let correct = answered == .Correct
        delegate?.playerAnswered(answerCorrect: correct)
    }
    
    func showAnswer()
    {
        delegate?.stopTimer()
        for button in AnswerButtons {
            if button.titleLabel?.text == currentAnswer {
                button.backgroundColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            }
        }
    }
    func toggleButtons(on: Bool)
    {
        for button in AnswerButtons {
            button.hidden = !on
        }
    }
    
    @IBOutlet weak var staffImage: UIImageView!
    
    @IBOutlet var AnswerButtons: [UIButton]!
    
    func newQuestion() -> (type: String, answer: AnyObject, choices: [String])
    {
        toggleButtons(false)
        answered = .Unanswered
        
        let question: QuestionTuple
        
        switch arc4random_uniform(3) {
        case 0:
            question = newScaleQuestion()
            let scale = question.answer as! Scale
            createStaffImage(withScale: scale, triad: nil)
        case 1:
            question = newTriadQuestion()
            let triad = question.answer as! Triad
            createStaffImage(withScale: triad.scale, triad: triad)
        case 2:
            question = newIntervalQuestion()
            let interval = question.answer as! Interval
            let start = interval.startNote
            let end = start + interval.interval
            staffImage.image = UIImage(named: "headphones.png")
            AudioPlayer.sharedInstance.playInterval(from: start, to: end)
        default:
            print("This Should Never Print")
            question = ("Error", "", ["huh?"])
        }
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "startTimer", userInfo: nil, repeats: false)
        return question
    }
    func displayQuestion(question: QuestionTuple)
    {
        toggleButtons(false)
        answered = .Unanswered
        
        let answer = question.answer as! [String: AnyObject]
        switch question.type {
        case "scale":
            let scale = Scale.initFromJSON(answer)
            currentAnswer = scale.description
            createStaffImage(withScale: scale, triad: nil)
        case "triad":
            let triad = Triad.initFromJSON(answer)
            currentAnswer = triad.description
            createStaffImage(withScale: triad.scale, triad: triad)
        case "interval":
            let interval = Interval.initFromJSON(answer)
            currentAnswer = interval.name
            let start = interval.startNote
            let end = start + interval.interval
            staffImage.image = UIImage(named: "headphones.png")
            AudioPlayer.sharedInstance.playInterval(from: start, to: end)
        default:
            currentAnswer = "Something Bad Happened"
            break
        }
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "startTimer", userInfo: nil, repeats: false)
        setButtonsAndAnswer(question.choices)
        
    }
    func startTimer()
    {
        toggleButtons(true)
        delegate?.startTimer()
    }
    func newScaleQuestion() -> QuestionTuple
    {
        var scales = [Scale]()
        while scales.count < 4 {
            let scaleA = Scale.random(isIonian: false)
            var isUnique = true
            for scaleB in scales {
                if scaleA.ionianRoot == scaleB.ionianRoot {
                    isUnique = false
                }
            }
            if isUnique {
                scales.append(scaleA)
            }
        }
        
        var answers = [String]()
        for scale in scales {
            answers.append(scale.description)
        }
        currentAnswer = scales[0].description
        setButtonsAndAnswer(answers)
        return ("scale", scales[0], answers)
    }
    func newIntervalQuestion() -> QuestionTuple
    {
        let answer = Interval.random()
        var intervals = [answer.name]
        while intervals.count < 4 {
            let interval = Interval.random()
            var isUnique = true
            for intA in intervals {
                if intA == interval.name {
                    isUnique = false
                }
            }
            if isUnique {
                intervals.append(interval.name)
            }
        }
        
        currentAnswer = answer.name
        setButtonsAndAnswer(intervals)
        return ("interval", answer, intervals)
    }
    func newTriadQuestion() -> QuestionTuple
    {
        // Create 4 Unique Triads
        var triads = [Triad]()
        while triads.count < 4 {
            let triA = Triad.random()
            var isUnique = true
            for triB in triads {
                if triA.description == triB.description {
                    isUnique = false
                }
            }
            if isUnique {
                triads.append(triA)
            }
        }

        var answers = [String]()
        for triad in triads {
            answers.append(triad.description)
        }
        currentAnswer = triads[0].description
        setButtonsAndAnswer(answers)
        return ("triad", triads[0], answers)
    }
    func setButtonsAndAnswer(var possibleAnswers: [String])
    {
        possibleAnswers.sortInPlace {_, _ in arc4random() % 2 == 0}
        
        // Set Buttons With Triad Names
        for i in 0..<AnswerButtons.count {
            let answer = possibleAnswers[i]
            AnswerButtons[i].setTitle(answer, forState: .Normal)
            AnswerButtons[i].backgroundColor = UIColor(white: 255, alpha: 0)
        }
    }
    func createStaffImage(withScale scale: Scale?, triad: Triad?)
    {
        // Grab Images
        let staff = UIImage(named: "staff.jpg")!
        
        // Draw Background Staff
        let newSize = CGSizeMake(1024, 768)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        staff.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        
        if scale != nil {
            placeSharpsAndFlatsOnStaff(scale!)
        }
        if triad != nil {
            placeTriadOnStaff(triad!)
        }
        
        // Save and Set Image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        staffImage.image = image
        
    }
    func placeSharpsAndFlatsOnStaff(scale: Scale)
    {
        let sharp = UIImage(named: "sharp")!
        let flat = UIImage(named: "flat")!

        // Place Sharps
        let sharpHeight = 180
        let sharpRatio = 40.0 / 106.0
        let sharpOffsetY = 300
        let sharpWidth = Int(Double(sharpHeight)  * sharpRatio)
        for i in 0..<scale.sharps.count {
            let y = sharpOffsetY - (scale.sharps[i] * rowHeight / 2)
            let x = offsetX + (i * spaceX)
            sharp.drawInRect(CGRect(x: x, y: y, width: sharpWidth, height: sharpHeight))
        }
        
        //Place Flats
        let flatHeight = 220
        let flatRatio = 40.0 / 130.0
        let flatWidth = Int(Double(flatHeight) * flatRatio)
        let flatOffsetY = 240
        for i in 0..<scale.flats.count {
            let y = flatOffsetY - (scale.flats[i] * rowHeight / 2)
            let x = offsetX + (i * spaceX)
            flat.drawInRect(CGRect(x: x, y: y, width: flatWidth, height: flatHeight))
        }
    }
    func placeTriadOnStaff(triad: Triad)
    {
        // Grab Images
        let noteImage = UIImage(named: "whole-note")!
        
        // Place Notes
        let noteHeight = 86
        let noteRatio = 92.0 / 65.0
        let noteWidth = Int(Double(noteHeight) * noteRatio)
        for i in 0..<triad.notes.count {
            let note = triad.notes[i]
            let y = 340 - ((note.position + ((note.octave-3) * 7)) * rowHeight / 2)
            let x = offsetX + (triad.scale.sharps.count + triad.scale.flats.count + 2) * spaceX
            noteImage.drawInRect(CGRect(x: x, y: y, width: noteWidth, height: noteHeight))
        }
    }
    
}