//
//  Creature.swift
//  GameOfLife
//
//  Created by Nikita Misko on 04.05.17.
//  Copyright © 2017 Nikita Misko. All rights reserved.
//

import Foundation

enum Bit {
    case A, B
}

class Creature {
    let x, y: Int
    var status: CreatureStatus
    var genom: [Int]?
    private var stepNumber: Int?
    
    var getLifeStepNumber: Int {
        if stepNumber != nil {
            return stepNumber!
        } else {
            return 0
        }
    }
    
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.status = .Dead
    }
    
    func setStatus(_ status: CreatureStatus) {
        self.status = status
        
        if (status == . Dead) {
            self.genom = nil
        } else {
            self.genom = [Int]()
            for _ in 0...8 {
                self.genom!.append(Int(arc4random_uniform(2)))
            }
        }
    }
    
    
    func bornFromParent(_ parent: Creature) {
        self.status = .Allive
        self.genom = parent.genom
    }
    
    
    func kill() {
        self.status = .Dead
        self.genom = nil
    }
    
    
    func moveTo(_ newCreature: Creature, lifeStep: Int) {
        newCreature.status = .Allive
        newCreature.genom = self.genom
        newCreature.stepNumber = lifeStep
        
        self.genom = nil
        self.status = .Dead
        self.stepNumber = nil
    }
    
    
    func getStatus() -> CreatureStatus {
        return self.status
    }
}

enum CreatureStatus {
    case Dead, Allive
}
