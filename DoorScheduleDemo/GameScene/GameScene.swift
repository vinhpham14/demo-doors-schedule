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

enum ActionKeys {
  public static let spawnPerson = "SPAWN_PERSON"
  public static let personGoingToTarget = "PERSON_GOING_TO_TARGET"
  public static let personMove = "PERSON_MOVE"
}


class GameScene : SKScene {
  
  // MARK: - Instance properties
  
  public var currentTick: Int64 = 0
  public var currentSecond: Int64 = 0
  
  public let basicController = Controller()
  public var entrance: Entrance!
  public var doorHigh: Door!
  public var doorMedium: Door!
  public var doorLow: Door!
  public var textA: SKLabelNode!
  public var textB: SKLabelNode!
  public var textC: SKLabelNode!
  public var pool = Pool(count: 1_000_000)//Config.personCount)
  // public var pool = Pool(typeOne: 2, typeTwo: 30, typeThree: 60)
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
      withKey: ActionKeys.spawnPerson
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
        self.removeAction(forKey: ActionKeys.spawnPerson)
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
    
    textA = SKLabelNode(text: "0")
    textB = SKLabelNode(text: "0")
    textC = SKLabelNode(text: "0")
    
    for node in [doorLow, doorMedium, doorHigh, entrance, textA, textB, textC] {
      addChild(node!)
    }
  }
  
  private func _layoutNodes() {
    let horizontalDistance: CGFloat = Config.horizontalDistance
    entrance.position = CGPoint(x: 40, y: frame.height / 2)
    
    doorHigh.position = CGPoint(x: horizontalDistance, y: frame.height - 40)
    doorMedium.position = CGPoint(x: horizontalDistance, y: frame.height / 2)
    doorLow.position = CGPoint(x: horizontalDistance, y: 40)
    
    textA.position = CGPoint(x: doorHigh.position.x + 50.0, y: doorHigh.position.y - 10)
    textB.position = CGPoint(x: doorMedium.position.x + 50.0, y: doorMedium.position.y - 10)
    textC.position = CGPoint(x: doorLow.position.x + 50.0, y: doorLow.position.y - 10)
  }
}

extension GameScene : SKSceneDelegate {
  override func update(_ currentTime: TimeInterval) {
    
    self.currentTick += 1
    if (self.currentTick % 60 == 0) {
      self.currentSecond += 1
      debugPrint(self.currentSecond)
    }
    
    ///
    /// Update door
    ///
    for d in doors {
      d.update(currentTime)
      
      //
      // Check if door is empty
      //
      let type = d.type
      
      // Find associated person type of this door
      var personByTypeRemaining = 0
      if type == .high {
        personByTypeRemaining = pool.typeOneCount
      } else if type == .medium {
        personByTypeRemaining = pool.typeTwoCount
      } else if type == .low {
        personByTypeRemaining = pool.typeThreeCount
      }
      if d.countLeftPerson() == 0 && d.state == .idle && personByTypeRemaining <= 0 {
        Events.doorEmpty.onNext((emptyDoor: d, scene: self))
      }
    }
    
    ///
    /// Update person
    ///
    for n in children {
      if let n = n as? Person {
        n.update(currentTime)
      }
    }
    
    ///
    /// Update completion count
    ///
    textA.text = String(doorHigh.personCompletedCount)
    textB.text = String(doorMedium.personCompletedCount)
    textC.text = String(doorLow.personCompletedCount)
    
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
