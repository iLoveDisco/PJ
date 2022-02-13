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
    var edgePlatforms : [Platform] = []
    var extraPlatforms : [Platform] = []
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx:0,dy:-4)
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
        self.extraPlatforms.append(platform)
    }
    
    let PLATFORM_PIXEL_SIZE = 2
    func drawEdgePlatform(_ pos : CGPoint) {
        let size = CGSize(width: PLATFORM_PIXEL_SIZE, height: PLATFORM_PIXEL_SIZE)
        
        let platform = Platform(pos, size, animation: EdgePlatformAnimation(self))
        platform.hide()
        platform.draw(self)
        self.edgePlatforms.append(platform)
        platform.fadeOut(time: 0.01) {
            platform.show()
            platform.doLoadingAnimation()
        }
    }
    
    func resetScene() {
        self.removeAllChildren()
        
        self.edgePlatforms = []
        self.extraPlatforms = []
        
        lg.loadImageToScene(self)
        lg.addEdgePlatformsToScene(self)
        lg.addExtraPlatformsToScene(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            self.player = self.lg.addPlayerToScene(self)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Change `2.0` to the desired number of seconds.
            
            let background = Background(image: self.lg.levelImage!, pos: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2), size: self.size)
            
            background.draw(self)
            background.fadeOut(time: 0.01) {
                background.show()
                background.fadeIn(time: 0.2)
            }
            
        }
    }
}
