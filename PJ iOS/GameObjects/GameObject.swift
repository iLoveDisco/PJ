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
    }
    
    func getNode() -> SKSpriteNode {
        fatalError("getNode() should be overridden")
    }
    
    func draw(_ scene : SKScene) {
        let node = getNode()
        scene.addChild(node)
    }
}
