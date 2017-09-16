
//
//  YellowShot.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class YellowShot: Shot {
  init() {
    let textureAtlas = Assets.shared.yellowShotAtlas
    super.init(textureAtlas: textureAtlas)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
