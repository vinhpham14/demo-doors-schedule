//
//  GameScene.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/8/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import SpriteKit
import RxSwift

class GameScene : SKScene {
    
}

class BaseObject : SKShapeNode {
    
}

class Entrance : BaseObject {
    
    //MARK: - Instance Property
    public var newPerson = BehaviorRelay<Person>(value: Person())
    
    
}

enum PersonType {
    case high
    case medium
    case low
}

class Person : BaseObject {
    
    
    
}
