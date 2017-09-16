//
//  GameSettings.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 15.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit

class GameSettings {
  
  fileprivate let musicKey = "musicKey"
  fileprivate let soundKey = "soundKey"
  fileprivate let highscoreKey = "highscoreKey"
  fileprivate let ud = UserDefaults.standard
  
  var highscore: [Int] = []
  var currentScore = 0
  
  var isSound = true
  var isMusic = true
  
  init() {
    loadGameSettings()
    loadScores()
  }
  
  func saveScores() {
    highscore.append(currentScore)
    highscore = Array(highscore.sorted(by: { $0 > $1 }).prefix(3))
    ud.set(highscore, forKey: highscoreKey)
    ud.synchronize()
  }
  
  func loadScores() {
    if ud.value(forKey: highscoreKey) != nil {
      highscore = ud.array(forKey: highscoreKey) as! [Int]
    }
    
  }
  
  func saveGameSettings() {
    ud.set(isMusic, forKey: musicKey)
    ud.set(isSound, forKey: soundKey)
    ud.synchronize()
  }
  
  func loadGameSettings() {
    if ud.value(forKey: soundKey) != nil && ud.value(forKey: musicKey) != nil {
      isMusic = ud.bool(forKey: musicKey)
      isSound = ud.bool(forKey: soundKey)
    }
  }
  
}
