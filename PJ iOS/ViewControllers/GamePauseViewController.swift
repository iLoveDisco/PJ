//
//  GamePauseViewController.swift
//  PJ iOS
//
//  Created by Eric Tu on 3/23/22.
//

import Foundation
import UIKit

class GamePauseViewController : UIViewController {
    
    var scene : GameScene?
    
    let pauseLabel : UILabel = {
        let label = UILabel()
        label.text = "Game Paused"
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let unpauseButton : UIButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("Unpause", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleUnpause), for: .touchUpInside)
        return button
    }()
    
    let quitGameButton : UIButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("Quit Game", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleQuitGame), for: .touchUpInside)
        return button
    }()
    
    @objc func handleUnpause() {
        if let scene = self.scene {
            self.navigationController?.popViewController(animated: false)
            scene.unpause()
        }
    }
    
    @objc func handleQuitGame() {
        self.navigationController?.setViewControllers([StartMenuViewController()], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonWidth = 130.0
        let buttonHeight = 40.0
        let labelWidth = 300.0
        self.navigationItem.hidesBackButton = true
        view.addSubview(unpauseButton)
        view.addSubview(pauseLabel)
        view.addSubview(quitGameButton)
        NSLayoutConstraint.activate([
            pauseLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2),
            pauseLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            pauseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2.0 - labelWidth / 2.0),
            unpauseButton.topAnchor.constraint(equalTo: pauseLabel.bottomAnchor, constant: view.bounds.height * 0.15),
            unpauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2.0 - buttonWidth / 2.0),
            unpauseButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            unpauseButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            quitGameButton.topAnchor.constraint(equalTo: unpauseButton.bottomAnchor, constant: view.bounds.height * 0.025),
            quitGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2.0 - buttonWidth / 2.0),
            quitGameButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
}
