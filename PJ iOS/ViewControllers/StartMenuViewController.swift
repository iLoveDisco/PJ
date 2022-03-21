//
//  GameViewController.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 11/18/21.
//

import UIKit
import SpriteKit
import GameplayKit
import Photos

class StartMenuViewController: UIViewController {

    let openAlbumModeButton: UIButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("Album Mode", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOpenAlbumMode), for: .touchUpInside)
        return button
    }()
    
    let openCameraModeButton: UIButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("Camera Mode", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(openAlbumModeButton)
        
        let buttonWidth = 160.0
        let buttonHeight = 40.0
      
        NSLayoutConstraint.activate([
            openAlbumModeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.bounds.height / 2.5),
            openAlbumModeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.bounds.width / 2.0 - buttonWidth / 2.0),
            openAlbumModeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            openAlbumModeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
        ])
        self.handleStatus(PHPhotoLibrary.authorizationStatus())
    }
    
    @objc func handleOpenAlbumMode() {
        self.navigationController?.setViewControllers([GameViewController()], animated: false)
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
    
    private func requestPermissions () {
        print("requestPhotoPermissions: requesting photo perms")

        PHPhotoLibrary.requestAuthorization { (status) in
            self.handleStatus(status)
        }
    }
    
    private func handleStatus(_ status : PHAuthorizationStatus) {
        switch status {
        case .authorized:
            print("Good to proceed")
        case .denied, .restricted:
            print("Not allowed")
        case .notDetermined:
            self.requestPermissions()
        case .limited:
            print("Photo Access is limited")
        @unknown default:
            break;
        }
    }
}

class StartGameSegue : UIStoryboardSegue {
    override func perform() {

        if let navigationController = self.source.navigationController {
            navigationController.setViewControllers([self.destination], animated: true)
        }
    }
}

class StartGameCameraModeSegue : UIStoryboardSegue {
    override func perform() {
        if let navigationController = self.source.navigationController {
            
            let view = self.destination as! GameViewController
            
            view.isCameraMode = true
            navigationController.setViewControllers([self.destination], animated: true)
        }
    }
}
