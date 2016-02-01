//
//  AudioPlayer.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/26/16.
//  Copyright © 2016 David. All rights reserved.
//

import AudioKit

class AudioPlayer: NSObject
{
    class var sharedInstance: AudioPlayer
    {
        struct Static
        {
            static let instance: AudioPlayer = AudioPlayer()
        }
        return Static.instance
    }
    
    let audioKit = AKManager.sharedInstance
    let synth = AKSawtoothSynth(voiceCount: 2)
    var velocity = 12
    var currentChord = [Int]()
    let arpSeconds = 1.0
    
    func playNote(note: Int)
    {
        synth.playNote(note, velocity: velocity)
    }
    func playCurrentChord()
    {
        releaseAllNotes()
        if currentChord.count > 0 {
            playNote(currentChord.removeAtIndex(0))
            NSTimer.scheduledTimerWithTimeInterval(arpSeconds, target: self, selector: "playCurrentChord", userInfo: nil, repeats: false)
        }
    }
    func playInterval(from first: Int, to second: Int)
    {
        currentChord = [first, second]
        playCurrentChord()
    }
    func releaseAllNotes()
    {
        for note in synth.activeNotes {
            synth.stopNote(note)
        }
    }
    override private init()
    {
        super.init()
        audioKit.audioOutput = synth
        audioKit.start()
    }
}
