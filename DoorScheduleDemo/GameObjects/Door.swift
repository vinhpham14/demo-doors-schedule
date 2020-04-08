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
}

class Door : BaseObject {
  
  // MARK: - Instance Properties
  public var type: DoorType = .unknown
  
}
