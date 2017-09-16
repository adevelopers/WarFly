//
//  PowerUp.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 12.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class PowerUp: SKSpriteNode {

  fileprivate let initialSize = CGSize(width: 52, height: 52)
  fileprivate var textureAtlas: SKTextureAtlas!
  fileprivate var animationSpriteArray = [SKTexture]()
  fileprivate var textureNameBeginsWith = ""
  
  init(textureAtlas: SKTextureAtlas) {
    self.textureAtlas = textureAtlas
    let textureName = textureAtlas.textureNames.sorted()[0]
    let texture = textureAtlas.textureNamed(textureName)
    textureNameBeginsWith = String(textureName.characters.dropLast(6))
    super.init(texture: texture, color: .clear, size: initialSize)
    setScale(0.7)
    zPosition = 20
    physicsBody = SKPhysicsBody(texture: texture,
                                alphaThreshold: 0.5, size: size)
    physicsBody?.isDynamic = true
    physicsBody?.categoryBitMask = BitmaskCategory.powerUp.rawValue
    physicsBody?.collisionBitMask = BitmaskCategory.none.rawValue
    physicsBody?.contactTestBitMask = BitmaskCategory.player.rawValue 
  }
  
  func startMovement() {
    performRotation()
    let moveForward = SKAction.moveTo(y: -100, duration: 5)
    run(moveForward)
  }
  
  fileprivate func performRotation() {
    for i in 1...15 {
      let number = String(format: "%02d", i)
      animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number.description))
    }
    
    SKTexture.preload(animationSpriteArray) { [unowned self] in
      let rotation = SKAction.animate(with: self.animationSpriteArray,
                                      timePerFrame: 0.05, resize: true, restore: false)
      let rotationForever = SKAction.repeatForever(rotation)
      self.run(rotationForever)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
