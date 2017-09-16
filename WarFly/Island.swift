//
//  Island.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, GameBackgroundSpriteable {

  static func populate() -> Island {
    
    let island = Island(imageNamed: configureName())
    island.setScale(randomScaleFactor)
    island.position = randomPoint()
    island.zPosition = 1
    island.name = "sprite"
    island.run(rotateForRandomAngle())
    island.run(move(from: island.position))
    return island
  }
  
  fileprivate static func configureName() -> String {
    let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
    let randomNumber = distribution.nextInt()
    return "is\(randomNumber)"
  }
 
  fileprivate static var randomScaleFactor: CGFloat {
    let distribution = GKRandomDistribution(lowestValue: 2, highestValue: 10)
    let randomNumber = CGFloat(distribution.nextInt()) / 10
    return randomNumber
  }
  
  fileprivate static func rotateForRandomAngle() -> SKAction {
    let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
    let randomNumber = CGFloat(distribution.nextInt())
    return SKAction.rotate(byAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
  }
  
  fileprivate static func move(from point: CGPoint) -> SKAction {
    let movePoint = CGPoint(x: point.x, y: -200)
    let moveDistance = point.y + 200
    let movementSpeed: CGFloat = 80
    let duration = moveDistance / movementSpeed
    return SKAction.move(to: movePoint, duration: TimeInterval(duration))
  }
  
}
