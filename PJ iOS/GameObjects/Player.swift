//
//  Player.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit
import CoreMotion

class Player : GameObject {
    let node = SKSpriteNode(imageNamed: "player")
    var motion : CMMotionManager!
    var isDead : Bool = false
    
    var canJump : Bool = true
    var timeSinceLastJump : Double = 0
    var isRespawning = false
    
    static let SPRITE_SIZE = CGSize(width: 20, height: 30)
    static let BODY_SIZE = SPRITE_SIZE
    static let DRIFT : Double = 25
    static let JUMP_POWER = 20
    static let DEFAULT_POSITION = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.05)
    
    override init(_ pos: CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = super.size;
        node.name = "PLAYER"
        node.zPosition = 10
        self.canJump = true
        self.isDead = false
        
        self.motion = CMMotionManager()
        self.motion.startDeviceMotionUpdates()
    }
    
    deinit {
        self.motion.stopDeviceMotionUpdates()
    }
    
    override func resetPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: Player.BODY_SIZE)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 3.0
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
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
    
    func die() {
        isDead = true
        let direction = CGVector(dx: 0, dy: -1 * Player.JUMP_POWER)
        self.node.physicsBody?.applyImpulse(direction)
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
    
    func isBelowScreen() -> Bool {
        return self.node.position.y <= -20
    }
 
    func resetPosition() {
        self.node.position = Player.DEFAULT_POSITION
    }
    
    private func handleJumps(scene : GameScene) {
        
        if self.isFalling(){
            self.enableJumping()
        } else { // player is rising
            self.disableJumping()
        }
        
        var platforms : [Platform] = []
        platforms.append(contentsOf: scene.edgePlatforms)
        platforms.append(contentsOf: scene.extraPlatforms)
        
        for platform in platforms {
            if platform.isTouching(self.node) {
                if self.canJump && !self.isDead{
                    platform.flash()
                }
                
                self.jump()
            }
        }
    }
    
    private func handleControls() {
        if let data = motion.deviceMotion {
            let y = data.attitude.roll
            self.node.physicsBody?.applyForce(CGVector(dx: y * Player.DRIFT, dy:0))
        }
    }
    
    private func handleWins(scene : GameScene) {
        if self.isAboveScreen() {
            self.resetPosition()
            scene.resetScene()
        }
    }
    
    private func handleTeleports(scene : GameScene) {
        if self.node.position.x <= 0 {
            self.node.position.x = scene.size.width
        }
        
        else if self.node.position.x >= scene.size.width {
            self.node.position.x = 0
        }
    }
    
    private func handleDeath(scene : GameScene) {
        if self.node.position.y <= -20 && !isRespawning {
            isRespawning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                self.resetPosition()
                self.isRespawning = false
            }
        }
    }
    
    func update(scene : GameScene) {
        self.handleDeath(scene : scene)
        self.handleJumps(scene: scene)
        self.handleControls()
        self.handleWins(scene: scene)
        self.handleTeleports(scene: scene)
    }
}
