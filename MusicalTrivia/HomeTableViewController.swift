//
//  ViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

protocol HomeTableViewControllerDelegate
{
    func pickImage()
}

class HomeTableViewController: UITableViewController, StandardDelegate
{
    var delegate: HomeTableViewControllerDelegate?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userWinsLabel: UILabel!
    @IBOutlet weak var userLossesLabel: UILabel!
    @IBOutlet weak var userCorrectsLabel: UILabel!
    @IBOutlet weak var userIncorrectsLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        fillTableWithUserData()
    }
    func fillTableWithUserData()
    {
        if let username = UserData.readUsername() {
            usernameLabel.text = username
        } else {
            usernameLabel.text = "Set UserName"
        }
        if let image = UserData.readUserImage() {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "rogue.png")
        }
        let games = UserData.playerGameHistory()
        userWinsLabel.text = String(games.won)
        userLossesLabel.text = String(games.lost)
        let questions = UserData.playerQuestionHistory()
        userCorrectsLabel.text = String(questions.correct)
        userIncorrectsLabel.text = String(questions.incorrect)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ZenMode" {
            let controller = segue.destinationViewController as! ZenModeViewController
            controller.delegate = self
        } else if segue.identifier == "SinglePlayer" {
            let controller = segue.destinationViewController as! SinglePlayerViewController
            controller.delegate = self
        } else if segue.identifier == "Roulette" {
            
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.tag == 1 {
            print("UserName Label")
            userNameAlert()
        } else if cell.tag == 2 {
            print("User ImageView ... ")
            delegate?.pickImage()
        } else if let text = cell.textLabel?.text {
            switch text {
            case "Roulette":
                performSegueWithIdentifier("Roulette", sender: nil)
            case "Single":
                performSegueWithIdentifier("SinglePlayer", sender: nil)
            case "Zen":
                performSegueWithIdentifier("ZenMode", sender: nil)
            default:
                break
            }
        }
    }
    
    func userNameAlert()
    {
        let alert = UIAlertController(title: "Username", message: "Make it Creative", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in }
        if let username = UserData.readUsername() {
            alert.textFields![0].text = username
        }
        alert.addAction(UIAlertAction(title: "Set Username", style: .Default) {
            (action: UIAlertAction!) -> Void in
            let username = alert.textFields![0].text!
            UserData.setUsername(username)
            self.fillTableWithUserData()
        })
        presentViewController(alert, animated: true, completion: nil)
    }
    func dismissView()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
