//
//  OptionsScene.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 14.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

class OptionsScene: ParentScene {
  
  var isMusic: Bool!
  var isSound: Bool!
  
  override func didMove(to view: SKView) {
    isMusic = gameSettings.isMusic
    isSound = gameSettings.isSound
    
    setHeader(with: "pause", and: "header_background")
    
    let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
    let musicButton = ButtonNode(title: nil, backgroundName: backgroundNameForMusic)
    musicButton.position = CGPoint(x: frame.midX - 50, y: frame.midY)
    musicButton.name = "music"
    musicButton.label.isHidden = true
    addChild(musicButton)
    
    let backgroundNameForSound = isSound == true ? "sound" : "nosound"
    let soundButton = ButtonNode(title: nil, backgroundName: backgroundNameForSound)
    soundButton.position = CGPoint(x: frame.midX + 50, y: frame.midY)
    soundButton.name = "sound"
    soundButton.label.isHidden = true
    addChild(soundButton)
    
    let backButton = ButtonNode(title: "back", backgroundName: "button_background")
    backButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
    backButton.name = "back"
    backButton.label.name = "back"
    addChild(backButton)

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let location = touches.first!.location(in: self)
    let node = atPoint(location)
    if node.name == "music" {
      isMusic = !isMusic
      update(node: node as! SKSpriteNode, value: isMusic)
      
    } else if node.name == "sound" {
      isSound = !isSound
      update(node: node as! SKSpriteNode, value: isSound)
      
    } else if node.name == "back" {
      gameSettings.isSound = isSound
      gameSettings.isMusic = isMusic
      gameSettings.saveGameSettings()
      let transition = SKTransition.crossFade(withDuration: 1.0)
      guard let backScene = backScene else { return }
      backScene.scaleMode = .aspectFill
      scene!.view?.presentScene(backScene, transition: transition)
    }
  }
  
  func update(node: SKSpriteNode, value: Bool) {
    if let name = node.name {
      node.texture = value ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
    }
  }
  
}
