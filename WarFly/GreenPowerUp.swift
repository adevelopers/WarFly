//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class GreenPowerUp: PowerUp {
  init() {
    let atlas = Assets.shared.greenPowerUpAtlas
    super.init(textureAtlas: atlas)
    name = "greenPowerUp"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}



