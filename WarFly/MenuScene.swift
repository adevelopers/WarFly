//
//  MainScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class MenuScene: ParentScene {

  override func didMove(to view: SKView) {
    if !(Assets.shared.isLoaded) {
      Assets.shared.preloadAssets()
      Assets.shared.isLoaded = true
    }
    setHeader(with: nil, and: "header")
    
    let titles = ["play", "options", "best"]
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
    if node.name == "play" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let gameScene = GameScene(size: self.size)
      gameScene.scaleMode = .aspectFill
      scene?.view?.presentScene(gameScene, transition: transition)
      
    } else if node.name == "options" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      let optionsScene = OptionsScene(size: size)
      optionsScene.backScene = self
      optionsScene.scaleMode = .aspectFill
      scene!.view?.presentScene(optionsScene, transition: transition)
      
    } else if node.name == "best" {
      let transition = SKTransition.fade(withDuration: 1.0)
      let bestScene = BestScene(size: size)
      bestScene.backScene = self
      bestScene.scaleMode = .aspectFill
      scene!.view?.presentScene(bestScene, transition: transition)
    }
  }
  
}
