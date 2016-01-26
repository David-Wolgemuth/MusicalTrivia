//
//  Note.swift
//  MusicalNotation2
//
//  Created by David Wolgemuth on 1/23/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

class Note: CustomStringConvertible
{
    let name: String
    let number: Int
    let midi: Int
    let letter: String
    let position: Int
    var octave: Int
    
    var description: String {
        get {
            var x = String(name.characters.first!).uppercaseString
            if name.characters.count > 1 {
                x += String(name.characters.last!)
            }
            return x
        }
    }
    
    init(name: String, octave: Int)
    {
        self.name = name
        self.octave = octave
        var name = name
        if name == "e♯" {
            name = "f"
        }
        if name == "b♯" {
            name = "c"
        }
        if let index = Scale.chromaticScaleSharps.indexOf(name) {
            number = index
        } else {
            let index = Scale.chromaticScaleFlats.indexOf(name)!
            number = index
        }
        midi = number + (12 * octave) - 3
        letter = String(self.name.characters.first!)
        position = Array("abcdefg".characters).indexOf(Character(letter))! + (7 * (octave - 4) )
    }
}
