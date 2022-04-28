//
//  SceneLoading.swift
//  PJ iOS
//
//  Created by Eric Tu on 2/25/22.
//

import Foundation
import SpriteKit


protocol SceneLoadingStrategy {
    func setScene(scene: GameScene)
}

class CameraViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var didCameraTakeImage : Bool = false
    
    var onImageSelection : (UIImage) -> Void = { image in
        print("not implemented")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.didCameraTakeImage = true

        onImageSelection(image)
    }
}

class MyImagePickerController : UIImagePickerController {
    var scene: GameScene?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let delegate = super.delegate as! CameraViewController
        
        if !delegate.didCameraTakeImage {
            scene!.loadImage()
            scene!.loadGameObjects()
        }
        
        delegate.didCameraTakeImage = false
    }
}

class CameraSceneLoading : SceneLoadingStrategy {
    
    weak var viewController : UIViewController?
    var cameraVC : CameraViewController?
    
    init(_ view : UIViewController) {
        self.viewController = view
        self.cameraVC = CameraViewController()
    }
    
    deinit {
        print("DEINIT: Camera Scene Loading")
    }
    
    private func openCamera(_ scene : GameScene, _ photoUse : @escaping (UIImage) -> Void) {
        
        
        cameraVC!.onImageSelection = photoUse
        
        let picker = MyImagePickerController()
        picker.scene = scene
        picker.sourceType = UIImagePickerController.SourceType.camera
        picker.delegate = self.cameraVC
        
        self.viewController?.present(picker, animated: true) {
            
        }
    }
    
    func setScene(scene: GameScene) {
        scene.removeAllChildren()
        scene.didPlayerPlayFirstLevel = true
        scene.edgePlatforms = []
        scene.extraPlatforms = []
        scene.monsters = []
    
        self.openCamera(scene) {image in
            scene.loadImage(image: image)
            scene.loadGameObjects()
        }
    }
}

class NormalSceneLoading : SceneLoadingStrategy {
    func setScene(scene: GameScene) {
        scene.removeAllChildren()
        
        scene.edgePlatforms = []
        scene.extraPlatforms = []
        scene.monsters = []
        
        scene.loadImage()
        scene.loadGameObjects()
    }
}


