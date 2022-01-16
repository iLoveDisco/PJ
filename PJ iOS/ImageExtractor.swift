//
//  ImageExtractor.swift
//  PJ iOS
//
//  Created by Eric Tu on 1/14/22.
//

import Foundation
import Photos

class ImageExtractor {
    var allPhotos : [PHAsset]? = []
    
    func loadAllPhotoRefs() {
        /// Load Photos
        let group = DispatchGroup()
        group.enter()
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let assetsArray = assets.objects(at: IndexSet(integersIn: 0...assets.count - 1))
                
                self.allPhotos = assetsArray.filter { Int($0.pixelWidth) >= Int(UIScreen.main.bounds.width)}
                
                group.leave()
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            case .limited:
                print("Photo Access is limited")
            @unknown default:
                print("Photo access default")
            }
            
            
        }
        group.wait()
    }
    
    func getRandomPhoto() -> UIImage?{
        
        var output: UIImage?
        self.loadAllPhotoRefs()
        
        if let allPhotos = self.allPhotos {
            let idx = Int.random(in: 0...allPhotos.count - 1)
            let asset = allPhotos[idx]
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                output = result!
            })
            
        }
        return output
    }
}
