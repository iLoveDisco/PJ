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
    
    override func didMove(to view: SKView) {
        view.showsPhysics = false
        self.physicsWorld.gravity = CGVector(dx:0,dy:-8)
        self.motion = CMMotionManager()
        self.motion.startDeviceMotionUpdates()
        physicsWorld.contactDelegate = self
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.player = self.lg.addPlayerToScene(self)
        }
        
        lg.addGroundToScene(self)
        lg.addImageToScene(self, levelImageName: "level_plainSelfie")
        lg.addEdgePlatformsToScene(self)
        lg.addExtraPlatformsToScene(self)
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if let player = self.player {
            player.jump()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let player = self.player {
            
            if player.isFalling(){
                player.enableJumping()
            } else { // player is rising
                player.disableJumping()
            }
            
            
            if let data = motion.deviceMotion {
                let y = data.attitude.roll
                player.node.physicsBody?.applyForce(CGVector(dx: y * Player.DRIFT, dy:0))
            }
            
            if player.node.position.x <= 0 {
                player.node.position.x = UIScreen.main.bounds.width
            }
            
            else if player.node.position.x >= UIScreen.main.bounds.width {
                player.node.position.x = 0
            }
            
            for node in self.children {
                if node.name == "PLATFORM" {
                    if player.node.intersects(node) {
                        player.jump()
                    }
                }
            }
            
            if player.node.position.y >= UIScreen.main.bounds.height {
                lg.resetScene(self)
                
                lg.addGroundToScene(self)
                lg.addImageToScene(self, levelImageName: "nah")
                self.player = lg.addPlayerToScene(self)
                lg.addEdgePlatformsToScene(self)
                lg.addExtraPlatformsToScene(self)
            }
           
            //print("Hero is currently at x:\(player.node.position.x) y:\(player.node.position.y)")
        }
    }
}
