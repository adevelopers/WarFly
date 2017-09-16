//
//  ParentScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 14.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class ParentScene: SKScene {
  
  let gameSettings = GameSettings()
  let sceneManager = SceneManager.shared
  var backScene: SKScene?
  
  func setHeader(with name: String?, and backgroundName: String) {
    let header = ButtonNode(title: name, backgroundName: backgroundName)
    header.position = CGPoint(x: frame.midX, y: frame.midY + 150)
    addChild(header)
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
