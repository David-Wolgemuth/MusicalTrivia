//
//  Interval.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/26/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

class Interval: JSONCompatable
{
    let startNote: Int
    let interval: Int
    let name: String
    var dictionary: [String: AnyObject] {
        get {
            return ["startNote": startNote, "interval": interval, "name": name]
        }
    }
    
    init(startNote: Int, interval: Int, name: String)
    {
        self.startNote = startNote
        self.interval = interval
        self.name = name
    }
    
    static let intervalNames = ["Unison", "Minor 2nd", "Major 2nd", "Minor 3rd", "Major 3rd", "Perfect 4th", "Tritone", "Perfect 5th", "Minor 6th", "Major 6th", "Minor 7th", "Major 7th", "Octave"]
    static func random() -> Interval
    {
        let startNote = Int(rand()) % 20 + 50
        let interval = Int(arc4random_uniform(UInt32(Interval.intervalNames.count)))
        let name = Interval.intervalNames[interval]
        
        return Interval(startNote: startNote, interval: interval, name: name)
    }
    static func initFromJSON(json: [String: AnyObject]) -> Interval
    {
        let startNote = json["startNote"] as! Int!
        let interval = json["interval"] as! Int!
        let name = json["name"] as! String!
        return Interval(startNote: startNote, interval: interval, name: name)
    }
}