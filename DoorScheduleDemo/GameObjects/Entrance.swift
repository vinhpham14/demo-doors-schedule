//
//  Entrance.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SpriteKit

class Entrance : BaseObject {
  
  // MARK: - Instance Properties
  public var newPerson = PublishSubject<Person>()
  
}
