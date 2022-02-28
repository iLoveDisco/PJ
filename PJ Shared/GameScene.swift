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
    var monsters : [Monster] = []
    
    var sceneLoadStrategy : SceneLoadingStrategy = NormalSceneLoading()

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
        platform.doLoadingAnimation(scene: self)
        self.extraPlatforms.append(platform)
    }
    
    let PLATFORM_PIXEL_SIZE = 2
    func drawEdgePlatform(_ pos : CGPoint) {
        let size = CGSize(width: PLATFORM_PIXEL_SIZE, height: Int.random(in: 1...PLATFORM_PIXEL_SIZE))
        
        let platform = Platform(pos, size, animation: EdgePlatformAnimation(self))
        
        platform.doLoadingAnimation(scene: self)
        self.edgePlatforms.append(platform)
    }
    
    func drawMonster(_ pos : CGPoint) {
        let monster = Monster(pos, CGSize(width: LevelGenerator.X_ZONE * 1.2, height: LevelGenerator.Y_ZONE * 0.75))
        
        self.monsters.append(monster)
        monster.draw(self)
    }
    
    func zoneHasPlatforms(xStart : CGFloat, yStart : CGFloat) -> Bool{
        var xStart = xStart
        if xStart < 0 {
            xStart = self.size.width + xStart
        }
        
        let xEnd = xStart + LevelGenerator.X_ZONE
        let yEnd = yStart + LevelGenerator.Y_ZONE
        
        var platforms : [Platform] = []
        platforms.append(contentsOf: self.edgePlatforms)
        platforms.append(contentsOf: self.extraPlatforms)
        
        for platform in platforms {
            let node = platform.node
            let pos = node.position
            if xStart < pos.x && pos.x < xEnd {
                if yStart < pos.y && pos.y < yEnd {
                    return true
                }
            }
        }
        
        return false
    }
    
    func loadImage(image : UIImage) {
        lg.loadImageToScene(image: image)
    }
    
    func loadImage() {
        lg.loadImageToScene(self)
    }
    
    func loadGameObjects() {
        self.loadEdgePlatforms()
        self.loadExtraPlatforms()
        self.loadMonsters()
        
        // spawn player
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadPlayer()
        }
        
        // spawn background
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let background = Background(image: self.lg.levelImage!, pos: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2), size: self.size)
            
            background.draw(self)
            background.fadeOut(time: 0.01) {
                background.show()
                background.fadeIn(time: 0.2)
            }
            
        }
    }
    
    func loadEdgePlatforms() {
        lg.addEdgePlatformsToScene(self)
    }
    
    func loadExtraPlatforms() {
        lg.addExtraPlatformsToScene(self)
    }
    
    func loadMonsters() {
        lg.addMonstersToScene(self)
    }
    
    func loadPlayer() {
        lg.addPlayerToScene(self)
    }
    
    func resetScene() {
        self.removeAllChildren()
        self.edgePlatforms = []
        self.extraPlatforms = []
        self.monsters = []
        
        self.sceneLoadStrategy.setScene(scene: self)
    }
}
