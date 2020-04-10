//
//  Settings.swift
//  DoorScheduleDemo
//
//  Created by LAP12230 on 4/9/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import SpriteKit

enum Config {
  public static let doorSize = CGSize(width: 40, height: 40)
  public static let entranceSize = CGSize(width: 40, height: 40)
  public static let personSize = CGSize(width: 20, height: 20)
  public static let horizontalDistance = CGFloat(500)
  
  public static let overallSpeed: Double = 2.0
  
  public static let startTime: TimeInterval = 0 / Config.overallSpeed
  public static let moveTime: TimeInterval = 2 / Config.overallSpeed
  public static let spawnTime: TimeInterval = 1 / Config.overallSpeed
  
  // Gameplay
  public static let personCount: Int = 10
  
  public static let spaceFromDoorAndLine: CGFloat = 50
  
  public static let typeOneRate: Double = 0.1
  public static let typeTwoRate: Double = 0.3
  public static let typeThreeRate: Double = 0.6
  
  public static let typeOneTimeRange: ClosedRange<UInt> = 2...3
  public static let typeTwoTimeRange: ClosedRange<UInt> = 1...4
  public static let typeThreeTimeRange: ClosedRange<UInt> = 3...7
  
  
  // Hotfix
  public static let waitAfterNextAction: TimeInterval = 0.1 / Config.overallSpeed
}
