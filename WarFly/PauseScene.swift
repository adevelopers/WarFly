//
//  PauseScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 14.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class PauseScene: ParentScene {
  
  override func didMove(to view: SKView) {
    setHeader(with: "pause", and: "header_background")
    
    let titles = ["restart", "options", "resume"]
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
      
    } else if node.name == "resume" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      guard let gameScene = sceneManager.gameScene else { return }
      gameScene.scaleMode = .aspectFill
      scene!.view?.presentScene(gameScene, transition: transition)
      
    } else if node.name == "options" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let optionsScene = OptionsScene(size: size)
      optionsScene.backScene = self
      optionsScene.scaleMode = .aspectFill
      scene!.view?.presentScene(optionsScene, transition: transition)
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
