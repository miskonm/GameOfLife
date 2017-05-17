//
//  Game.swift
//  GameOfLife
//
//  Copyright © 2017 Nikita Misko. All rights reserved.
//

import Foundation


class Game {
    var creatures: [Creature]
    let width = 20
    let height = 35
    
    private var lifeStep = 0
    
    
    init() {
        creatures = [Creature]()
        
        for x in 0..<width {
            for y in 0..<height {
                creatures.append(Creature(x: x, y: y))
            }
        }
    }
    
    
    func iteration() {
        lifeStep = 0
        
        let firstLiveCreatures = creatures.filter { $0.status == .Allive }
        moveCreatures(firstLiveCreatures)
        
        let deadCreatures = creatures.filter { $0.status == .Dead }
        let newCreatures =  deadCreatures.filter { alliveNeighboursForCreature($0) == 3 }
        
        let liveCreatures = creatures.filter { $0.status == .Allive }
        let dyingCreatures = liveCreatures.filter { alliveNeighboursForCreature($0) < 2 || alliveNeighboursForCreature($0) > 3 }
        
        
        for creature in newCreatures {
            creature.bornFromParent(parentForCreature(creature))
//            creature.setStatus(.Allive)
        }
        
        for creature in dyingCreatures {
            creature.kill()
        }
    }
    
    
    func parentForCreature(_ creature: Creature) -> Creature {
        let neibs = neighboursForCreature(creature)
            .filter { $0.status == .Allive }
            .sorted { $0.getLifeStepNumber > $1.getLifeStepNumber }
        
        return neibs.first!
    }
    
    
    subscript (x: Int, y: Int) -> Creature? {
        return creatures.filter { $0.x == x && $0.y == y }.first
    }
    
    
    func isNeibs(_ first: Creature, _ second: Creature) -> Bool {
        let dt = (abs(first.x - second.x), abs(first.y - second.y))
        switch dt {
        case (1,0), (0,1), (1,1),
             (width - 1,0), (width - 1,1),
             (0,height - 1), (1, height - 1),
             (width - 1, height - 1):
            return true
        default:
            return false
        }
    }
    
    func changeCreatureState(x: Int, y: Int) {
        let creatureForChange = creatures.filter { $0.x == x && $0.y == y }
        
        if let creature = creatureForChange.first {
            let status: CreatureStatus = creature.status == .Allive ? .Dead : . Allive
            creature.setStatus(status)
        }
    }
    
    func getCreatureForPosition(_ x: Int, _ y: Int) -> Creature? {
        let creatureForChange = creatures.filter { $0.x == x && $0.y == y }
        
        if let creature = creatureForChange.first {
            return creature
        } else {
            return nil
        }
    }
    
    func moveCreatures(_ creatures: [Creature]) {
        for creature in creatures {
            let neibs = neighboursForCreature(creature)
            
            var emptyHomesNear = [Creature]()
            for neib in neibs {
                if neib.status == .Dead {
                    emptyHomesNear.append(neib)
                }
            }
            
            var preferredNeibs = [Int]()
            var tempGenom = creature.genom!
            for i in creature.genom! {
                if (i == 1) {
                    preferredNeibs.append((tempGenom.index(of: i)!))
                    tempGenom[tempGenom.index(of: i)!] = 0
                }
            }
            
            var possibleHomes = [Creature]()
            for home in emptyHomesNear {
                let homeNeibs = alliveNeighboursForCreature(home)
                
                for neib in preferredNeibs {
                    if (homeNeibs == neib) {
                        possibleHomes.append(home)
                    }
                }
            }
            
            if (possibleHomes.count > 0) {
                let number = Int(arc4random_uniform(UInt32(possibleHomes.count)))
                creature.moveTo(possibleHomes[number], lifeStep: lifeStep)
//                creature.setStatus(.Dead)
//                possibleHomes[number].setStatus(.Allive)
            }
            
            lifeStep += 1
        }
    }
    
    func neighboursForCreature(_ creature: Creature) -> [Creature] {
        return self.creatures.filter { isNeibs(creature, $0) }
    }
    
    
    func alliveNeighboursForCreature(_ creature: Creature) -> Int {
        return neighboursForCreature(creature).filter { $0.status == CreatureStatus.Allive }.count
    }
}
