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
    
    static var WHERE_WE_LEFT_OFF = 1
    static var idx = 0
    
    func loadAllPhotoRefs() {
        /// Load Photos
        let fetchOptions = PHFetchOptions()
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let assetsArray = assets.objects(at: IndexSet(integersIn: 0...assets.count - 1))
        
        self.allPhotos = assetsArray.filter { Int($0.pixelWidth) >= Int(UIScreen.main.bounds.width)}
        
        if ImageExtractor.idx == 0 {
            ImageExtractor.idx = self.allPhotos!.count - ImageExtractor.WHERE_WE_LEFT_OFF
        }
    }
    
    func getRandomPhoto() -> UIImage?{
        
        var output: UIImage?
        self.loadAllPhotoRefs()
        if let allPhotos = self.allPhotos {
            let randomIdx = Int.random(in: 0...allPhotos.count - 1)
            let asset = allPhotos[ImageExtractor.idx]
            print("Using image: \(allPhotos.count - ImageExtractor.idx) of \(allPhotos.count). Photo date: \(asset.creationDate!) (width,height) : (\(asset.pixelWidth),\(asset.pixelHeight))")
            
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
        }
        
        let resizedImage = self.resizeImageToScreenHeight(output!)
        let croppedResizedImage = self.randomImageCrop(resizedImage)
        
        return croppedResizedImage
    }
    
    func resizeImageToScreenHeight(_ image : UIImage) -> UIImage {
        let screenSize: CGRect = UIScreen.main.bounds
        let ratio = screenSize.height / image.size.height
        
        let newWidth = ratio * image.size.width
        let newHeight = screenSize.height
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func randomImageCrop(_ image : UIImage) -> UIImage {
        var xOffset = 0
        
        if image.size.width > UIScreen.main.bounds.width {
            xOffset = Int.random(in: 0 ... Int(image.size.width - UIScreen.main.bounds.width))
        }
        
        let cropRect = CGRect(x: CGFloat(xOffset), y: 0, width: UIScreen.main.bounds.width, height: image.size.height).integral
        
        let croppedCG = image.cgImage?.cropping(to: cropRect)
        
        return UIImage(cgImage: croppedCG!)
    }
}
