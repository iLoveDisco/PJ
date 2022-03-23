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
    var isCameraMode = false
    var scene : GameScene?
    
    var pauseButton : MyButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("⏸", for: .normal)
        button.titleLabel?.font = button.titleLabel!.font.withSize(30)
        button.layer.borderWidth = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.alpha = 0.9
        return button
    }()
    
    @objc func handlePause() {
        print("pause button pressed")
    }
    
    override func loadView() {
        self.view = SKView()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.startGame()
        
        self.view.addSubview(self.pauseButton)
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pauseButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
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
        
        if isCameraMode {
            scene.sceneLoadStrategy = CameraSceneLoading(self)
        }
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
 
