//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit
import CoreMotion

enum TurnDirection {
  case left
  case right
  case none
}

class PlayerPlane: SKSpriteNode {

  fileprivate let motionManager = CMMotionManager()
  fileprivate var xAcceleration: CGFloat = 0
  fileprivate let screenSize = UIScreen.main.bounds
  
  fileprivate var leftTextureArrayAnimation = [SKTexture]()
  fileprivate var rightTextureArrayAnimation = [SKTexture]()
  fileprivate var forwardTextureArrayAnimation = [SKTexture]()
  
  fileprivate var moveDirection: TurnDirection = .none
  fileprivate var stillTurning = false
  
  fileprivate let animationStrides = [(13, 1, -1), (13, 26, 1), (13, 13, 1)]
  
  static func populate(at point: CGPoint) -> PlayerPlane {
    let planeTexture = Assets.shared.playerPlaneAtlas.textureNamed("airplane_3ver2_13")
    let plane = PlayerPlane(texture: planeTexture)
    plane.setScale(0.5)
    plane.position = point
    plane.zPosition = 40
    
    let offsetX = plane.frame.size.width * plane.anchorPoint.x
    let offsetY = plane.frame.size.height * plane.anchorPoint.y
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 70 - offsetX, y: 98 - offsetY))
    path.addLine(to: CGPoint(x: 79 - offsetX, y: 98 - offsetY))
    path.addLine(to: CGPoint(x: 84 - offsetX, y: 84 - offsetY))
    path.addLine(to: CGPoint(x: 141 - offsetX, y: 74 - offsetY))
    path.addLine(to: CGPoint(x: 143 - offsetX, y: 66 - offsetY))
    path.addLine(to: CGPoint(x: 84 - offsetX, y: 56 - offsetY))
    path.addLine(to: CGPoint(x: 80 - offsetX, y: 25 - offsetY))
    path.addLine(to: CGPoint(x: 95 - offsetX, y: 19 - offsetY))
    path.addLine(to: CGPoint(x: 94 - offsetX, y: 10 - offsetY))
    path.addLine(to: CGPoint(x: 75 - offsetX, y: 4 - offsetY))
    path.addLine(to: CGPoint(x: 55 - offsetX, y: 9 - offsetY))
    path.addLine(to: CGPoint(x: 55 - offsetX, y: 19 - offsetY))
    path.addLine(to: CGPoint(x: 70 - offsetX, y: 23 - offsetY))
    path.addLine(to: CGPoint(x: 65 - offsetX, y: 56 - offsetY))
    path.addLine(to: CGPoint(x: 9 - offsetX, y: 65 - offsetY))
    path.addLine(to: CGPoint(x: 9 - offsetX, y: 76 - offsetY))
    path.addLine(to: CGPoint(x: 65 - offsetX, y: 85 - offsetY))
    path.closeSubpath()
    
    plane.physicsBody = SKPhysicsBody(polygonFrom: path)
    plane.physicsBody?.isDynamic = false
    plane.physicsBody?.categoryBitMask = BitmaskCategory.player.rawValue
    plane.physicsBody?.collisionBitMask = BitmaskCategory.enemy.rawValue
                                                                | BitmaskCategory.powerUp.rawValue
    plane.physicsBody?.contactTestBitMask = BitmaskCategory.enemy.rawValue
                                                                | BitmaskCategory.powerUp.rawValue
    return plane
  }
  
  func checkPosition() {
    self.position.x += xAcceleration * 20
    
    if self.position.x < -70 {
      self.position.x = screenSize.size.width + 70
    } else if self.position.x > screenSize.size.width + 70 {
      self.position.x = -70
    }
  }
  
  func powerUpAction(with color: UIColor) {
    let colorAction = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.2)
    let uncolorAction = SKAction.colorize(with: color, colorBlendFactor: 0.0, duration: 0.2)
    let actionSeq = SKAction.sequence([colorAction, uncolorAction])
    let repeatActiont = SKAction.repeat(actionSeq, count: 4)
    run(repeatActiont)
  }
  
  func performFly() {
    preloadTextureArrays()
    
    motionManager.accelerometerUpdateInterval = 0.1
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self] data,
                                                                                    error in
      if let data = data {
        let acceleration = data.acceleration
        self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
      }
    }
    
    let waitAction = SKAction.wait(forDuration: 1)
    let directionCheckAction = SKAction.run { [unowned self] in
      self.movementDirectionCheck()
    }
    
    let actionSeq = SKAction.sequence([waitAction, directionCheckAction])
    let repeatAction = SKAction.repeatForever(actionSeq)
    run(repeatAction)
    
  }
  
  fileprivate func preloadTextureArrays() {
    for i in 0...2 {
      preloadArray(_stride: animationStrides[i], callback: { [unowned self] array in
        switch i {
        case 0: self.leftTextureArrayAnimation = array
        case 1: self.rightTextureArrayAnimation = array
        case 2: self.forwardTextureArrayAnimation = array
        default: break
        }
      })
    }
  }
  
  fileprivate func preloadArray(_stride: (Int, Int, Int),
                                callback: @escaping ([SKTexture]) -> ()) {
    var array = [SKTexture]()
    for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
      let number = String(format: "%02d", i)
      let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
      array.append(texture)
    }
    SKTexture.preload(array, withCompletionHandler: {
      callback(array)
    })
  }

  fileprivate func movementDirectionCheck() {
    
    if xAcceleration > 0.03, moveDirection != .right, stillTurning == false {
      stillTurning = true
      moveDirection = .right
      turnPlane(direction: .right)
    } else if xAcceleration < 0.03, moveDirection != .left, stillTurning == false {
      stillTurning = true
      moveDirection = .left
      turnPlane(direction: .left)
    } else if stillTurning == false {
      turnPlane(direction: .none)
    }
  }
  
  fileprivate func turnPlane(direction: TurnDirection) {
    var array = [SKTexture]()
    
    if direction == .right {
      array = rightTextureArrayAnimation
    } else if direction == .left {
      array = leftTextureArrayAnimation
    } else {
      array = forwardTextureArrayAnimation
    }
    
    let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true,
                                         restore: false)
    let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true,
                                          restore: false)
    let actionSeq = SKAction.sequence([forwardAction, backwardAction])
    run(actionSeq) { [unowned self] in
      self.stillTurning = false
    }
  }
  
}






