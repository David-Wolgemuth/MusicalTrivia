//
//  Triad.swift
//  MusicalNotation2
//
//  Created by David Wolgemuth on 1/23/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

enum TriadType: String
{
    case Major
    case Minor
    case Diminished
}

enum TriadPosition
{
    case Root
    case FirstInversion
    case SecondInversion
    
    var description: String {
        get {
            switch self {
            case .Root:
                return "⁵₃"
            case .FirstInversion:
                return "⁶₃"
            case .SecondInversion:
                return "⁶₄"
            }
        }
    }
}

class Triad: CustomStringConvertible
{
    var notes = [Note]()
    let base: String
    let octave: Int
    let type: TriadType
    let scale: Scale
    let position: TriadPosition
    
    var noteString: String {
        get {
            var notesString = ""
            for note in notes {
                notesString += "\(note) => \(note.octave):\(note.position) | "
            }
            return notesString
        }
    }
    
    var description: String {
        get {
            return "\(notes[0]) \(type) \(position.description)"
        }
    }
    
    init(base: String, type: TriadType, octave: Int, scale: Scale, position: TriadPosition)
    {
        self.base = base
        self.octave = octave
        self.type = type
        self.scale = scale
        self.position = position
        makeTriad()
        orderTriad()
    }
    func findThird(baseIndex: Int) -> Note
    {
        var index = baseIndex + 2
        
        if index >= scale.notes.count {
            index -= scale.notes.count
        }
        let name = scale.notes[index]
        let note = Note(name: name, octave: octave)
        
        return note
    }
    func findFifth(baseIndex: Int) -> Note
    {
        var index = baseIndex + 4
        if index >= scale.notes.count {
            index -= scale.notes.count
        }
        let name = scale.notes[index]
        let note = Note(name: name, octave: octave)
        
        return note
    }
    func makeTriad()
    {
        let baseNote = Note(name: base, octave: octave)
        notes = [baseNote]
        if let baseIndex = scale.notes.indexOf(base) {
            let third = findThird(baseIndex)
            let fifth = findFifth(baseIndex)
            notes += [third, fifth]
        } else {
            print("Note not found in scale")
        }
    }
    func orderTriad()
    {
        let a = notes[0].position
        let b = notes[1].position
        let c = notes[2].position
        if position == .Root {
            if b < a {
                ++notes[1].octave
            }
            if c < a {
                ++notes[2].octave
            }
        } else if position == .FirstInversion {
            if a < b {
                ++notes[0].octave
            }
            if c < b {
                ++notes[2].octave
            }
        } else if position == .SecondInversion {
            if a < c {
                ++notes[0].octave
            }
            if b < c {
                ++notes[1].octave
            }
        }
    }
    static func random() -> Triad
    {
        let scale = Scale.random()
        
        let baseIndex = Int(arc4random_uniform(7))
        let base = scale.notes[baseIndex]
        let chordType = Scale.ionianChordOrder[baseIndex]
        
        let positions: [TriadPosition] = [.Root, .FirstInversion, .SecondInversion]
        let position = positions[Int(arc4random_uniform(3))]
        
        let octave = Int(arc4random_uniform(1)) + 3
        
        return Triad(base: base, type: chordType, octave: octave, scale: scale, position: position)
    }
}
