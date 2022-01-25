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

    var canJump : Bool = true
    var timeSinceLastJump : Double = 0
    
    static let SPRITE_SIZE = CGSize(width: 20, height: 20)
    static let BODY_SIZE = SPRITE_SIZE
    static let DRIFT : Double = 20
    static let JUMP_POWER = 15
    static let DEFAULT_POSITION = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.2)
    
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
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
        
        self.canJump = true
    }
    
    override func getNode() -> SKSpriteNode {
        return self.node
    }
    
    func jump() {
        if self.canJump{
            let direction = CGVector(dx: 0, dy: Player.JUMP_POWER)
            self.node.physicsBody?.applyImpulse(direction)
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
    
    func isAboveScreen() -> Bool {
        return self.node.position.y >= UIScreen.main.bounds.height
    }
    
    func isTouching(_ node : SKNode) -> Bool{
        return self.node.intersects(node)
    }
    
    func resetPosition() {
        self.node.position = Player.DEFAULT_POSITION
    }
}
