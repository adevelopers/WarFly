//
//  GameScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: ParentScene {
  
  var backgroundMusic: AVAudioPlayer!
  
  fileprivate var playerPlane: PlayerPlane!
  fileprivate var yellowShot: Shot!
  fileprivate let hud = HUD()
  fileprivate let screenSize = UIScreen.main.bounds.size
  fileprivate var lives = 3 {
    didSet {
      reduceLives(count: lives)
    }
  }
  
  override func didMove(to view: SKView) {
    configureScene()
  }
  
  fileprivate func configureScene() {
    
    gameSettings.loadGameSettings()
    
    if let musicUrl = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
      backgroundMusic = try! AVAudioPlayer(contentsOf: musicUrl)
      backgroundMusic.numberOfLoops = -1
      backgroundMusic.volume = 0.4
      if gameSettings.isMusic {
        backgroundMusic.play()
      }
    }
    
    
    scene?.isPaused = false
    guard sceneManager.gameScene == nil else { return }
    sceneManager.gameScene = self
    
    physicsWorld.contactDelegate = self
    physicsWorld.gravity = .zero
    
    playerPlane = PlayerPlane.populate(at: CGPoint(x: frame.midX, y: 100))
    playerPlane.performFly()
    addChild(playerPlane)
    
    let background = Background.populateBackground(at: CGPoint(x: frame.midX, y: frame.midY))
    background.size = size
    addChild(background)
    
    spawnClouds()
    spawnIslands()
    spawnEnemies()
    spawnPowerUp()
    
    createHUD()
  }
  
  fileprivate func createHUD() {
    addChild(hud)
    hud.configureUI(screenSize: screenSize)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let location = touches.first!.location(in: self)
    let node = atPoint(location)
    if node.name == "pause" {
      sceneManager.gameScene = self
      scene?.isPaused = true
      backgroundMusic.pause()
      let transition = SKTransition.fade(withDuration: 1.0)
      let pauseScene = PauseScene(size: self.size)
      pauseScene.scaleMode = .aspectFill
      scene!.view?.presentScene(pauseScene, transition: transition)
    } else {
      playerFire()
    }
  }
  
  override func didSimulatePhysics() {
    
    playerPlane.checkPosition()
    
    enumerateChildNodes(withName: "enemySprite") { node, stop in
      if node.position.y <= 0 - node.frame.maxY * 1.5 {
        node.removeFromParent()
      }
    }
    
    enumerateChildNodes(withName: "shotSprite") { [unowned self] node, stop in
      if node.position.y >= self.frame.maxY + node.frame.size.height {
        node.removeFromParent()
      }
    }
    
    enumerateChildNodes(withName: "bluePowerUp") { node, stop in
      if node.position.y <= 0 - node.frame.maxY * 1.5 {
        node.removeFromParent()
      }
    }
    
    enumerateChildNodes(withName: "greenPowerUp") { node, stop in
      if node.position.y <= 0 - node.frame.maxY * 1.5 {
        node.removeFromParent()
      }
    }
  }
  
  fileprivate func spawnClouds() {
    let spawnCloudsWait = SKAction.wait(forDuration: 1.5)
    let spawnAction = SKAction.run { [weak self] in
      let cloud = Cloud.populate()
      self?.addChild(cloud)
    }
    let actionSeq = SKAction.sequence([spawnCloudsWait, spawnAction])
    let actionRepeat = SKAction.repeatForever(actionSeq)
    run(actionRepeat)
  }
  
  fileprivate func spawnIslands() {
    let spawnIslandsWait = SKAction.wait(forDuration: 1.5)
    let spawnAction = SKAction.run { [weak self] in
      let island = Island.populate()
      self?.addChild(island)
    }
    let actionSeq = SKAction.sequence([spawnIslandsWait, spawnAction])
    let actionRepeat = SKAction.repeatForever(actionSeq)
    run(actionRepeat)
  }
  
  fileprivate func spawnPowerUp() {
    let spawnAction = SKAction.run { [unowned self] in
      let randomNumber = Int(arc4random_uniform(2))
      let powerUp = randomNumber == 1 ? GreenPowerUp() : BluePowerUp()
      let randomX = CGFloat(arc4random_uniform(UInt32(self.size.width) - 30))
      
      powerUp.position = CGPoint(x: randomX, y: self.size.height + 100)
      self.addChild(powerUp)
      powerUp.startMovement()
    }
    
    let randomTimeSpawn = Double(arc4random_uniform(10) + 5)
    let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
    let actionSeq = SKAction.sequence([spawnAction, waitAction])
    run(SKAction.repeatForever(actionSeq))
  }
  
  fileprivate func spawnEnemies() {
    let waitAction = SKAction.wait(forDuration: 3.0)
    let spawnAction = SKAction.run { [unowned self] in
      self.spawnSpiralOfEnemies()
    }
    run(SKAction.repeatForever(SKAction.sequence([waitAction, spawnAction])))
  }
  
  fileprivate func spawnSpiralOfEnemies() {
    let enemyAtlas1 = Assets.shared.enemy_1Atlas
    let enemyAtlas2 = Assets.shared.enemy_2Atlas
    
    let randomNumber = Int(arc4random_uniform(2))
    let arrayOfAtlases = [enemyAtlas1, enemyAtlas2]
    let textureAtlas = arrayOfAtlases[randomNumber]
    
    let waitAction = SKAction.wait(forDuration: 1.0)
    let spawnEnemy = SKAction.run({ [unowned self] in
      let textureNames = textureAtlas.textureNames.sorted()
      let texture = textureAtlas.textureNamed(textureNames[12])
      let enemy = EnemyPlane(enemyTexture: texture)
      enemy.position = CGPoint(x: self.frame.midX, y: self.frame.size.height + 120)
      self.addChild(enemy)
      enemy.flySpiral()
    })
    let actionSeq = SKAction.sequence([waitAction, spawnEnemy])
    let repeatAction = SKAction.repeat(actionSeq, count: 3)
    self.run(repeatAction)
    
  }
  
  fileprivate func playerFire() {
    yellowShot = YellowShot()
    yellowShot.position = playerPlane.position
    yellowShot.startMovement()
    addChild(yellowShot)
  }
  
  fileprivate func showExplosion(contact: SKPhysicsContact) {
    let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")!
    let contactPoint = contact.contactPoint
    explosion.position = contactPoint
    explosion.zPosition = 25
    let waitAction = SKAction.wait(forDuration: 0.7)
    addChild(explosion)
    run(waitAction, completion: {
      explosion.removeFromParent() })
  }
  
  fileprivate func showGameOver() {
    let gameOverScene = GameOverScene(size: size)
    let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
    gameOverScene.scaleMode = .aspectFill
    scene!.view?.presentScene(gameOverScene, transition: transition)
  }
  
  fileprivate func reduceLives(count: Int) {
    switch count {
    case 3:
      hud.life1.isHidden = false
      hud.life2.isHidden = false
      hud.life3.isHidden = false
    case 2:
      hud.life1.isHidden = false
      hud.life2.isHidden = false
      hud.life3.isHidden = true
    case 1:
      hud.life1.isHidden = false
      hud.life2.isHidden = true
      hud.life3.isHidden = true
    case 0:
      gameSettings.currentScore = hud.score
      gameSettings.saveScores()
      showGameOver()
    default: break
    }
  }
  
}

extension GameScene: SKPhysicsContactDelegate {
  
  func didBegin(_ contact: SKPhysicsContact) {
    switchContact(contact: contact)
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    
  }
  
  fileprivate func switchContact(contact: SKPhysicsContact) {
    let contactCategory: BitmaskCategory = [contact.bodyA.category, contact.bodyB.category]
    
    switch contactCategory {
    case [.enemy, .player]:
      check(contact: contact, for: "enemySprite", completion: {
        self.lives -= 1
        self.showExplosion(contact: contact)
      })
      
    case [.enemy, .shot]:
      check(contact: contact, for: "enemySprite", completion: {
        self.hud.score += 5
        if self.gameSettings.isSound {
          self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
        }
        self.yellowShot.removeFromParent()
        self.showExplosion(contact: contact)
      })
      
    case [.powerUp, .player]:
      check(contact: contact, for: "bluePowerUp", completion: {
        self.lives = 3
        self.playerPlane.powerUpAction(with: .blue)
      })
      check(contact: contact, for: "greenPowerUp", completion: {
        self.playerPlane.powerUpAction(with: .green)
      })
      
    default: print("Unable to detect collision category")
      break
    }
  }
  
  fileprivate func check(contact:  SKPhysicsContact, for name: String, completion: (() -> ())?) {
    let aNode = contact.bodyA.node
    let bNode = contact.bodyB.node
    
    if aNode?.parent != nil && bNode?.parent != nil {
      if aNode?.name == name {
        aNode?.removeFromParent()
        completion!()
      } else if bNode?.name == name{
        bNode?.removeFromParent()
        completion!()
      }
    }
  }
}
