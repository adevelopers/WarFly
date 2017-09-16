//
//  GameViewController.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 11.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = self.view as! SKView? {
      let scene = MenuScene(size: view.bounds.size)
      scene.scaleMode = .aspectFill
      view.presentScene(scene)
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
