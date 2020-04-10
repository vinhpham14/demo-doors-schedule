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
    
  public var typeOneCount: Int
  public var typeTwoCount: Int
  public var typeThreeCount: Int
  
  init(count: Int) {
    typeOneCount = Int((Config.typeOneRate * Double(count)).rounded())
    typeTwoCount = Int((Config.typeTwoRate * Double(count)).rounded())
    typeThreeCount = count - typeOneCount - typeTwoCount
    
    self.queue = []
    self.count = count
    var person: Person!
    for _ in 1...typeOneCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .business
      person.fillColor = person.type.color
      queue.append(person)
    }
    
    for _ in 1...typeTwoCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .online
      person.fillColor = person.type.color
      queue.append(person)
    }
    
    for _ in 1...typeThreeCount {
      person = Person(ellipseOf: Config.personSize)
      person.type = .normal
      person.fillColor = person.type.color
      queue.append(person)
    }
    
    self.queue.shuffle()
  }
  
  func pop() -> Person? {
    let canPop = (currentIndex <= queue.count - 1)
    if (canPop) {
      let type = queue[currentIndex].type
      if type == .business {
        self.typeOneCount -= 1
      } else if type == .online {
        self.typeTwoCount -= 1
      } else if type == .normal {
        self.typeThreeCount -= 1
      } else {
        fatalError("ERROR")
      }
    }
    
    defer { currentIndex += canPop ? 1 : 0 }
    return canPop ? queue[currentIndex] : nil
  }
}
