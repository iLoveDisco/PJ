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
    @IBOutlet weak var imageViewSource: UIImageView!
    
    @IBOutlet weak var imageViewOutput: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleStatus(PHPhotoLibrary.authorizationStatus())
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
