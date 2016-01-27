//
//  Connection.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/26/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

protocol JSONCompatable
{
    var dictionary: [String: AnyObject] { get }
}

class Connection
{
    class var sharedInstance: Connection
    {
        struct Static
        {
            static let instance: Connection = Connection()
        }
        return Static.instance
    }
    
    var socket: SocketIOClient
    
    private init()
    {
        socket = SocketIOClient(socketURL: "david.local:5000")
        connectToServer()
    }
    func connectToServer()
    {
        socket.connect()
        socket.on("connect") { data, _ in
            print("Connected To Server")
        }
    }
    func requestNewGame(controller: RouletteViewController)
    {
        socket.emit("waiting")
        socket.on("new-game") { data, _ in
            let questionAsker = data[0] as! Bool
            controller.gameStarted(questionAsker)
        }
    }
    func listenForQuestions(controller: RouletteViewController)
    {
        socket.on("new-question") { data, _ in
            
            let d = data[0] as! [AnyObject]
            let type = d[0] as! String
            print("Heard Question: \(type)")
            let answer = d[1] as! [String: AnyObject]
            let choices = d[2] as! [String]
            
            let question = (type, answer, choices) as QuestionTuple
            controller.incomingQuestion(question)
        }
    }
    func sendNewQuestion(controller: RouletteViewController, question: QuestionTuple)
    {
        let answer = question.answer as! JSONCompatable
        socket.emit("new-question", [question.type, answer.dictionary, question.choices])
    }
    func sendAnswerResult(correct: Bool, var timeLeft: Double)
    {
        if !correct {
            timeLeft = -1
        }
        socket.emit("answer-result", timeLeft)
    }
}