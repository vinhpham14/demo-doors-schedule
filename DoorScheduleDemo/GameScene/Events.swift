//
//  Events.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/9/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import SpriteKit
import RxSwift

typealias Pair = (door: Door, person: Person)
typealias CurrentContext = (emptyDoor: Door, scene: GameScene)

// Wrap up everything happen in a game with RxSwift
final class Events {
  
  // Time
  static public let oneSecondPassed = PublishSubject<Void>()
  
  // Objects
  static public let newPerson = PublishSubject<Person>()
  static public let willProceed = PublishSubject<Pair>()
  static public let didProceed = PublishSubject<Pair>()
  static public let newPersonOnDoor = PublishSubject<Pair>()
  static public let personDidArrivedDoor = PublishSubject<Pair>()
  static public let doorEmpty = PublishSubject<CurrentContext>()
}
