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


class BasicController: GameController {
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
        door.append(person)
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
