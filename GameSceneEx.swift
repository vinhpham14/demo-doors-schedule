//
//  GameScene.swift
//  Game101
//
//  Created by LAP12230 on 4/5/20.
//  Copyright © 2020 LAP12230. All rights reserved.
//

import Foundation
import GameKit

//class GameSceneEx: SKScene {
//  
//  private lazy var doors: Array<DoorNode> = {
//    let doorC = self.createDoor(position: CGPoint(x: self.size.width / 3, y: 40))
//    let doorB = self.createDoor(position: CGPoint(x: self.size.width / 3, y: self.size.height / 2))
//    let doorA = self.createDoor(position: CGPoint(x: self.size.width / 3, y: self.size.height - 40))
//    return [doorA, doorB, doorC]
//  }()
//  
//  private lazy var queue: QueueNode = {
//    let position = CGPoint(x: 20, y: self.size.height / 2)
//    return self.createQueue(position: position)
//  }()
//  
//  private var persons = Array<PersonNode>()
//  
//  override func didMove(to view: SKView) {
//    
//    // Add nodes
//    addChild(queue)
//    self.doors.forEach { addChild($0) } 
//    
//    // Action
//    let spawnPersonAction = SKAction.customAction(withDuration: 0) {node, elapsedTime in
//      let person = self.createPerson(position: self.queue.position)
//      person.run(SKAction.move(to: self.doors[0].emptyPosition,
//                               duration: 2))
//      self.addChild(person)
//      self.persons.append(person)
//    }
//    
//    run(
//      SKAction.repeatForever(
//        SKAction.sequence([
//          spawnPersonAction,
//          SKAction.wait(forDuration: 1)
//        ])
//    ))
//  }
//}
//
//extension GameScene {
//  
//}
//
///// Create things helper
//extension GameScene {
//  private func createPerson(position: CGPoint) -> PersonNode {
//    let nodeSize = GameSettings.shared.nodeSize
//    let node = PersonNode(ellipseIn: CGRect(x: -nodeSize/2, y: -nodeSize/2, width: nodeSize, height: nodeSize))
//    node.position = position
//    node.fillColor = UIColor.blue
//    return node
//  }
//  
//  private func createDoor(position: CGPoint) -> DoorNode {
//    let nodeSize = CGSize(width: GameSettings.shared.nodeSize + 20,
//                          height: GameSettings.shared.nodeSize + 20)
//    let node = DoorNode(ellipseOf: nodeSize)
//    node.position = position
//    node.strokeColor = UIColor.green
//    return node
//  }
//  
//  private func createQueue(position: CGPoint) -> QueueNode {
//    let nodeSize = CGSize(width: GameSettings.shared.nodeSize + 10,
//                          height: GameSettings.shared.nodeSize + 10)
//    let node = QueueNode(ellipseOf: nodeSize)
//    node.position = position
//    return node
//  }
//}
//
//
//extension GameScene: SKSceneDelegate {
//  
//  override func update(_ currentTime: TimeInterval) {
//    
//  }
//  
//}
//
//
///// GameSettings
//class GameSettings {
//  public var nodeSize: CGFloat = 20
//  public var nodeSpeed: CGFloat = 1
//  static let shared = {
//    return GameSettings()
//  }()
//}
