//
//  Assets.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class Assets {
  var isLoaded = false
  static let shared = Assets()
  let yellowShotAtlas = SKTextureAtlas(named: "YellowAmmo")
  let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
  let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
  let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
  let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
  let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
  
  func preloadAssets() {
    yellowShotAtlas.preload { print("yellowShotAtlas preloaded!") }
    enemy_1Atlas.preload { print("enemy_1Atlas preloaded!") }
    enemy_2Atlas.preload { print("enemy_2Atlas preloaded!") }
    greenPowerUpAtlas.preload { print("greenPowerUpAtlas preloaded!") }
    bluePowerUpAtlas.preload { print("bluePowerUpAtlas preloaded!") }
    playerPlaneAtlas.preload { print("playerPlaneAtlas preloaded!") }
  }
}
