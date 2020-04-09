//
//  Events.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/9/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import SpriteKit
import RxSwift

typealias ProcessPair = (door: Door, person: Person)

// Wrap up everything happen in a game with RxSwift
final class Events {
  
  // Time
  static public let oneSecondPassed = PublishSubject<Void>()
  
  // Objects
  static public let newPerson = PublishSubject<Person>()
  static public let willProceed = PublishSubject<ProcessPair>()
  static public let didProceed = PublishSubject<ProcessPair>()
  static public let newPersonOnDoor = PublishSubject<ProcessPair>()
}
