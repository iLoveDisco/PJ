//
//  GameObject.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/19/21.
//

import Foundation
import SpriteKit

class GameObject {
    let pos : CGPoint
    let size : CGSize
   
    init(_ pos: CGPoint, _ size: CGSize) {
        self.pos = pos;
        self.size = size;
        self.resetPhysics()
    }
    
    func resetPhysics() {
        fatalError("resetPhysics() should be overridden")
    }
    
    func getNode() -> SKSpriteNode {
        fatalError("getNode() should be overridden")
    }
    
    func draw(_ scene : SKScene) {
        let node = getNode()
        scene.addChild(node)
    }
    
    func isTouching(_ node : SKNode) -> Bool{
        let myNode = self.getNode()
        return myNode.intersects(node)
    }
    
    func distanceFrom(_ obj : GameObject) -> CGFloat {
        let x1 = self.getNode().position.x
        let y1 = self.getNode().position.y
        
        let x2 = obj.getNode().position.x
        let y2 = obj.getNode().position.y
        
        return sqrt(pow(x1 - x2,2) + pow(y1 - y2,2))
    }
    
    func fadeOut(time : Double, _ onComplete : @escaping ()->Void) {
        self.getNode().run(SKAction.fadeOut(withDuration: time)) {
            onComplete()
        }
    }
    
    func fadeOut(time : Double) {
        self.fadeOut(time: time) {
            // do nothing
        }
    }
    
    func fadeIn(time : Double,  _ onComplete : @escaping ()->Void) {
        
        self.getNode().run(SKAction.fadeIn(withDuration: time)) {
            onComplete()
        }
    }
    
    func fadeIn(time : Double) {
        self.fadeIn(time: time) {
            // do nothing
        }
    }
    
    func hide() {
        self.getNode().isHidden = true
    }
    
    func show() {
        self.getNode().isHidden = false
    }
    
}
