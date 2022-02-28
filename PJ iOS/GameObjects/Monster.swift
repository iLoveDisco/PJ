//
//  Monster.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit

class Monster: GameObject {
    let node = SKSpriteNode(color: UIColor.red, size: CGSize())
    var isDead = false
    
    override init(_ pos : CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = size;
        node.zPosition = 6.0
        node.name = "MONSTER"
        self.isDead = false
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
