//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class BluePowerUp: PowerUp {
  init() {
    let atlas = Assets.shared.bluePowerUpAtlas
    super.init(textureAtlas: atlas)
    name = "bluePowerUp"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
