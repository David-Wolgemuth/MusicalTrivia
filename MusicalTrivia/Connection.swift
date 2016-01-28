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
    
    
    var socket: SocketIOClient
    var eventListeners = [String]()
    
    init(controller: RouletteViewController)
    {
        socket = SocketIOClient(socketURL: "david.local:5000")
        socket.connect()
        socket.on("connect") { data, _ in
            print("Connected To Server")
            self.requestNewGame(controller)
        }
    }
    func requestNewGame(controller: RouletteViewController)
    {
        var name = "Opponent"
        if let un = UserData.readUsername() {
            name = un
        }
        
        socket.emit("waiting", name)
        self.eventListeners.append("new-game")
        socket.once("new-game") { data, _ in
            let array = data[0] as! [AnyObject]
            let questionAsker = array[0] as! Bool
            let opponent = array[1] as! String
            controller.gameStarted(questionAsker, opponent: opponent)
            self.listenForGameOver(controller)
        }
    }
    func listenForQuestions(controller: RouletteViewController)
    {
        self.eventListeners.append("new-question")
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
    func listenForGameOver(controller: RouletteViewController)
    {
        self.eventListeners.append("game-over")
        socket.once("game-over") { _, _ in
            controller.gameOverAlert()
            while self.eventListeners.count > 0 {
                self.socket.off(self.eventListeners.popLast()!)
            }
        }
    }
    func sendNewQuestion(controller: RouletteViewController, question: QuestionTuple)
    {
        let answer = question.answer as! JSONCompatable
        socket.emit("new-question", [question.type, answer.dictionary, question.choices])
    }
    func sendAnswerResult(correct: Bool, var timeLeft: Double, controller: RouletteViewController)
    {
        if !correct {
            timeLeft = -1
        }
        socket.emit("answer-result", timeLeft)
        self.eventListeners.append("answer-results")
        socket.once("answer-results") { data, _ in
            let results = data[0] as! [Int]
            controller.answerResultsReceived(results)
        }
    }
    func sendGameOver(controller: RouletteViewController)
    {
        print("duh fuck am i here?")
        socket.emit("game-over")
        self.eventListeners.append("game-over")
        socket.once("game-over") { _, _ in
            controller.gameOverAlert()
        }
    }
}


