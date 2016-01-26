//
//  Game.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

class Game
{
    var timed = false
    var questionTypes = [
        "triads": [
            "root": true,
            "first": true,
            "second": true
        ],
        "key-signatures": [
            "all-modes": true,
            "sharps": true,
            "flats": true
        ]
    ]
    init()
    {
        
    }
}
