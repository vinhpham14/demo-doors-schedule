//
//  GameScene.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import SpriteKit
import RxSwift
import RxCocoa

enum GameSceneActionKey {
  public static let spawnPerson = "SPAWN_PERSON"
}


class GameScene : SKScene {
  
  // MARK: - Instance properties
  public let basicController = BasicController()
  public var entrance: Entrance!
  public var doorHigh: Door!
  public var doorMedium: Door!
  public var doorLow: Door!
  public var pool = Pool(count: Config.personCount)
  public lazy var doors: [Door] = {
    return [doorLow, doorMedium, doorHigh]
  }()
  
  // MARK: - Object life cycles
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    self.delegate = self
    _createNodes()
    _layoutNodes()
    basicController.setupObserver(self)
    
    // Action
    let createPerson = _createPersonAtEntrance()
    run(
      SKAction.sequence([
        SKAction.wait(forDuration: Config.startTime),
        SKAction.repeatForever(
          SKAction.sequence([
            createPerson,
            SKAction.wait(forDuration: Config.spawnTime)
          ])
        )
      ]),
      withKey: GameSceneActionKey.spawnPerson
    )
  }
  
  // MARK: - Instance functions
  
  private func _createPersonAtEntrance() -> SKAction {
    return SKAction.customAction(withDuration: 0) { [unowned self] (_, _) in
      let person = self.pool.pop()
      if let person = person {
        person.position = self.entrance.position
        self.addChild(person)
        Events.newPerson.onNext(person)
      } else {
        self.removeAction(forKey: GameSceneActionKey.spawnPerson)
      }
    }
  }
  
  private func _createNodes() {
    entrance = Entrance(ellipseOf: Config.entranceSize)
    doorHigh = Door(ellipseOf: Config.doorSize)
    doorMedium = Door(ellipseOf: Config.doorSize)
    doorLow = Door(ellipseOf: Config.doorSize)
    
    doorLow.type = .low
    doorMedium.type = .medium
    doorHigh.type = .high
    
    for node in [doorLow, doorMedium, doorHigh, entrance] {
      addChild(node!)
    }
  }
  
  private func _layoutNodes() {
    let horizontalDistance: CGFloat = Config.horizontalDistance
    entrance.position = CGPoint(x: 40, y: frame.height / 2)
    doorMedium.position = CGPoint(x: horizontalDistance, y: frame.height / 2)
    doorLow.position = CGPoint(x: horizontalDistance, y: 40)
    doorHigh.position = CGPoint(x: horizontalDistance, y: frame.height - 40)
  }
}

extension GameScene : SKSceneDelegate {
  override func update(_ currentTime: TimeInterval) {
    for d in doors {
      d.update(currentTime)
    }
  }
}

protocol Updatable {
  func update(_ currentTime: TimeInterval)
}

extension Updatable {
  public func update(_ currentTime: TimeInterval) {
    fatalError("not implement yet.")
  }
}
