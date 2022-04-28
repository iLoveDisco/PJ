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
        button.setTitle("Start Game", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOpenAlbumMode), for: .touchUpInside)
        return button
    }()
    
    let openCameraModeButton: UIButton = {
        let button = MyButton(frame: CGRect())
        button.setTitle("Camera Mode", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOpenCameraMode), for: .touchUpInside)
        return button
    }()
    
    let titleCard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "titlecard")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let startScreenArt: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "startscreen")
        return imageView
    }()
    
    deinit {
        print("DEINIT: StartMenuVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(openAlbumModeButton)
        view.addSubview(openCameraModeButton)
        view.addSubview(titleCard)
        view.addSubview(startScreenArt)
        
        let buttonWidth = 160.0
        let buttonHeight = 40.0
        
        let ratio = view.bounds.width / startScreenArt.image!.size.width
        let artHeight = ratio * startScreenArt.image!.size.height
        let artMultiplier = artHeight / view.bounds.height
        
        NSLayoutConstraint.activate([
            openAlbumModeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.bounds.height / 2.5),
            openAlbumModeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.bounds.width / 2.0 - buttonWidth / 2.0),
            openAlbumModeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            openAlbumModeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            openCameraModeButton.topAnchor.constraint(equalTo: openAlbumModeButton.bottomAnchor, constant: 10),
            openCameraModeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.bounds.width / 2.0 - buttonWidth / 2.0),
            openCameraModeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            openCameraModeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            startScreenArt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            startScreenArt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            startScreenArt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            startScreenArt.heightAnchor.constraint(equalTo: view.heightAnchor, constant: artMultiplier),
            titleCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            titleCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleCard.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            titleCard.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.13)
        ])
        
        self.handleStatus(PHPhotoLibrary.authorizationStatus())
    }
    
    @objc func handleOpenAlbumMode() {
        self.navigationController?.modalTransitionStyle = .crossDissolve
        self.navigationController?.setViewControllers([GameViewController()], animated: false)
    }
    
    @objc func handleOpenCameraMode() {
        let gameVC = GameViewController()
        gameVC.isCameraMode = true
        self.navigationController?.setViewControllers([gameVC], animated: false)
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
            self.showPermissionsAlert()
        case .notDetermined:
            self.requestPermissions()
        case .limited:
            print("Photo Access is limited")
        @unknown default:
            break;
        }
    }
    
    
    private func showPermissionsAlert() {
        let alert = UIAlertController(title: "Oops!", message: "PictoJump needs full access to your photo library. Allow access via\nSettings -> PictoJump -> Photos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                self.openAlbumModeButton.isEnabled = false
                self.openAlbumModeButton.alpha = 0.5
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
