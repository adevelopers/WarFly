//
//  GameOverScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 15.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class GameOverScene: ParentScene {

  override func didMove(to view: SKView) {
    setHeader(with: "game over", and: "header_background")
    
    let titles = ["restart", "options", "best"]
    for (index, title) in titles.enumerated() {
      createButton(with: title, yMultiplier: index)
    }
  }
  
  fileprivate func createButton(with title: String, yMultiplier: Int) {
    let button = ButtonNode(title: title, backgroundName: "button_background")
    button.position = CGPoint(x: frame.midX, y: frame.midY - CGFloat(yMultiplier * 100))
    button.name = title
    button.label.name = title
    addChild(button)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first!.location(in: self)
    let node = atPoint(location)
    if node.name == "restart" {
      sceneManager.gameScene = nil
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let gameScene = GameScene(size: self.size)
      gameScene.scaleMode = .aspectFill
      scene?.view?.presentScene(gameScene, transition: transition)
      
    } else if node.name == "options" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let optionScene = OptionsScene(size: size)
      optionScene.backScene = self
      optionScene.scaleMode = .aspectFill
      scene!.view?.presentScene(optionScene, transition: transition)
      
    } else if node.name == "best" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let bestScene = BestScene(size: size)
      bestScene.backScene = self
      bestScene.scaleMode = .aspectFill
      scene!.view?.presentScene(bestScene, transition: transition)
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    if let gameScene = sceneManager.gameScene {
      if !gameScene.isPaused {
        gameScene.isPaused = true
      }
    }
  }
  
}
