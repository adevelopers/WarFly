//
//  EnemyPlane.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 12.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class EnemyPlane: SKSpriteNode {

  static var textureAtlas: SKTextureAtlas?
  var enemyTexture: SKTexture!
  
  init(enemyTexture: SKTexture) {
    let texture = enemyTexture
    super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 204))
    xScale = 0.5
    yScale = -0.5
    zPosition = 20
    name = "enemySprite"
    physicsBody = SKPhysicsBody(texture: texture,
                                      alphaThreshold: 0.5, size: size)
    physicsBody?.isDynamic = true
    physicsBody?.categoryBitMask = BitmaskCategory.enemy.rawValue
    physicsBody?.collisionBitMask = BitmaskCategory.none.rawValue
    physicsBody?.contactTestBitMask = BitmaskCategory.player.rawValue | BitmaskCategory.shot.rawValue
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func flySpiral() {
    let screen = UIScreen.main.bounds
    let timeHorizontal: Double = 3
    let timeVertical: Double = 5
    
    let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
    moveLeft.timingMode = .easeInEaseOut
    let moveRight = SKAction.moveTo(x: screen.size.width - 50, duration: timeHorizontal)
    moveRight.timingMode = .easeInEaseOut
    
    let randomNumber = Int(arc4random_uniform(2))
    
    let movementSeq = randomNumber == EnemyDirection.left.rawValue
                          ? SKAction.sequence([moveLeft, moveRight])
                          : SKAction.sequence([moveRight, moveLeft])
    let foreverRepeat = SKAction.repeatForever(movementSeq)
    
    let forwardMove = SKAction.moveTo(y: -104, duration: timeVertical)
    
    let movementGroup = SKAction.group([foreverRepeat, forwardMove])
    run(movementGroup)
  }
}

enum EnemyDirection: Int {
  case left = 0
  case right
}
