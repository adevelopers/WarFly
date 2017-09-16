//
//  BestScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 14.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class BestScene: ParentScene {

  var places: [Int]!
  
  override func didMove(to view: SKView) {
    setHeader(with: "best", and: "header_background")
    
    gameSettings.loadScores()
    places = gameSettings.highscore
    
    let titles = ["back"]
    
    for (index, title) in titles.enumerated() {
      let button = ButtonNode(title: title, backgroundName: "button_background")
      button.position = CGPoint(x: frame.midX, y: frame.midY - 200 + CGFloat(index * 100))
      button.name = title
      button.label.name = title
      addChild(button)
    }
    
    for (index, value) in places.enumerated() {
      let l = SKLabelNode(text: value.description)
      l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
      l.fontName = "AmericanTypewriter-Bold"
      l.fontSize = 30
      l.position = CGPoint(x: frame.midX, y: frame.midY - CGFloat(index * 60))
      addChild(l)
    }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first!.location(in: self)
    let node = atPoint(location)
    if node.name == "back" {
      let transition = SKTransition.crossFade(withDuration: 1.0)
      guard let backScene = backScene else { return }
      backScene.scaleMode = .aspectFill
      scene!.view?.presentScene(backScene, transition: transition)
    }
  }

  
}
