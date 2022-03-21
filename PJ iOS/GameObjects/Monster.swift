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
    var timer2 : Timer?
    
    let laserNode = SKSpriteNode(imageNamed: "ship_shock\(1)")
    
    let speed = 150.0
    let duration = 5.0
    
    override init(_ pos : CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = size;
        node.zPosition = 6.0
        node.name = "MONSTER\(Int.random(in: 1...100))"
        self.isDead = false
        self.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(startMoving), userInfo: nil, repeats: true)
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(runAnimation), userInfo: nil, repeats: true)
        self.startMoving()
        laserNode.position = CGPoint(x: 0,y: -1 * node.size.height / 3)
        laserNode.size = CGSize(width: node.size.width * 1.1, height: node.size.height / 2)
        self.node.addChild(laserNode)
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
        
        for monster in scene.monsters {
            if self.isDead && self.isTouching(monster.getNode()) && self.node.name != monster.getNode().name {
                monster.die()
            }
        }
    }
    
    @objc func runAnimation() {
        let laserAnimation = SKAction.animate(with: [SKTexture(imageNamed: "ship_shock1"),SKTexture(imageNamed: "ship_shock2"),SKTexture(imageNamed: "ship_shock3")], timePerFrame: 0.1)
        laserNode.run(laserAnimation)
    }
    
    @objc func startMoving() {
        
        
        if !self.isDead && self.node.physicsBody?.velocity.dx == 0{
            
            let velocity = speed * -1 + CGFloat(Int.random(in: 0...1)) * speed * 2

            self.node.run(SKAction.move(by: CGVector(dx: velocity, dy: 0), duration: duration))
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
        self.node.removeAllChildren()
        
        let direction = CGVector(dx: 0, dy: -50)
        self.node.physicsBody?.applyImpulse(direction)
        self.node.physicsBody?.affectedByGravity = true
        self.node.texture = SKTexture(imageNamed: "dead_space_ship\(Int.random(in: 1...2))")
        self.isDead = true
    }
}
