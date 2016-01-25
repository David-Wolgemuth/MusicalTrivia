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

class HomeTableViewController: UITableViewController
{
    var delegate: HomeTableViewControllerDelegate?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
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
                print("New Roulette Game")
            case "Single":
                print("New Single Player Game")
            case "Zen":
                print("New Practice Session")
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
    
}
