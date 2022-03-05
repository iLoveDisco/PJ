//
//  Monster.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit

class Monster: GameObject {
    let node = SKSpriteNode(imageNamed: "space_ship\(Int.random(in: 1...3))")
    var isDead = false
    let id = Int.random(in: 1...1000)
    
    var timer : Timer?
    
    override init(_ pos : CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = size;
        node.zPosition = 6.0
        node.name = "MONSTER"
        self.isDead = false
        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(startMoving), userInfo: nil, repeats: true)
        
        
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    override func resetPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 3
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
    }
    
    @objc func startMoving() {
        if !self.isDead {
            print("monster \(self.id) is moving")
        }
        
    }
    
    override func getNode() -> SKSpriteNode {
        return node
    }
    
    func fadeOut(time : Int) {
        self.node.run(SKAction.fadeOut(withDuration: 2.0))
    }
    
    func die() {
        let direction = CGVector(dx: 0, dy: -80)
        self.node.physicsBody?.applyImpulse(direction)
        self.node.physicsBody?.affectedByGravity = true
        self.isDead = true
    }
}
