//
//  Pool.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/9/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import UIKit
import RxSwift

class Pool {
  public var queue: [Person]
  public var count: Int
  public var currentIndex = 0
  init(count: Int) {
    let typeOneCount = Int((Config.typeOneRate * Double(count)).rounded())
    let typeTwoCount = Int((Config.typeTwoRate * Double(count)).rounded())
    let typeThreeCount = count - typeOneCount - typeTwoCount
    
    self.queue = []
    self.count = count
    var person: Person!
    for _ in 1...typeOneCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .business
      queue.append(person)
    }
    
    for _ in 1...typeTwoCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .online
      queue.append(person)
    }
    
    for _ in 1...typeThreeCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .normal
      queue.append(person)
    }
    
    self.queue.shuffle()
  }
  
  func pop() -> Person? {
    NSLog("pop: \(currentIndex)")
    let canPop = (currentIndex <= queue.count - 1)
    defer { currentIndex += canPop ? 1 : 0 }
    return canPop ? queue[currentIndex] : nil
  }
}
