//
//  BitmaskCategory.swift
//  WarFly
//
//  Created by Dmitry Shadrin on 13.09.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import SpriteKit

extension SKPhysicsBody {
  var category: BitmaskCategory {
    get {
      return BitmaskCategory(rawValue: self.categoryBitMask)
    }
    set {
      self.categoryBitMask = newValue.rawValue
    }
  }
}

struct BitmaskCategory: OptionSet {
  let rawValue: UInt32
  
  static let none = BitmaskCategory(rawValue: 0 << 0)
  static let player = BitmaskCategory(rawValue: 1 << 0)
  static let enemy = BitmaskCategory(rawValue: 1 << 1)
  static let powerUp = BitmaskCategory(rawValue: 1 << 2)
  static let shot = BitmaskCategory(rawValue: 1 << 3)
  static let all = BitmaskCategory(rawValue: UInt32.max)
}
