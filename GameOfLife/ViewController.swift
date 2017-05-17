//
//  ViewController.swift
//  GameOfLife
//
//  Created by Nikita Misko on 04.05.17.
//  Copyright © 2017 Nikita Misko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    // IBActions
    @IBAction func startButtonPressed() {
        guard startButton.isEnabled else {
            return
        }

        randomButton.isEnabled = false
        resetButton.isEnabled = false
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        
        time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.startLife), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func pauseButtonPressed() {
        guard pauseButton.isEnabled else {
            return
        }
        
        startButton.isEnabled = true
        randomButton.isEnabled = true
        resetButton.isEnabled = true
        pauseButton.isEnabled = false
        
        time.invalidate()
    }
    
    
    @IBAction func randomButtonPressed() {
        guard randomButton.isEnabled else {
            return
        }
        
        cleanGameView()
        
        func randomLocation() -> (Int, Int) {
            return (Int(arc4random_uniform(UInt32(game.width))),
                    Int(arc4random_uniform(UInt32(game.height))))
        }
        
        for _ in 0...Int(arc4random_uniform(UInt32(350))) {
            let x = randomLocation().0, y = randomLocation().1
            game[x,y]?.setStatus(.Allive)
        }
        
        gameView.setNeedsDisplay()
        resetButton.isEnabled = true
    }
    
    
    @IBAction func resetButtonPressed() {
        guard resetButton.isEnabled else {
            return
        }
        
        cleanGameView()
        
        randomButton.isEnabled = true
        resetButton.isEnabled = false
    }
    
    
    // Variables
    let game = Game()
    let gameView: GameView
    
    var time: Timer!
    let topMargin: CGFloat = 22.0
    let botMargin: CGFloat = 44.0
    let sideMargin: CGFloat = 3.0
    
    var isLifeInProcees = false
    
    // LifeCicle
    required init?(coder aDecoder: NSCoder) {
        gameView = GameView(game: game)
        
        super.init(coder: aDecoder)
    }
    
    
    func startLife() {
        game.iteration()
        gameView.setNeedsDisplay()
    }
    
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: gameView)
        
        let width = CGFloat(game.width)
        let height = CGFloat(game.height)
        let creatureSize = CGSize(width: gameView.bounds.width / width, height: gameView.bounds.height / height)
        let x = Int(location.x / creatureSize.width)
        let y = Int(location.y / creatureSize.height)
        
        game.changeCreatureState(x: x, y: y)
        print("genom: \(game.getCreatureForPosition(x, y)?.genom)")
        gameView.setNeedsDisplay()
        resetButton.isEnabled = true
    }
    
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
    }
    
    
    func cleanGameView() {
        for x in 0...game.width {
            for y in 0...game.height {
                game[x,y]?.setStatus(.Dead)
            }
        }
        
        gameView.setNeedsDisplay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view
        let width = view.frame.width - sideMargin * 2.0
        let frame = CGRect(x: sideMargin, y: topMargin, width: width, height: view.frame.height - botMargin - topMargin)
        gameView.frame = frame
        gameView.layer.borderColor = UIColor.darkGray.cgColor
        gameView.layer.borderWidth = 2.0
        view.addSubview(gameView)
        
        
        // Gestures
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selecotr()
    }
}
