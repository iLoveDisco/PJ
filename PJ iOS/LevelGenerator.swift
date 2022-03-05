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
    static let X_ZONE = 40.0
    static let Y_ZONE = 55.0
    
    func loadImageToScene(_ scene: GameScene) {
        let imageExtractor = ImageExtractor()
        self.levelImage = imageExtractor.getRandomPhoto()
    }
    
    func loadImageToScene(image : UIImage) {
        
        let imageExtractor = ImageExtractor()
        self.levelImage = imageExtractor.processPhoto(image)
    }
    
    let NUM_PIXELS_TO_SKIP = 5
    func addEdgePlatformsToScene(_ scene : GameScene) {
        let thresh1 = 100.0
        var thresh2 = 200.0
        
        var edgePoints = renderEdgePlatforms(thresh1,thresh2)
        
        let totalNumPixels = scene.size.width * scene.size.height
        
        // reduce number of edges
        let edgePointTarget = Int(0.01 * totalNumPixels)
        
        repeat {
            thresh2 = thresh2 + 100
            edgePoints = renderEdgePlatforms(thresh1, thresh2)
        } while(edgePoints.count > edgePointTarget)
        
        for point in edgePoints {
            scene.drawEdgePlatform(point)
        }
    }
    
    func addExtraPlatformsToScene(_ scene : GameScene) {
        var zonesWithPlatforms : [CGFloat] = []
        var minimumPathZone = scene.size.width / 2
        
        scene.drawExtraPlatform(CGPoint(x: minimumPathZone, y: LevelGenerator.Y_ZONE * 0.25))
        
        for yStart in stride(from: LevelGenerator.Y_ZONE, to: scene.size.height - 1, by: LevelGenerator.Y_ZONE) {
            
            zonesWithPlatforms = []
            
            if scene.zoneHasPlatforms(xStart: minimumPathZone, yStart: yStart) {
                zonesWithPlatforms.append(minimumPathZone)
            }
            
            let X_ZONE = LevelGenerator.X_ZONE
            let Y_ZONE = LevelGenerator.Y_ZONE
            
            if scene.zoneHasPlatforms(xStart: minimumPathZone - X_ZONE, yStart: yStart) {
                zonesWithPlatforms.append(minimumPathZone - X_ZONE);
            }
            
            if scene.zoneHasPlatforms(xStart: minimumPathZone + X_ZONE, yStart: yStart) {
                zonesWithPlatforms.append(minimumPathZone + X_ZONE)
            }
            
            var nextZone = 0.0
            if zonesWithPlatforms.count == 0 {
                nextZone = minimumPathZone - X_ZONE + CGFloat(Int.random(in: 0...2)) * X_ZONE
                
                scene.drawExtraPlatform(CGPoint(x: nextZone + 20.0, y: yStart + Y_ZONE / 2))
            } else {
                nextZone = zonesWithPlatforms[Int.random(in: 0..<zonesWithPlatforms.count)]
            }
            
            minimumPathZone = nextZone
            
        }
    }
    
    private func renderEdgePlatforms(_ thresh1 : Double, _ thresh2: Double) -> [CGPoint]{
        let cannyLevelImage = OpenCVWrapper.toCanny(levelImage!,thresh1,thresh2)
        let proc = ImageProcessor(img: cannyLevelImage.cgImage!)
        var edgeLocations : [CGPoint] = []
        
        var x = 0
        while x < proc.width {
            
            var y = 0
            while y < proc.height {

                let color = proc.color_at(x: x, y: y)
                let colorVal = color.cgColor.components![0]
                if (colorVal > 0.0) {
                    edgeLocations.append(CGPoint(x: CGFloat(x), y: UIScreen.main.bounds.height - CGFloat(y)))
                }

                y = y + Int.random(in: 1...NUM_PIXELS_TO_SKIP)
            }
            x = x + Int.random(in: 1...NUM_PIXELS_TO_SKIP)
        }
        proc.freeImageMemory()
        return edgeLocations
    }
    
    func addMonstersToScene(_ scene : GameScene) {
        for yStart in stride(from: scene.size.height / 3, through: scene.size.height - 60, by: LevelGenerator.Y_ZONE) {
            
            let randomNumber = Int.random(in: 1 ... Int(scene.size.height / LevelGenerator.Y_ZONE / 2))
            
            let luckyNumbers : [Int] = [1,2]
            if luckyNumbers.contains(randomNumber) {
                let monster = Monster(CGPoint(x: CGFloat.random(in: 60...scene.size.width - 60), y: yStart), CGSize(width: 60, height: 40))
                monster.draw(scene)
                scene.monsters.append(monster)
            }
        }
        
    }

    func addPlayerToScene(_ scene : GameScene) {
        let player = Player(Player.DEFAULT_POSITION, Player.SPRITE_SIZE)
        player.draw(scene)
        scene.player = player
    }
}
