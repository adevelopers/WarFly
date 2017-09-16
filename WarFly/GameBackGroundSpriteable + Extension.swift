//
//  GameBackGroundSpriteable + Extension.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 12.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundSpriteable {
  static func populate() -> Self
  static func randomPoint() -> CGPoint
}

extension GameBackgroundSpriteable {
  static func randomPoint() -> CGPoint {
    let screen = UIScreen.main.bounds
    let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 200,
                                            highestValue: Int(screen.size.height) + 300)
    let y = CGFloat(distribution.nextInt())
    let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
    return CGPoint(x: x, y: y)
  }
}
