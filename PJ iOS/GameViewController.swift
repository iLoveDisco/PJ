//
//  GameViewController.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/18/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var imageViewSource: UIImageView!
    
    @IBOutlet weak var imageViewOutput: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Present the scene
        let skView = self.view as! SKView
      
        let scene = GameScene()
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
 
