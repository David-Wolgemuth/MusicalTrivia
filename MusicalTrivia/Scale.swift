//
//  Scale.swift
//  MusicalNotation2
//
//  Created by David Wolgemuth on 1/23/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

enum ScaleMode: Int
{
    case Ionian
    case Dorian
    case Phrygian
    case Lydian
    case Mixolydian
    case Aeolian
    case Locrian
}

class Scale: CustomStringConvertible, JSONCompatable
{
    let ionianRoot: String
    var notes = [String]()
    var sharps = [Int]()
    var flats = [Int]()
    var mode: ScaleMode = .Ionian
    
    var description: String {
        get {
            var str = String(notes[0].characters.first!).uppercaseString
            if notes[0].characters.count > 1 {
                str += String(notes[0].characters.last!)
            }
            if mode != .Ionian {
                str += " \(mode)"
            }
            return str
        }
    }
    
    var dictionary: [String: AnyObject] {
        get {
            return ["root": ionianRoot, "mode": mode.rawValue]
        }
    }
    
    static let chromaticScaleSharps = ["a", "a♯", "b", "c", "c♯", "d", "d♯", "e", "f", "f♯", "g", "g♯"]
    static let chromaticScaleFlats = ["a", "b♭", "c♭", "c", "d♭", "d", "e♭", "e", "f", "g♭", "g", "a♭"]
    static let orderOfSharpsCharacters = ["f", "c", "g", "d", "a", "e", "b"]
    static let orderOfSharpsIndexes = [ 5, 2, 6, 3, 0, 4, 1]
    static let orderOfFlatsCharacters = ["b", "e", "a", "d", "g", "c", "f"]
    static let orderOfFlatsIndexes = [1, 4, 0, 3, -1, 2, -2]
    static let scalesWithSharps = ["g", "d", "a", "e", "b", "f♯", "c♯"]
    static let scalesWithFlats = ["f", "b♭", "e♭", "a♭", "d♭", "g♭", "c♭"]
    static let ionianChordOrder: [TriadType] = [.Major, .Minor, .Minor, .Major, .Major, .Minor, .Diminished]
    
    init(name: String)
    {
        self.ionianRoot = name
        findSharpsAndFlats()
        findNotes()
    }
    func findNotes()
    {
        let intervals = [0, 2, 4, 5, 7, 9, 11]
        if flats.count > 0 {
            let base = Scale.chromaticScaleFlats.indexOf(ionianRoot)!
            for int in intervals {
                notes.append(Scale.chromaticScaleFlats[(base + int) % 12])
            }
        } else {
            let base = Scale.chromaticScaleSharps.indexOf(ionianRoot)!
            for int in intervals {
                notes.append(Scale.chromaticScaleSharps[(base + int) % 12])
            }
        }
        if ionianRoot == "c♯" {
            notes[2] = "e♯"
            notes[6] = "b♯"
        }
    }
    func findSharpsAndFlats()
    {
        if let numberOfSharps = Scale.scalesWithSharps.indexOf(ionianRoot) {
            for index in 0...numberOfSharps {
                let sharp = Scale.orderOfSharpsIndexes[index]
                sharps.append(sharp)
            }
        }
        if let numberOfFlats = Scale.scalesWithFlats.indexOf(ionianRoot) {
            for index in 0...numberOfFlats {
                let flat = Scale.orderOfFlatsIndexes[index]
                flats.append(flat)
            }
        }
    }
    func shiftToMode(mode: ScaleMode)
    {
        let base = mode.hashValue
        var newScale = [String]()
        for i in base..<notes.count {
            newScale.append(notes[i])
        }
        for i in 0..<base {
            newScale.append(notes[i])
        }
        notes = newScale
        self.mode = mode
    }
    static func random(isIonian ionian: Bool = true) -> Scale
    {
        let scaleNames = Scale.scalesWithSharps + Scale.scalesWithFlats
        let index = Int(arc4random_uniform(UInt32(scaleNames.count + 1))) - 1
        let scaleName: String
        if index == -1 {
            scaleName = "c"
        } else {
            scaleName = scaleNames[index]
        }
        let scale = Scale(name: scaleName)
        if !ionian {
            let mode = ScaleMode(rawValue: Int(arc4random_uniform(7)))!
            scale.shiftToMode(mode)
        }
        return scale
    }
    static func initFromJSON(json: [String: AnyObject]) -> Scale
    {
        let root = json["root"] as! String!
        let mode = ScaleMode(rawValue: json["mode"] as! Int!)!
        let scale = Scale(name: root)
        if mode != .Ionian {
            scale.shiftToMode(mode)
        }
        return scale
    }
}
