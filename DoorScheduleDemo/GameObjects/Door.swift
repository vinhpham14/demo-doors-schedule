//
//  Door.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SpriteKit

enum DoorType {
  case high
  case medium
  case low
  case unknown
  
  public var timeRange: ClosedRange<UInt> {
    switch self {
    case .high:
      return Config.typeOneTimeRange
    case .medium:
      return Config.typeTwoTimeRange
    case .low:
      return Config.typeThreeTimeRange
    default:
      fatalError("unexpected state")
    }
  }
}

class Door : BaseObject {
  
  // MARK: - Instance Properties
  public var queue = [Person]()
  public lazy var emptyPosition: CGPoint = {
    return position
  }()
  public lazy var finishPosition: CGPoint = {
    return CGPoint(x: 667 - Config.personSize.width, y: position.y)
  }()
  public var type: DoorType = .unknown
  public var beginProcessPublisher = PublishSubject<Person>()
  
  // MARK: - Instance Life Circles
  override init() {
    super.init()
    beginProcessPublisher
      .do(onNext: { [unowned self] p in
        self.state = .inProcess
        self.fillColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
      })
      .flatMap({ p in
        return Observable<Person>.create { [unowned self] observer in
          // NSLog("processing")
          let time = TimeInterval(UInt.random(in: self.type.timeRange))
          self.run(SKAction.wait(forDuration: time)) {
            observer.onNext(p)
          }
          return Disposables.create()
        }
      })
      .subscribe(onNext: { [unowned self] p in
        p.state = .done
        self.state = .idle
        self.fillColor = .clear
        self.moveLine()
      })
      .disposed(by: bag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Instance Functions
  public func append(_ person: Person) {
    queue.append(person)
    person.move(to: emptyPosition)
    emptyPosition = CGPoint(x: emptyPosition.x - person.frame.size.width, y: emptyPosition.y)
  }
  
  public func remove(_ person: Person) {
    queue.removeAll { $0 === person }
  }
  
  public func moveLine() {
    for p in queue {
      if (p.state == .done) {
        p.move(to: finishPosition)
      } else {
        let pos = CGPoint(x: p.position.x + Config.personSize.width, y: p.position.y)
        p.move(to: pos, duration: 0.1)
      }
    }
  }
  
  public func proceed(_ person: Person) {
//    Events.willProceed.onNext((door: self, person: person))
//    Events.didProceed.onNext((door: self, person: person))
  }
  
}

extension Door {
  func update(_ currentTime: TimeInterval) {
    
    // Check if ready to proceed
    if let person = getCurrentPerson() {
      if (frame.contains(person.frame) && person.state == .idle && !person.hasActions()) {
        person.state = .inProcess
        beginProcessPublisher.onNext(person)
      }
    }
    
  }
  
  func getCurrentPerson() -> Person? {
    var index = 0
    var person: Person? = nil
    while (index < queue.count) {
      let p = queue[index]
      if p.state == .done {
        index += 1
      } else {
        person = p
        break
      }
    }
    return person
  }
  
}
