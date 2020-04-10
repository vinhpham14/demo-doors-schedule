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
  
  public var color: UIColor {
    switch self {
    case .business:
      return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    case .online:
      return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    case .normal:
      return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    default:
      fatalError("ERROR")
    }
  }
}

class Person : BaseObject {
  
  // MARK: - Instance Properties
  public var type: PersonType = .unknown
  public var targetPosition: CGPoint!
  public var targetDoor: Door!
  public var isProcessing: Bool = false
  
  // MARK: - Instance functions
  public func moveToDoor(to point: CGPoint,
                   duration: TimeInterval = Config.moveTime,
                   completion: (()-> Void)? = nil) {
    state = .onGoing
    self.run(SKAction.sequence([
      SKAction.move(to: point, duration: Config.moveTime),
      SKAction.wait(forDuration: Config.waitAfterNextAction), // FIXME: Hot fix for wrong position after stop moving
      SKAction.run { [unowned self] in
        Events.personDidArrivedDoor.onNext((self.targetDoor, self))
        completion?()
      }
    ]), withKey: ActionKeys.personGoingToTarget)
  }
  
  public func move(to point: CGPoint,
                   duration: TimeInterval = Config.moveTime,
                   completion: (()-> Void)? = nil) {
    state = .onGoing
    self.run(SKAction.sequence([
      SKAction.move(to: point, duration: Config.moveTime),
      SKAction.wait(forDuration: Config.waitAfterNextAction), // FIXME: Hot fix for wrong position after stop moving
      SKAction.run { [unowned self] in
        completion?()
      }
    ]), withKey: ActionKeys.personMove)
  }
}

extension Person {
  func update(_ currentTime: TimeInterval) {
//    if (state == .idle) {
//      let rightPos = targetDoor.rightPositionOfPerson(self)
//      if position != rightPos {
//        self.run(SKAction.move(to: rightPos, duration: 0.1))
//      }
//    }
  }
}


