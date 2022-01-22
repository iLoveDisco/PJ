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
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE");
        self.startGame()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("HERE1")
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
    
    private func startGame() {
        let skView = self.view as! SKView
      
        let scene = GameScene()
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
 
