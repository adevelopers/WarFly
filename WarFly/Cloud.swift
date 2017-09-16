//
//  Cloud.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Cloud: SKSpriteNode, GameBackgroundSpriteable {
  
  static func populate() -> Cloud {
    
    let cloud = Cloud(imageNamed: configureName())
    cloud.setScale(randomScaleFactor)
    cloud.position = randomPoint()
    cloud.name = "sprite"
    cloud.zPosition = 10
    cloud.run(move(from: cloud.position))
    return cloud
  }
  
  fileprivate static func configureName() -> String {
    let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
    let randomNumber = distribution.nextInt()
    return "cl\(randomNumber)"
  }
  
  fileprivate static var randomScaleFactor: CGFloat {
    let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
    let randomNumber = CGFloat(distribution.nextInt()) / 10
    return randomNumber
  }

  fileprivate static func move(from point: CGPoint) -> SKAction {
    let movePoint = CGPoint(x: point.x, y: -200)
    let moveDistance = point.y + 200
    let movementSpeed: CGFloat = 170
    let duration = moveDistance / movementSpeed
    return SKAction.move(to: movePoint, duration: TimeInterval(duration))
  }
  
}
