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
  
  public var queue = [Person]()
  public lazy var emptyPosition: CGPoint = {
    return position
  }()
  
  // MARK: - Instance Properties
  public var type: DoorType = .unknown
  public var isProceeding: Bool = false
  
  // MARK: - Instance Functions
  public func append(_ person: Person) {
    queue.append(person)
    person.move(to: emptyPosition)
    emptyPosition = CGPoint(x: emptyPosition.x - person.frame.size.width, y: emptyPosition.y)
  }
  
  public func remove(_ person: Person) {
    queue.removeAll { $0 === person }
  }
  
  public func proceed(_ person: Person) {
//    Events.willProceed.onNext((door: self, person: person))
//    Events.didProceed.onNext((door: self, person: person))
  }
  
}
