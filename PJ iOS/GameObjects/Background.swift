//
//  Background.swift
//  PJ iOS
//
//  Created by Eric Tu on 2/12/22.
//

import Foundation
import SpriteKit

class Background : GameObject {
    
    var node : SKSpriteNode
    
    init(image : UIImage, pos : CGPoint, size : CGSize) {
        let levelTexture = SKTexture(image: image)
        self.node = SKSpriteNode(texture: levelTexture)
        
        super.init(pos, size)
    }
    
    override func resetPhysics() {
        let background = self.node
        background.name = "IMAGE"
        
        background.zPosition = 1
        background.position = super.pos
        background.size = super.size
        
        background.physicsBody?.collisionBitMask = 0b0010
        background.physicsBody?.isDynamic = false
        background.physicsBody?.affectedByGravity = false
    }
    
    override func getNode() -> SKSpriteNode {
        return self.node
    }
}
