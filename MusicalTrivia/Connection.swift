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
    var eventListeners = [String]()
    
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
        var name = "Opponent"
        if let un = UserData.readUsername() {
            name = un
        }
        
        socket.emit("waiting", name)
        socket.once("new-game") { data, _ in
            self.eventListeners.append("new-game")
            let array = data[0] as! [AnyObject]
            let questionAsker = array[0] as! Bool
            let opponent = array[1] as! String
            controller.gameStarted(questionAsker, opponent: opponent)
            self.listenForGameOver(controller)
        }
    }
    func listenForQuestions(controller: RouletteViewController)
    {
        socket.on("new-question") { data, _ in
            self.eventListeners.append("new-question")
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
        socket.once("game-over") { _, _ in
            controller.gameOverAlert()
            while self.eventListeners.count > 0 {
                self.socket.off(self.eventListeners.popLast()!)
            }
        }
    }
    func resetConnection()
    {
        socket.disconnect()
        connectToServer()
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
        socket.once("answer-results") { data, _ in
            self.eventListeners.append("answer-results")
            let results = data[0] as! [Int]
            controller.answerResultsReceived(results)
        }
    }
    func sendGameOver(controller: RouletteViewController)
    {
        socket.emit("game-over")
        socket.once("game-over") { _, _ in
            print("connection game-over")
            controller.gameOverAlert()
            self.resetConnection()
        }
    }
}


