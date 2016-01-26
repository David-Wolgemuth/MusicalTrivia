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

class ZenModeViewController: UIViewController, StandardDelegate
{
    var delegate: StandardDelegate?
    var game: Game?
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem)
    {
        delegate?.dismissView()
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
        }
    }
    func dismissView()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
