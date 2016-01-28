//
//  RouletteHeaderViewController.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/27/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class RouletteHeaderViewController: UIViewController
{
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    @IBOutlet weak var opponentImageLabel: UIImageView!
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var opponentScoreLabel: UILabel!
    
    override func viewDidLoad()
    {
        playerNameLabel.text = UserData.readUsername()
        playerImage.image = UserData.readUserImage()
    }
    func setScore(score: [Int])
    {
        playerScoreLabel.text = String(score[0])
        opponentScoreLabel.text = String(score[1])
    }
}
