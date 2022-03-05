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
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startMoving), userInfo: nil, repeats: true)
        self.startMoving()
        
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
        node.physicsBody?.linearDamping = 2
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
    }
    
    func handleTeleports(scene : GameScene) {
        if !self.isDead {
            if self.node.position.x <= 0 {
                self.node.position.x = scene.size.width
            }
            
            else if self.node.position.x >= scene.size.width {
                self.node.position.x = 0
            }
        }
    }
    
    func update(scene : GameScene) {
        self.handleTeleports(scene: scene)
        
        
    }
    
    @objc func startMoving() {
        if !self.isDead && self.node.physicsBody?.velocity.dx == 0{
            var destination = CGPoint(x: self.node.position.x - 100 + CGFloat(Int.random(in: 0...1)) * 200.0, y : self.node.position.y)
            
            if destination.x <= 0  {
                destination.x = destination.x + 200
            }
            
            else if destination.x >= UIScreen.main.bounds.width {
                destination.x = destination.x - 200
            }
            
            self.node.run(SKAction.move(to: destination, duration: Double.random(in: 3...4)))
        }
        
    }
    
    override func getNode() -> SKSpriteNode {
        return node
    }
    
    func fadeOut(time : Int) {
        self.node.run(SKAction.fadeOut(withDuration: 2.0))
    }
    
    func die() {
        
        self.node.removeAllActions()
        self.node.physicsBody?.velocity.dx = 0
        
        
        let direction = CGVector(dx: 0, dy: -50)
        self.node.physicsBody?.applyImpulse(direction)
        self.node.physicsBody?.affectedByGravity = true
        self.node.texture = SKTexture(imageNamed: "dead_space_ship\(Int.random(in: 1...2))")
        self.isDead = true
    }
}
