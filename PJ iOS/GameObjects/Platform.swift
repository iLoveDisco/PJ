//
//  Platform.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import SpriteKit

let PLATFORM_Z_POS = 5.0
class Platform : GameObject{
    let node = SKSpriteNode(color: UIColor.white, size: CGSize())
    var animation : PlatformAnimation?
    
    init(_ pos : CGPoint, _ size: CGSize, animation : PlatformAnimation) {
        super.init(pos, size)
        node.position = super.pos
        node.size = size
        node.zPosition = PLATFORM_Z_POS
        node.name = "PLATFORM"
        self.animation = animation
    }
    
    override func resetPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 10
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
    }
    
    override func getNode() -> SKSpriteNode {
        return node
    }
    
    func flash() {
        if let animation = self.animation {
            animation.animateOnPlayerJump(self)
        }
    }
    
    func doLoadingAnimation(scene : GameScene) {
        self.hide()
        self.draw(scene)
        self.fadeOut(time: 0.01) {
            self.show()
            if let animation = self.animation {
                animation.animateOnLoad(self)
            }
        }
    }
}
