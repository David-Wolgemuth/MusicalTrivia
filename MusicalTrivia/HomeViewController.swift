//
//  ViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController
{

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.tag == 1 {
            print("UserName Label")
        } else if cell.tag == 2 {
            print("User ImageView")
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

}
