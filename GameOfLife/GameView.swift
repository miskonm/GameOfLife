//
//  GameView.swift
//  GameOfLife
//
//  Copyright © 2017 Nikita Misko. All rights reserved.
//

import UIKit

class GameView: UIView {
    let game: Game
    
    
    init(game: Game) {
        self.game = game
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newColorForCreature(_ creature: Creature) -> UIColor {
        guard let genom = creature.genom else {
            return UIColor.white
        }
        
        let bitRed = Int("\(genom[0])\(genom[1])\(genom[2])", radix: 2)!
        let bitGreen = Int("\(genom[3])\(genom[4])\(genom[5])", radix: 2)!
        let bitBlue = Int("\(genom[6])\(genom[7])\(genom[8])", radix: 2)!
        
        let red = Float("0.\(bitRed)")!
        let green = Float("0.\(bitGreen)")!
        let blue = Float("0.\(bitBlue)")!
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
    func frameForCreature(_ creature: Creature) -> CGRect {
        let width = CGFloat(self.game.width)
        let height = CGFloat(self.game.height)
        let creatureSize = CGSize(width: self.bounds.width / width, height: self.bounds.height / height)
        
        return CGRect(x: CGFloat(creature.x) * creatureSize.width,
                      y: CGFloat(creature.y) * creatureSize.height,
                      width: creatureSize.width,
                      height: creatureSize.height)
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for creature in game.creatures {
            context!.setFillColor(newColorForCreature(creature).cgColor)
            context!.addRect(frameForCreature(creature))
            context!.fillPath()
        }
    }
}
