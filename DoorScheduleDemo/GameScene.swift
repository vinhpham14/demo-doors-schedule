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


// Wrap up everything happen in a game with RxSwift
final class Events {
  
  // Time
  static public let oneSecondPassed = PublishSubject<Void>()
  
  // Objects
  static public let newPerson = PublishSubject<Person>()
}


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
  public var pool = Pool(count: Settings.personCount)
  public lazy var doors: [Door] = {
    return [doorLow, doorMedium, doorHigh]
  }()
  
  // MARK: - Object life cycles
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    _createNodes()
    _layoutNodes()
    basicController.setupObserver(self)
    
    // Action
    let createPerson = _createPersonAtEntrance()
    run(
      SKAction.repeatForever(
        SKAction.sequence([
          createPerson,
          SKAction.wait(forDuration: 1)
        ])
      ),
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
    entrance = Entrance(ellipseOf: Settings.entranceSize)
    doorHigh = Door(ellipseOf: Settings.doorSize)
    doorMedium = Door(ellipseOf: Settings.doorSize)
    doorLow = Door(ellipseOf: Settings.doorSize)
    
    for node in [doorLow, doorMedium, doorHigh, entrance] {
      addChild(node!)
    }
  }
  
  private func _layoutNodes() {
    let horizontalDistance: CGFloat = 300
    entrance.position = CGPoint(x: 40, y: frame.height / 2)
    doorMedium.position = CGPoint(x: horizontalDistance, y: frame.height / 2)
    doorLow.position = CGPoint(x: horizontalDistance, y: 40)
    doorHigh.position = CGPoint(x: horizontalDistance, y: frame.height - 40)
  }
}

enum Settings {
  public static let doorSize = CGSize(width: 40, height: 40)
  public static let entranceSize = CGSize(width: 40, height: 40)
  public static let personSize = CGSize(width: 20, height: 20)
  
  public static let moveTime: TimeInterval = 2
  
  // Gameplay
  public static let personCount: Int = 10
  public static let typeOneRate: Double = 0.1
  public static let typeTwoRate: Double = 0.3
  public static let typeThreeRate: Double = 0.6
}

extension GameScene : SKSceneDelegate {
  override func update(_ currentTime: TimeInterval) {
    
    basicController.update(self, currentTime: currentTime)
    
    // Update child
    //    for child in children {
    //      if let child = child as? BaseObject {
    //        // child.update(currentTime)
    //      }
    //    }
  }
}

protocol TimeSynchronizable {
  func update(_ currentTime: TimeInterval)
}

extension TimeSynchronizable {
  public func update(_ currentTime: TimeInterval) {
    fatalError("not implement yet.")
  }
}

enum PersonType {
  case business
  case online
  case normal
  case unknown
}

class Pool {
  public var queue: [Person]
  public var count: Int
  public var currentIndex = 0
  init(count: Int) {
    let typeOneCount = Int((Settings.typeOneRate * Double(count)).rounded())
    let typeTwoCount = Int((Settings.typeTwoRate * Double(count)).rounded())
    let typeThreeCount = count - typeOneCount - typeTwoCount
    
    self.queue = []
    self.count = count
    var person: Person!
    for _ in 1...typeOneCount {
      person = Person(ellipseOf: Settings.personSize)
      person.type = .business
      queue.append(person)
    }
    
    for _ in 1...typeTwoCount {
      person = Person(ellipseOf: Settings.personSize)
      person.type = .online
      queue.append(person)
    }
    
    for _ in 1...typeThreeCount {
      person = Person(ellipseOf: Settings.personSize)
      person.type = .normal
      queue.append(person)
    }
    
    self.queue.shuffle()
  }
  
  func pop() -> Person? {
    let canPop = (currentIndex < queue.count - 1)
    defer { currentIndex += 1 }
    return canPop ? queue[currentIndex] : nil
  }
}
