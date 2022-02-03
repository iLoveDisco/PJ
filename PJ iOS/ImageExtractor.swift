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
    
    static var WHERE_WE_LEFT_OFF = 75
    static var idx = 0
    
    func loadAllPhotoRefs() {
        /// Load Photos
        let fetchOptions = PHFetchOptions()
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let assetsArray = assets.objects(at: IndexSet(integersIn: 0...assets.count - 1))
        
        self.allPhotos = assetsArray.filter { Int($0.pixelWidth) >= Int(UIScreen.main.bounds.width)}
        
        if ImageExtractor.idx == 0 {
            ImageExtractor.idx = self.allPhotos!.count - 1 - ImageExtractor.WHERE_WE_LEFT_OFF
        }
    }
    
    func getRandomPhoto() -> UIImage?{
        
        var output: UIImage?
        self.loadAllPhotoRefs()
        if let allPhotos = self.allPhotos {
            let randomIdx = Int.random(in: 0...allPhotos.count - 1)
            let asset = allPhotos[randomIdx]
            ImageExtractor.idx = ImageExtractor.idx - 1
            
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            
            option.isSynchronous = true
            option.deliveryMode = .opportunistic
            option.version = .current
            option.isNetworkAccessAllowed = true
            
            manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                output = result
                print("requestingImage")
            })
            
            if output == nil {
                print("Detecting a BAD photo!")
            }
            
            print("Using image: \(allPhotos.count - ImageExtractor.idx) of \(allPhotos.count). Photo date: \(asset.creationDate!) (width,height) : (\(asset.pixelWidth),\(asset.pixelHeight))")
            
        }
        return output
    }
}
