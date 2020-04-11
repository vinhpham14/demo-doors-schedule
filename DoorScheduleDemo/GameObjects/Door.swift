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
  
  // MARK: - Processing
  public var processingPerson: Person?
  public var personCompletedCount: Int = 0
  
  // MARK: - Instance Properties
  public var personsComing = [Person]()
  public var personsInLine = [Person]()
  public var emptyPosition: CGPoint {
    var currentPersons = [Person]()
    let temp = personsInLine.filter{ $0.state == .idle }
    currentPersons.append(contentsOf: temp)
    currentPersons.append(contentsOf: self.personsComing)
    let x = currentPersons.reduce(position.x - Config.spaceFromDoorAndLine) { sum, _ in
      return sum - Config.personSize.width
    }
    
    return CGPoint(x: x, y: position.y)
  }
  public lazy var finishPosition: CGPoint = {
    return CGPoint(x: 667 - Config.personSize.width, y: position.y)
  }()
  public var type: DoorType = .unknown
  public var beginProcessPublisher = PublishSubject<Person>()
  
  // MARK: - Instance Life Circles
  override init() {
    super.init()
    /* beginProcessPublisher
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
      .disposed(by: bag) */
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Instance Functions
  public func append(_ person: Person) {
    
  }
  
  public func remove(_ person: Person) {
    // queue.removeAll { $0 === person }
  }
  
  public func estimatedRemainingTime() -> Int {
    let overageTime = (self.type.timeRange.upperBound + self.type.timeRange.lowerBound) / 2
    return self.countLeftPerson() * Int(overageTime)
  }
  
  public func countLeftPerson() -> Int {
    var currentPersons = [Person]()
    let temp = personsInLine.filter{ $0.state == .idle }
    currentPersons.append(contentsOf: temp)
    currentPersons.append(contentsOf: self.personsComing)
    return currentPersons.count
  }
  
  public func rightPositionOfPerson(_ person: Person) -> CGPoint {
    if let index = personsInLine.firstIndex(of: person) {
      let x = position.x - Config.spaceFromDoorAndLine - CGFloat(index) * Config.personSize.width
      return CGPoint(x: x, y: position.y)
    }
    fatalError("ERROR")
  }
  
  public func rightPositionOfPerson(_ index: Int) -> CGPoint {
    let x = position.x - Config.spaceFromDoorAndLine - CGFloat(index) * Config.personSize.width
    return CGPoint(x: x, y: position.y)
  }
  
}

extension Door {
  func update(_ currentTime: TimeInterval) {
    
    // Pick person
    if (state == .idle
      && processingPerson == nil
      && personsInLine.filter({$0.state != .done}).count > 0) {
      
      let nextPerson = self.personsInLine.first { $0.state == .idle }
      if let nextPerson = nextPerson {
        nextPerson.state = .inProcess
        nextPerson.isProcessing = true
        state = .inPrepare
        
        nextPerson.move(to: position) { [unowned self] in
          
          ///
          /// Next person was at process zone
          ///
          // update lines
          var index = 0
          for p in self.personsInLine.filter({ $0.state == .idle }) {
            p.run(SKAction.move(to: self.rightPositionOfPerson(index), duration: Config.moveTime))
            index += 1
          }
          
          self.processingPerson = nextPerson
          self.state = .inProcess
          let time = TimeInterval(UInt.random(in: self.type.timeRange))
          self.run(SKAction.sequence([
            SKAction.wait(forDuration: time),
            
            // Complete processing
            SKAction.run {
              self.processingPerson!.run(SKAction.move(to: self.finishPosition, duration: Config.moveTime))
              self.processingPerson!.state = .done
              self.processingPerson = nil
              self.state = .idle
              self.personCompletedCount += 1
            }
          ]))
        }
      }
    }
    
    // Update color
    fillColor = state == .inProcess ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : .clear
    
    // Update line
    // self.updateLine()
  }
  
  func updateLine() {
    var x = position.x - Config.spaceFromDoorAndLine
    for p in personsInLine.filter({ $0.state == .idle }) {
      let point = CGPoint(x: x, y: position.y)
      x -= Config.personSize.width
      p.moveToDoor(to: point, duration: 1.0)
    }
  }
  
}
