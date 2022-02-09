//
//  JumpBehavior.swift
//  PJ iOS
//
//  Created by Eric Tu on 2/8/22.
//

import Foundation
import SpriteKit

protocol PlatformAnimation {
    func animate(_ platform : Platform)
}

class EdgePlatformAnimation : PlatformAnimation {
    var scene : GameScene
    
    init (_ scene : GameScene) {
        self.scene = scene
    }
    
    func animate(_ platform : Platform) {
        
        platform.node.run(SKAction.fadeIn(withDuration: 0.2)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                platform.node.run(SKAction.fadeOut(withDuration: 0.1))
            }
        }
    }
    
    
}

class ExtraPlatformAnimation : PlatformAnimation {
    func animate(_ platform : Platform) {
        // does nothing for now
    }
    
    
}
