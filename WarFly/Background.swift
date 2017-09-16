//
//  Background.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit
import SpriteKit

class Background: SKSpriteNode {

  static func populateBackground(at point: CGPoint) -> Background {
    
    let background = Background(imageNamed: "background")
    background.position = point
    background.zPosition = 0
    return background
  }
  
}
