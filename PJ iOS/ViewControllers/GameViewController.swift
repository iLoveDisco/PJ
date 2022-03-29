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
    
    deinit {
        print("DEINIT: GameVC")
    }
    
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
    
    var currentLevelLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.alpha = 0.8
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        let strokeTextAttributes = [
          NSAttributedString.Key.strokeColor : UIColor.red,
          NSAttributedString.Key.foregroundColor : UIColor.white,
          NSAttributedString.Key.strokeWidth : -4.0,
          NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]
          as [NSAttributedString.Key : Any]

        label.attributedText = NSMutableAttributedString(string: "", attributes: strokeTextAttributes)
        return label
    }()
    
    @objc func handlePause() {
        if let scene = scene {
            if let nav = self.navigationController {
                scene.pause()
                
                let gamePauseVC = GamePauseViewController()
                gamePauseVC.scene = scene
                
                nav.pushViewController(gamePauseVC, animated: false)
                nav.navigationItem.setHidesBackButton(true, animated: true)
            }
        }
    }
    
    override func loadView() {
        self.view = SKView()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.startGame()
        
        self.view.addSubview(self.pauseButton)
        self.view.addSubview(self.currentLevelLabel)
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pauseButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            currentLevelLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            currentLevelLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            currentLevelLabel.widthAnchor.constraint(equalToConstant: 200),
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
      
        self.scene = GameScene(levelChangeHandler: { [weak self] currentLevel, totalNumLevels in
            
            let photoEmojis : [String] = ["🎆","🎇","🌠","🌅","🌆","🌁","🌃","🌄","🌉","🌌","🏙","🌇","🖼"]
            
            let strokeTextAttributes = [
              NSAttributedString.Key.strokeColor : UIColor.black,
              NSAttributedString.Key.foregroundColor : UIColor.white,
              NSAttributedString.Key.strokeWidth : -2.0,
              NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]
              as [NSAttributedString.Key : Any]

            if let gameVC = self {
                gameVC.currentLevelLabel.attributedText = NSMutableAttributedString(string: "\(photoEmojis[Int.random(in: 0..<photoEmojis.count)]) \(currentLevel) / \(totalNumLevels)", attributes: strokeTextAttributes)
            }
        })
        
        if isCameraMode {
            self.scene = GameScene()
            scene!.sceneLoadStrategy = CameraSceneLoading(self)
            self.currentLevelLabel.text = ""
        }
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
 
