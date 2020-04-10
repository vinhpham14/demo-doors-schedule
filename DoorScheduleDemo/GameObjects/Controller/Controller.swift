//
//  Controller.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SpriteKit

protocol GameController {
  associatedtype SceneType where SceneType: SKScene
  
  func update(_ scene: SceneType, currentTime: TimeInterval)
  func setupObserver(_ scene: SceneType)
}


class Controller: GameController {
  typealias SceneType = GameScene
  
  let disposeBag = DisposeBag()
  var presentScene: SceneType!
  
  public func update(_ scene: GameScene, currentTime: TimeInterval) {
    
  }
  
  public func setupObserver(_ scene: GameScene) {
    
    presentScene = scene
    
    Events.newPerson
      .subscribe(onNext: { [unowned self] person in
        let door = self.pickDoor(person)
        person.targetPosition = door.emptyPosition
        person.targetDoor = door
        person.moveToDoor(to: person.targetPosition)
        door.personsComing.append(person)
      })
      .disposed(by: disposeBag)
    
    Events.personDidArrivedDoor
      .subscribe(onNext: { pair in
        pair.person.state = .idle
        pair.door.personsComing.removeAll { $0 === pair.person }
        pair.door.personsInLine.append(pair.person)
      })
      .disposed(by: disposeBag)
    
    Events.doorEmpty
      .subscribe(onNext: { context in
        var pickDoor = context.scene.doors[0]
        for door in context.scene.doors {
          if door === context.emptyDoor { continue }
          pickDoor = pickDoor.estimatedRemainingTime() < door.estimatedRemainingTime()
            ? door
            : pickDoor
        }
        
        if pickDoor.estimatedRemainingTime() < context.emptyDoor.type.timeRange.lowerBound + UInt(Config.moveTime) { return }
        if (pickDoor.personsComing.count > 0) {
          let p = pickDoor.personsComing.popLast()
          if let p = p,
            (p.state == .idle)
              && p.isProcessing == false {
            p.removeAllActions()
            p.targetPosition = context.emptyDoor.emptyPosition
            p.targetDoor = context.emptyDoor
            p.moveToDoor(to: p.targetPosition)
            context.emptyDoor.personsComing.append(p)
          }
        } else {
          let p = pickDoor.personsInLine.popLast()
          if let p = p,
            (p.state == .idle)
              && p.isProcessing == false {
            p.removeAllActions()
            p.targetPosition = context.emptyDoor.emptyPosition
            p.targetDoor = context.emptyDoor
            p.moveToDoor(to: p.targetPosition)
            context.emptyDoor.personsComing.append(p)
          }
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Instance functions
  private func pickDoor(_ person: Person) -> Door {
    var door: Door!
    switch person.type {
    case .business: door = self.presentScene.doorHigh
    case .online: door = self.presentScene.doorMedium
    case .normal: door = self.presentScene.doorLow
    case .unknown: fatalError("unknown state")
    }
    return door
  }
  
}
