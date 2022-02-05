//
//  GameScene.swift
//  PictoJump Shared
//
//  Created by Eric Tu on 11/18/21.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    let JUMP_HEIGHT = Int(UIScreen.main.bounds.height * 0.08)
    let JUMP_HEIGHT_LEEWAY = 2
    var player : Player?
    var motion : CMMotionManager!
    let lg = LevelGenerator()
    
    let ADD_PLAYER_AFTER_DELAY = 2.0
    
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        self.speed = 2.0
        
        self.physicsWorld.gravity = CGVector(dx:0,dy:-8)
        self.motion = CMMotionManager()
        self.motion.startDeviceMotionUpdates()
        physicsWorld.contactDelegate = self
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        self.resetScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let player = self.player {
            player.jump()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let player = self.player {
            self.handlePlayerJumps()
            self.handleDeviceControls()
            self.handleGameFinish()
            
            
            if player.node.position.x <= 0 {
                player.node.position.x = UIScreen.main.bounds.width
            }
            
            else if player.node.position.x >= UIScreen.main.bounds.width {
                player.node.position.x = 0
            }
            
        }
    }
    
    private func handlePlayerJumps() {
        if let player = self.player {
            if player.isFalling(){
                player.enableJumping()
            } else { // player is rising
                player.disableJumping()
            }
            
            for node in self.children {
                if node.name == "PLATFORM" {
                    if player.isTouching(node) {
                        player.jump()
                    }
                }
            }
        }
    }
    
    private func handleDeviceControls() {
        if let player = self.player {
            if let data = motion.deviceMotion {
                let y = data.attitude.roll
                player.node.physicsBody?.applyForce(CGVector(dx: y * Player.DRIFT, dy:0))
            }
        }
    }
    
    private func handleGameFinish() {
        if let player = self.player {
            if player.isAboveScreen() {
                player.resetPosition()
                self.resetScene()
            }
        }
    }
    
    private func resetScene() {
        lg.resetScene(self)
        lg.addImageToScene(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.player = self.lg.addPlayerToScene(self)
        }
        lg.addEdgePlatformsToScene(self)
        lg.addExtraPlatformsToScene(self)
    }
}
