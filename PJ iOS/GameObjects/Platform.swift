//
//  Platform.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import SpriteKit

let PLATFORM_Z_POS = 5.0
class Platform : GameObject{
    let node = SKSpriteNode(color: UIColor.green, size: CGSize())
    
    override init(_ pos : CGPoint, _ size: CGSize) {
        super.init(pos, size)
        node.position = super.pos;
        node.size = size;
        node.zPosition = PLATFORM_Z_POS
        node.name = "PLATFORM"
    }
    
    override func resetPhysics() {
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.5
        node.physicsBody?.friction = 0.5
        node.physicsBody?.angularDamping = 0
        node.physicsBody?.linearDamping = 3
        
        node.physicsBody?.contactTestBitMask = 0b00000000
        node.physicsBody?.categoryBitMask =    0b00000000
        node.physicsBody?.collisionBitMask =   0b00000000
    }
    
    override func getNode() -> SKSpriteNode {
        return node
    }
    
    func fadeOut(time : Int) {
        self.node.run(SKAction.fadeOut(withDuration: 2.0))
    }
}
