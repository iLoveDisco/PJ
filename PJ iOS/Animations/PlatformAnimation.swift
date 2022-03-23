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
    
    let FLASH_LENGTH = 22
    
    func animateOnPlayerJump(_ platform : Platform) {
        if let image = self.scene.lg.levelImage?.cgImage {
            let processor = ImageProcessor(img: image)
            let pos = platform.getNode().position
            
            
            let numParticles = Int.random(in: 2...8)
            for id in 0...numParticles {
                let color = processor.color_at(x: Int(pos.x + CGFloat.random(in: -2...2)), y: Int(scene.size.height - pos.y + CGFloat.random(in: -2...2)))
                let node = SKSpriteNode(color: color, size: CGSize(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3)))
                node.name = "PARTICLE\(id)"
                node.zPosition = 100
                node.physicsBody?.isDynamic = true
                node.position = platform.pos
                self.scene.addChild(node)
                
                let direction = CGVector(dx: CGFloat.random(in: -20...20), dy: CGFloat.random(in: -50...0))
                node.run(SKAction.move(by: direction, duration: 1)) {
                    node.removeFromParent()
                }
            }
        }
    }
    
    func animateOnLoad(_ platform: Platform) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...1)) {
            self.fadeInAndOut(platform, withAlpha: 1.0, duration: 2.0)
        }
    }
    
    private func fadeInAndOut(_ platform : Platform, withAlpha : CGFloat, duration : CGFloat) {
        platform.node.isHidden = false
        platform.fadeIn(time: 0.05) {
            
            platform.node.alpha = withAlpha
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                platform.fadeOut(time: 0.1) {
                    platform.node.isHidden = true
                }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat.random(in: 0...1)) {
            platform.fadeIn(time: 0.2)
        }
    }
}
