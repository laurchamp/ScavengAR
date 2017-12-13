//
//  Game.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/7/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import Firebase

class Game: NSObject {
    // Singleton instance of game
    private static var sharedGame: Game = {
        let currGame = Game()
        return currGame
    }()
    
    // Other variables
    var aliens = [Alien]()
    var score: Int!
    let ref = FIRDatabase.database().reference(withPath: "alien-list")

    // initialize singleton only once
    private override init(){
        super.init()
        ref.observe(.value, with: { snapshot in
            var newAlienList: [Alien] = []
            for alien in snapshot.children{
                let newAlien = Alien(snapshot: alien as! FIRDataSnapshot)
                newAlienList.append(newAlien)
            }
            self.aliens = newAlienList
        })
        self.score = 0
    }
    
    func deleteAlien(_ alien: Alien){
        alien.ref?.removeValue()
    }
    
    func increaseScore(){
        self.score! += 1
    }
    
    func resetScore(){
        self.score! = 0
    }
    
    // singleton method
    class func shared() -> Game {
        return sharedGame
    }
}
