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
    
    var motion : CMMotionManager!
    let lg = LevelGenerator()
    
    let ADD_PLAYER_AFTER_DELAY = 2.0
    
    var player : Player?
    var platforms : [Platform] = []
    
    override func didMove(to view: SKView) {
        view.showsPhysics = false
        self.speed = 2.0
        
        self.physicsWorld.gravity = CGVector(dx:0,dy:-8)
        self.motion = CMMotionManager()
        self.motion.startDeviceMotionUpdates()
        
        physicsWorld.contactDelegate = self
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        platforms = []
        self.resetScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let player = self.player {
            player.jump()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let player = self.player {
            player.update(scene: self)
        }
    }
    
    func drawExtraPlatform(_ pos : CGPoint) {
        var pos = pos
        var x = pos.x
        if x < 0 {
            x = UIScreen.main.bounds.width + x
        }
        
        x = CGFloat(Int(x) % Int(UIScreen.main.bounds.width))
        
        pos.x = x
        
        let size = CGSize(width: 40, height: 5)
        let platform = Platform(pos, size, animation: ExtraPlatformAnimation())
        platform.draw(self)
        self.platforms.append(platform)
    }
    
    let PLATFORM_PIXEL_SIZE = 1
    func drawEdgePlatform(_ pos : CGPoint) {
        let size = CGSize(width: PLATFORM_PIXEL_SIZE, height: PLATFORM_PIXEL_SIZE)
        
        let platform = Platform(pos, size, animation: EdgePlatformAnimation(self))
        
        platform.draw(self)
        self.platforms.append(platform)
        
        platform.fadeOut(time: 3)
    }
    
    func resetScene() {
        self.removeAllChildren()
        
        self.platforms = []
        
        lg.addImageToScene(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.player = self.lg.addPlayerToScene(self)
        }
        
        lg.addEdgePlatformsToScene(self)
        lg.addExtraPlatformsToScene(self)
    }
}
