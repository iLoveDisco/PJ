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
    let node = SKSpriteNode(imageNamed: "astro_falling_left")
    var motion : CMMotionManager!
    var isDead : Bool = false
    
    var canJump : Bool = true
    var timeSinceLastJump : Double = 0
    var isRespawning = false
    
    static let SPRITE_SIZE = CGSize(width: 25, height: 25 * 1.2)
    static let BODY_SIZE = SPRITE_SIZE
    static let DRIFT : Double = 35
    static let JUMP_POWER = 16.6
    static let DEFAULT_POSITION = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.02)
    let shockNode = SKSpriteNode(imageNamed: "shock1")
    
    var timer : Timer?
    
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
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(runDeathAnimation), userInfo: nil, repeats: true)
        
        shockNode.size = CGSize(width: self.node.size.width * 2, height: self.node.size.height * 2)
        shockNode.isHidden = true
        self.node.addChild(shockNode)
        
    }
    
    deinit {
        self.motion.stopDeviceMotionUpdates()
        self.timer?.invalidate()
    }
    
    override func resetPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: Player.BODY_SIZE)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 3.5
        
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
    
    func shortJump() {
        if self.canJump{
            let direction = CGVector(dx: 0, dy: Player.JUMP_POWER * 0.85)
            self.node.physicsBody?.applyImpulse(direction)
            timeSinceLastJump = CACurrentMediaTime()
            self.disableJumping()
        }
    }
    
    func die() {
        self.isDead = true
        self.node.physicsBody?.isDynamic = false
        self.shockNode.isHidden = false
        self.node.texture = SKTexture(imageNamed: "astro_falling_left")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.node.position.y = -50
            self.shockNode.isHidden = true
            self.node.physicsBody?.isDynamic = true
        }
    }
    
    @objc func runDeathAnimation() {
        let laserAnimation = SKAction.animate(with: [SKTexture(imageNamed: "shock1"),SKTexture(imageNamed: "shock2"),SKTexture(imageNamed: "shock3")], timePerFrame: 0.1)
        
        self.shockNode.run(laserAnimation)
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
        
        if self.isDead {
            return
        }
        
        if self.isFalling(){
            
            if (self.node.physicsBody?.velocity.dy)! < -50 {
                if (self.node.physicsBody?.velocity.dx)! < 0 {
                    self.node.texture = SKTexture(imageNamed: "astro_falling_left")
                } else {
                    self.node.texture = SKTexture(imageNamed: "astro_falling_right")
                }
            }
            
            self.enableJumping()
        } else { // player is rising
            
            if (self.node.physicsBody?.velocity.dx)! < 0 {
                self.node.texture = SKTexture(imageNamed: "astro_rising_left")
            } else {
                self.node.texture = SKTexture(imageNamed: "astro_rising_right")
            }
            
            self.disableJumping()
        }
        
        
        for edgePlatform in scene.edgePlatforms {
            if edgePlatform.isTouching(self.node) {
                if self.canJump && !self.isDead {
                    edgePlatform.doPlayerJumpAnimation()
                    self.shortJump()
                }
            }
        }
        
        for extraPlatform in scene.extraPlatforms {
            if extraPlatform.isTouching(self.node) {
                if self.canJump && !self.isDead {
                    extraPlatform.doPlayerJumpAnimation()
                    self.jump()
                }
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
        if !self.isDead {
            if self.node.position.x <= 0 {
                self.node.position.x = scene.size.width
            }
            
            else if self.node.position.x >= scene.size.width {
                self.node.position.x = 0
            }
        }
    }
    
    private func handleDeath(scene : GameScene) {
        if self.node.position.y <= -20 && !isRespawning {
            isRespawning = true
            
            for platform in scene.edgePlatforms {
                platform.doLoadingAnimation(scene: scene)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                self.resetPosition()
                self.isDead = false
                self.isRespawning = false
            }
        }
    }
    
    private func handleMonsters(scene : GameScene) {
        for monster in scene.monsters {
            if self.isTouching(monster.laserNode) {
                if !monster.isDead{
                    self.die()
                    monster.getNode().removeAllActions()
                    monster.getNode().physicsBody?.isDynamic = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                        monster.getNode().physicsBody?.isDynamic = true
                    }
                }
            }
            
            else if self.isTouching(monster.getNode()) {
                if !self.isDead {
                    monster.die()
                    self.jump()
                }
            }
        }
    }
    
    func update(scene : GameScene) {
        self.handleDeath(scene : scene)
        self.handleJumps(scene: scene)
        self.handleControls()
        self.handleWins(scene: scene)
        self.handleTeleports(scene: scene)
        self.handleMonsters(scene: scene)
    }
}
