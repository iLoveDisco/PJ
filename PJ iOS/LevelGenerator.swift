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
    static let Y_ZONE = 42.0
    let imageExtractor = ImageExtractor()
    var currentLevel = 1
    func loadRandomImageToScene(_ scene: GameScene, levelChangeHandler : (Int, Int) -> Void) {
        self.levelImage = imageExtractor.getRandomPhoto()
        levelChangeHandler(self.currentLevel, self.imageExtractor.photoCount!)
        self.currentLevel = self.currentLevel + 1
    }
    
    func loadImageToScene(image : UIImage) {
        self.levelImage = imageExtractor.processPhoto(image)
    }
    
    let NUM_PIXELS_TO_SKIP = 4
    let NUM_EDGE_POINT_TARGET_FACTOR = 0.011
    func addEdgePlatformsToScene(_ scene : GameScene) {
        var thresh1 = 100.0
        var thresh2 = 250.0
        
        var edgePoints = renderEdgePlatforms(thresh1,thresh2)
        
        let totalNumPixels = scene.size.width * scene.size.height
        
        // reduce number of edges
        let edgePointTarget = Int(NUM_EDGE_POINT_TARGET_FACTOR * totalNumPixels)
        var numReductions = 0
        repeat {
            numReductions = numReductions + 1
            thresh1 = thresh1 * 1.25
            thresh2 = thresh2 * 1.25
            edgePoints = renderEdgePlatforms(thresh1, thresh2)
        } while(edgePoints.count > edgePointTarget)
        
        print("addEdgePlatforms: number of reductions \(numReductions)")
        for point in edgePoints {
            scene.drawEdgePlatform(point)
        }
    }
    
    private func areEdgesCoveringWholeScreen(_ scene : GameScene, _ edgePoints : [CGPoint]) -> Bool {
        var numZones : Double = 0
        var numZonesWithPlatforms : Double = 0
        
        for xStart in stride(from: 0, through: scene.size.width, by: LevelGenerator.X_ZONE) {
            for yStart in stride(from: 0, through: scene.size.height, by: LevelGenerator.Y_ZONE) {
                if zoneContainsPoints(points: edgePoints, zoneLocation: CGPoint(x: xStart, y: yStart)) {
                    numZonesWithPlatforms = numZonesWithPlatforms + 1
                }
                numZones = numZones + 1
            }
        }
        
        return numZonesWithPlatforms / numZones > 0.95
    }
    
    func zoneContainsPoints(points : [CGPoint], zoneLocation : CGPoint) -> Bool {
        let xStart = zoneLocation.x
        let yStart = zoneLocation.y
        
        let xEnd = xStart + LevelGenerator.X_ZONE
        let yEnd = yStart + LevelGenerator.Y_ZONE
        
        let platforms : [CGPoint] = points
        for pos in platforms {
            if xStart < pos.x && pos.x < xEnd {
                if yStart < pos.y && pos.y < yEnd {
                    return true
                }
            }
        }
        
        return false
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
 
                nextZone = minimumPathZone - CGFloat(Int.random(in: -2...2)) * X_ZONE
                
                scene.drawExtraPlatform(CGPoint(x: nextZone + 20.0, y: yStart + Y_ZONE / 2))
            } else {
                nextZone = zonesWithPlatforms[Int.random(in: 0..<zonesWithPlatforms.count)]
            }
            
            minimumPathZone = nextZone
            
            
            for xStart in stride(from: 0, to: scene.size.width, by: LevelGenerator.X_ZONE) {
                let randomNumber = Int.random(in: 1...Int(scene.size.width * 2 / LevelGenerator.X_ZONE * 2))
                if randomNumber == 1 {
                    if !scene.zoneHasPlatforms(xStart: xStart, yStart: yStart) {
                        scene.drawExtraPlatform(CGPoint(x: xStart + LevelGenerator.X_ZONE / 2, y: yStart ))
                    }
                }
            }
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
        
        var numMonstersToAdd = Int.random(in:1...3)
        
        var possibleSpotsToAddMonsters : [CGPoint] = []
        
        for y in stride(from: scene.size.height / 3, through: scene.size.height - 60, by: LevelGenerator.Y_ZONE * 2) {
            let x = CGFloat.random(in: 50...scene.size.width - 50)
            possibleSpotsToAddMonsters.append(CGPoint(x: x, y: y))
        }
        
        for _ in 1...numMonstersToAdd {
            let randomSpotInArray = Int.random(in: 0..<possibleSpotsToAddMonsters.count)
            let posToAddMonster = possibleSpotsToAddMonsters.remove(at: randomSpotInArray)
            scene.drawMonster(posToAddMonster)
        }
    }

    func addPlayerToScene(_ scene : GameScene) {
        let player = Player(Player.DEFAULT_POSITION, Player.SPRITE_SIZE)
        player.draw(scene)
        scene.player = player
    }
}
