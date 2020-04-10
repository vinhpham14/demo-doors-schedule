//
//  Person.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SpriteKit

enum PersonType {
  case business
  case online
  case normal
  case unknown
}

class Person : BaseObject {
  
  // MARK: - Instance Properties
  public var type: PersonType = .unknown
  
  // MARK: - Instance functions
  public func move(to point: CGPoint, duration: TimeInterval = Config.moveTime) {
    self.run(SKAction.move(to: point, duration: Config.moveTime))
  }
}


