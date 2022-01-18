//
//  LevelGenerator.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit

class LevelGenerator {
    var levelImage : UIImage?
    
    func addImageToScene(_ scene: GameScene, levelImageName : String) {
        print("addImageToScene: Loading level image")
        let imageExtractor = ImageExtractor()
        self.levelImage = imageExtractor.getRandomPhoto()
        self.resizeImageToScreenHeight(self.levelImage!)
        self.randomImageCrop()
        
        let levelTexture = SKTexture(image: levelImage!)
        let background = SKSpriteNode(texture: levelTexture)
        
        background.zPosition = 1
        background.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background.size = scene.size
        
        background.physicsBody?.collisionBitMask = 0b0010
        background.physicsBody?.isDynamic = false
        background.physicsBody?.affectedByGravity = false
        scene.addChild(background);
    }
    
    let PLATFORM_PIXEL_SIZE = 1
    let NUM_PIXELS_TO_SKIP = 2
    func addEdgePlatformsToScene(_ scene : GameScene) {
        if levelImage != nil{
            print("addEdgePlatformsToScene: Loading platforms")
        } else {
            fatalError("addEdgePlatformsToScene: levelImage is not defined")
        }
        
        let cannyLevelImage = OpenCVWrapper.toCanny(levelImage!)
        let proc = ImageProcessor(img: cannyLevelImage.cgImage!)
        
        for x in stride(from: 0, to: proc.width - 1, by: NUM_PIXELS_TO_SKIP) {
            for y in stride(from: 0, to: proc.height - 1, by: NUM_PIXELS_TO_SKIP) {
                
                let color = proc.color_at(x: x, y: y)
                
                let colorVal = color.cgColor.components![0]
                if (colorVal > 0.0) {
                    self.drawEdgePlatform(scene, x, y)
                }
            }
        }
        
        proc.freeImageMemory()
    }
    
    private func drawEdgePlatform(_ scene : GameScene, _ x : Int, _ y : Int) {
        let size = CGSize(width: PLATFORM_PIXEL_SIZE, height: PLATFORM_PIXEL_SIZE)
        let pos = CGPoint(x: x, y: Int(UIScreen.main.bounds.height) - y)
        let platform = Platform(pos, size)
        platform.draw(scene)
        platform.fadeOut(time: 3)
        
    }
    
    func addExtraPlatformsToScene(_ scene : GameScene) {
        print("addExtraPlatformsToScene: Adding extra platforms")
        
        for y in 0...Int(UIScreen.main.bounds.height) {
            if y % scene.JUMP_HEIGHT - scene.JUMP_HEIGHT_LEEWAY == 0 {
                for _ in 1...Int.random(in: 1...3) {
                    let pos = CGPoint(x: Int.random(in: 0...Int(UIScreen.main.bounds.width)), y: y + Int.random(in: -20...0) + -20)
                    let platform = Platform(pos, CGSize(width: 40, height: 4))
                    platform.draw(scene)
                }
            }
        }
    }
    
    func addGroundToScene(_ scene : GameScene) {
        print("addGroundToScene: Adding the ground to the scene")
        let pos = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        let ground = Platform(pos, CGSize(width: UIScreen.main.bounds.width, height: 40))
        
        ground.draw(scene)
    }
    
    func addPlayerToScene(_ scene : GameScene) -> Player {
        print("addPlayerToScene: Rendering player...")
        let player = Player(Player.DEFAULT_POSITION, Player.SPRITE_SIZE)
        player.draw(scene)
        return player
    }
    
    func resetScene(_ scene : GameScene) {
        scene.removeAllChildren()
    }
    
    func resizeImageToScreenHeight(_ image : UIImage)  {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let ratio = screenSize.height / image.size.height
        
        let newWidth = ratio * image.size.width
        let newHeight = screenSize.height
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.levelImage = newImage
    }
    
    func randomImageCrop() {
        let image = levelImage!
        
        print("randomImageCrop: Cropping image with width \(image.size.width). UIScreen width is \(UIScreen.main.bounds.width)")
        
        let xOffset = Int.random(in: 0 ... Int(image.size.width - UIScreen.main.bounds.width))
        let cropRect = CGRect(x: CGFloat(xOffset), y: 0, width: UIScreen.main.bounds.width, height: image.size.height).integral
        
        let croppedCG = image.cgImage?.cropping(to: cropRect)
        
        self.levelImage = UIImage(cgImage: croppedCG!)
    }
    
    
}
