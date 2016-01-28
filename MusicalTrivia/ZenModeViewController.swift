//
//  ZenModeViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

protocol StandardDelegate
{
    func dismissView()
}

class ZenModeViewController: UIViewController, StandardDelegate, NotationDelegate
{
    var delegate: StandardDelegate?
    var game: Game?
    var questionController: MusicNotationViewController?
    
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem)
    {
        delegate?.dismissView()
    }
    @IBOutlet weak var bottomNavBar: UINavigationItem!
    @IBAction func newQuestionPressed(sender: AnyObject)
    {
        bottomNavBar.title = ""
        questionController?.newQuestion()
    }
    override func viewDidLoad()
    {
        game = Game()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowSettings" {
            let controller = segue.destinationViewController as! ZenModeSettingsTableViewController
            controller.game = self.game
            controller.delegate = self
        } else if segue.identifier == "EmbedStaffNotation" {
            questionController = segue.destinationViewController as? MusicNotationViewController
            questionController?.delegate = self
        }
    }
    func playerAnswered(answerCorrect correct: Bool)
    {
        if correct {
            bottomNavBar.title = "Correct!"
        } else {
            bottomNavBar.title  = "Try Again!"
        }
    }
    func dismissView()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func startTimer()
    {
        print("No Timer")
    }
    func stopTimer()
    {
        print("Still No Timer")
    }
    
}
