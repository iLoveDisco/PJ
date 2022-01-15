//
//  Player.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit
class Player : GameObject {
    let node = SKSpriteNode(imageNamed: "player")
    var jumpCount : Int = 0
    var canJump : Bool = true
    var timeSinceLastJump : Double = 0
    
    static let SPRITE_SIZE = CGSize(width: 20, height: 20)
    static let BODY_SIZE = SPRITE_SIZE
    static let DRIFT : Double = 20
    static let JUMP_POWER = 15
    
    override init(_ pos: CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = super.size;
        node.zPosition = 10
        node.name = "PLAYER"
        
        node.physicsBody = SKPhysicsBody(rectangleOf: Player.BODY_SIZE)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 3
        
        node.physicsBody?.contactTestBitMask = 0b0000
        node.physicsBody?.categoryBitMask = 0b0100
        node.physicsBody?.collisionBitMask = 0b1000
        
        self.canJump = true
    }
    
    override func getNode() -> SKSpriteNode {
        return self.node
    }
    
    func jump() {
        if self.canJump{
            let direction = CGVector(dx: 0, dy: Player.JUMP_POWER)
            self.node.physicsBody?.applyImpulse(direction)
            
            self.jumpCount = jumpCount + 1
            print("Jumping \(jumpCount) \(CACurrentMediaTime())")
            
            timeSinceLastJump = CACurrentMediaTime()
            self.disableJumping()
        }
        
    }
    
    func enableJumping() {
        self.canJump = true
    }
    
    func disableJumping() {
        self.canJump = false
    }
    
    func isFalling() -> Bool {
        return (self.getNode().physicsBody?.velocity.dy)! < 0
    }
}
