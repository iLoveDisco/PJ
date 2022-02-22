//
//  JumpBehavior.swift
//  PJ iOS
//
//  Created by Eric Tu on 2/8/22.
//

import Foundation
import SpriteKit

protocol PlatformAnimation {
    func animateOnPlayerJump(_ platform : Platform)
    func animateOnLoad(_ platform : Platform)
}

class EdgePlatformAnimation : PlatformAnimation {
    var scene : GameScene
    
    init (_ scene : GameScene) {
        self.scene = scene
    }
    
    func animateOnPlayerJump(_ platform : Platform) {
        let platforms = self.scene.edgePlatforms
        let closestPlatforms = platforms.sorted { p1, p2 in
            return platform.distanceFrom(p1) < platform.distanceFrom(p2)
        }
        
        if platforms.count < 22 {
            return
        }
        
        for i in stride(from: 3, to: 20, by: 2) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.025 * Double(i)) {
                self.fadeInAndOut(closestPlatforms[i])
                self.fadeInAndOut(closestPlatforms[i + 1])
            }
        }
    }
    
    func animateOnLoad(_ platform: Platform) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int.random(in: 1...10)) * 0.1) {
            self.fadeInAndOut(platform)
        }
    }
    
    private func fadeInAndOut(_ platform : Platform) {
        platform.fadeIn(time: 0.05) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                platform.fadeOut(time: 0.1)
            }
        }
    }
    
}

class ExtraPlatformAnimation : PlatformAnimation {
    func animateOnPlayerJump(_ platform : Platform) {
        let originalPos = CGPoint(x: platform.pos.x, y: platform.pos.y)
        
        let direction = CGVector(dx: 0, dy: -0.5)
        platform.node.physicsBody?.applyImpulse(direction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {

            platform.getNode().run(SKAction.move(to: originalPos, duration: 0.1))
        }
    }
    
    func animateOnLoad(_ platform: Platform) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            platform.fadeIn(time: 0.2)
        }
    }
}
