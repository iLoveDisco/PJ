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
    
    init() {
        self.loadAllPhotoRefs()
    }
    
    func loadAllPhotoRefs() {
        /// Load Photos
        let fetchOptions = PHFetchOptions()
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let assetsArray = assets.objects(at: IndexSet(integersIn: 0...assets.count - 1))
        
        self.allPhotos = assetsArray
        
        if ImageExtractor.idx == 0 {
            ImageExtractor.idx = self.allPhotos!.count - ImageExtractor.WHERE_WE_LEFT_OFF
        }
    }
    
    func processPhoto(_ image : UIImage) -> UIImage {
        var resizedImage : UIImage
        
        let screenSize = UIScreen.main.bounds
        
        if image.size.height / image.size.width > screenSize.height / screenSize.width {
            resizedImage = self.resizeImageToScreenWidth(image)
            return self.randomImageHeightCrop(resizedImage)
        } else {
            resizedImage = self.resizeImageToScreenHeight(image)
        }
        return self.randomImageWidthCrop(resizedImage)
    }
    
    func getRandomPhoto() -> UIImage?{
        var output: UIImage?
        if let allPhotos = self.allPhotos {
            let randomIdx = Int.random(in: 0...allPhotos.count - 1)
            let asset = self.allPhotos!.remove(at: ImageExtractor.idx)
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
            })
            
            if output == nil {
                print("Detecting a BAD photo!")
            }
        }
        
        return self.processPhoto(output!)
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
    
    func resizeImageToScreenWidth(_ image : UIImage) -> UIImage {
        let screenSize : CGRect = UIScreen.main.bounds
        
        let ratio = screenSize.width / image.size.width
        
        let newWidth = screenSize.width
        let newHeight = image.size.height * ratio
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func randomImageWidthCrop(_ image : UIImage) -> UIImage {
        var xOffset = 0
        
        if image.size.width > UIScreen.main.bounds.width {
            xOffset = Int.random(in: 0 ... Int(image.size.width - UIScreen.main.bounds.width))
        }
        
        let cropRect = CGRect(x: CGFloat(xOffset), y: 0, width: UIScreen.main.bounds.width, height: image.size.height).integral
        
        let croppedCG = image.cgImage?.cropping(to: cropRect)
        
        return UIImage(cgImage: croppedCG!)
    }
    
    func randomImageHeightCrop(_ image : UIImage) -> UIImage {
        var xOffset = 0
        
        if image.size.height > UIScreen.main.bounds.height {
            xOffset = Int.random(in: 0 ... Int(image.size.height - UIScreen.main.bounds.height))
        }
        
        let cropRect = CGRect(x: 0, y: CGFloat(xOffset), width: image.size.width, height: UIScreen.main.bounds.height).integral
        
        let croppedCG = image.cgImage?.cropping(to: cropRect)
        
        return UIImage(cgImage: croppedCG!)
    }
}
