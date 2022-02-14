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
    
    let NUM_PIXELS_TO_SKIP = 5
    func addEdgePlatformsToScene(_ scene : GameScene) {
        var thresh1 = 100.0
        var thresh2 = 200.0
        
        var edgePoints = renderEdgePlatforms(thresh1,thresh2)
        
        while edgePoints.count > 10000 {
            thresh2 = thresh2 * 2
            edgePoints = renderEdgePlatforms(thresh1, thresh2)
        }
        for point in edgePoints {
            scene.drawEdgePlatform(point)
        }
    }
    
    func addExtraPlatformsToScene(_ scene : GameScene) {
        let edgePlatforms = scene.children.filter { platform in
            platform.name == "PLATFORM"
        }

        var zonesWithPlatforms : [CGFloat] = []
        var minimumPathZone = scene.size.width / 2
        
        scene.drawExtraPlatform(CGPoint(x: minimumPathZone, y: 2.0))
        
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
        var possibleSpotsToAddMonsters : [CGPoint] = []
        for x_start in stride(from: 0, to: scene.size.width, by: LevelGenerator.X_ZONE) {
            for y_start in stride(from: scene.size.height / 2, to: scene.size.height * 0.8, by: LevelGenerator.Y_ZONE) {
                if !scene.zoneHasPlatforms(xStart: x_start, yStart: y_start) {
                    possibleSpotsToAddMonsters.append(CGPoint(x: x_start + LevelGenerator.X_ZONE / 2, y: y_start + LevelGenerator.Y_ZONE / 2))
                }
            }
        }
        
        if possibleSpotsToAddMonsters.count == 0 {
            return
        } else {
            let numMonstersToAdd = Int.random(in: 1...3)
            
            for _ in 1...numMonstersToAdd {
                let spotToAddMonster : CGPoint = possibleSpotsToAddMonsters[Int.random(in: 0...possibleSpotsToAddMonsters.count)]
                scene.drawMonster(spotToAddMonster)
            }
        }
    }

    func addPlayerToScene(_ scene : GameScene) -> Player {
        let player = Player(Player.DEFAULT_POSITION, Player.SPRITE_SIZE)
        player.draw(scene)
        return player
    }
}
