//
//  ViewController.swift
//  MusicalNotation
//
//  Created by David Wolgemuth on 1/22/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit


class MusicNotationViewController: UIViewController
{
    // General Constants
    let rowHeight = 82
    let offsetX = 280
    let spaceX = 60
    
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
        if sender.titleLabel?.text == currentAnswer {
            print("Correct!")
        } else {
            print("Incorrect!")
        }
    }
    
    @IBOutlet weak var staffImage: UIImageView!
    
    @IBOutlet var AnswerButtons: [UIButton]!
    
    func newQuestion()
    {
        if arc4random_uniform(2) == 1 {
            let scale = newScaleQuestion()
            createStaffImage(withScale: scale, triad: nil)
        } else {
            let triad = newTriadQuestion()
            createStaffImage(withScale: triad.scale, triad: triad)
        }
    }
    func newScaleQuestion() -> Scale
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
        return scales[0]
    }
    func newTriadQuestion() -> Triad
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
        return triads[0]
    }
    func setButtonsAndAnswer(var possibleAnswers: [String])
    {
        possibleAnswers.sortInPlace {_, _ in arc4random() % 2 == 0}
        
        // Set Buttons With Triad Names
        for i in 0..<AnswerButtons.count {
            let answer = possibleAnswers[i]
            AnswerButtons[i].setTitle(answer, forState: .Normal)
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