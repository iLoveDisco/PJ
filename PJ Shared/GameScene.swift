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
    
    
    var count = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
        
            if touchedNode.name == "PAUSE_BUTTON" {
                self.isPaused = true
                self.loadPauseMenu()
            }
        }
    }
    
    private func loadPauseMenu() {
        
        
        
    }
    
    func loadPauseButton() {
        let node = SKSpriteNode(imageNamed: "pause")
        node.zPosition = 10
        node.position = CGPoint(x: self.size.width - 50.0, y: self.size.height - 100)
        node.name="PAUSE_BUTTON"
        node.size = CGSize(width: 75 * 1.25, height: 100 * 1.25)
        node.alpha = 0.7
        self.addChild(node)
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx:0,dy:-3)
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
        
        platform.node
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
        self.loadPauseButton()
        self.loadWallPaper()
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
                background.fadeIn(time: 0.5)
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
    
    func loadWallPaper() {
        let node = SKSpriteNode(imageNamed: "background")
        node.zPosition = 0
        node.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        node.name="WALLPAPER"
        node.size = self.size
        node.alpha = 0.3
        self.addChild(node)
    }
    
    func resetScene() {
        for monster in self.monsters {
            monster.timer?.invalidate()
        }
        self.sceneLoadStrategy.setScene(scene: self)
    }
}
