//
//  BaseObject.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import SpriteKit
import RxSwift
import RxCocoa

enum State {
  case idle
  case inProcess
  case done
}

class BaseObject : SKShapeNode, Updatable {
  
  // MARK: - Instance Properties
  public let bag = DisposeBag()
  public var state: State = .idle
  
  // MARK: - Instance Methods
  
  
}
