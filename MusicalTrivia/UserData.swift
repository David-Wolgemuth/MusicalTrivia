//
//  UserData.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class UserData
{
    static func documentsPathForFileName(name: String) -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = paths[0] as NSString
        let fullPath = path.stringByAppendingPathComponent(name)
        return fullPath
    }
    static func setUserImage(image: UIImage)
    {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = documentsPathForFileName(relativePath)
        imageData?.writeToFile(path, atomically: true)
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: "path")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    static func readUserImage() -> UIImage?
    {
        let existingPath = NSUserDefaults.standardUserDefaults().objectForKey("path") as! String?
        if let path = existingPath {
            let fullPath = documentsPathForFileName(path)
            let data = NSData(contentsOfFile: fullPath)
            let image = UIImage(data: data!)
            return image
        }
        return nil
    }
    static func setUsername(username: String)
    {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
    }
    static func readUsername() -> String?
    {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("username") {
            return data as? String
        }
        return nil
    }
    static func incrementGamesFinished(playerWon won: Bool)
    {
        let won = won ? "won" : "lost"
        if let existing = NSUserDefaults.standardUserDefaults().objectForKey("games-\(won)") {
            let number = existing as! Int
            NSUserDefaults.standardUserDefaults().setObject(number+1, forKey: "games-\(won)")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(1, forKey: "games-\(won)")
        }
    }
    static func playerGameHistory() -> (won: Int, lost: Int)
    {
        var won = 0
        if let number = NSUserDefaults.standardUserDefaults().objectForKey("games-won") {
            won = number as! Int
        }
        var lost = 0
        if let number = NSUserDefaults.standardUserDefaults().objectForKey("games-lost") {
            lost = number as! Int
        }
        return (won, lost)
    }
    static func incrementQuestionsAnswered(answerIsCorrect correct: Bool)
    {
        let correct = correct ? "correct" : "incorrect"
        if let existing = NSUserDefaults.standardUserDefaults().objectForKey("answers-\(correct)") {
            let number = existing as! Int
            NSUserDefaults.standardUserDefaults().setObject(number + 1, forKey: "answers-\(correct)")
        } else {
            NSUserDefaults.standardUserDefaults().setObject(1, forKey: "answers-\(correct)")
        }
    }
    static func playerQuestionHistory() -> (correct: Int, incorrect: Int)
    {
        var correct = 0
        if let number = NSUserDefaults.standardUserDefaults().objectForKey("answers-correct") {
            correct = number as! Int
        }
        var incorrect = 0
        if let number = NSUserDefaults.standardUserDefaults().objectForKey("answers-incorrect") {
            incorrect = number as! Int
        }
        return (correct, incorrect)
        
    }
}
