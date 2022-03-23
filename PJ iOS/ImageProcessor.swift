//
//  ImageProcessor.swift
//  PictoJump iOS
//
//  Created by Eric Tu on 12/12/21.
//

import Foundation

class ImageProcessor {
    // taken from http://stackoverflow.com/questions/24049313/
    // and adapted to swift 1.2
    let image: CGImage
    var bitmapData: UnsafeMutableRawPointer?
    var context: CGContext?
    var width: Int {
        get {
            return image.width
        }
    }
    
    var height: Int {
        get {
            return image.height
        }
    }
    
    init(img: CGImage) {
        image = img
        self.create_bitmap_context(img: img)
    }
    
    private func create_bitmap_context(img: CGImage) {
        
        // Get image width, height
        let pixelsWide = img.width
        let pixelsHigh = img.height
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        self.bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        // draw the image onto the context
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        
        context!.draw(img, in: rect)
        
        self.context = context
    }
    
    func color_at(x: Int, y: Int)->UIColor {
        
        if x < 0 || x >= width {
            return UIColor.black
        }
        
        if y < 0 || y >= height {
            return UIColor.black
        }

        let data = context!.data
    
        let offset = 4 * (y * width + x)
        
        let alpha = (data! + offset).load(as: UInt8.self)
        let red = (data! + offset + 1).load(as: UInt8.self)
        let green = (data! + offset + 2).load(as: UInt8.self)
        let blue = (data! + offset + 3).load(as: UInt8.self)
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        
        return color
    }
    
    func freeImageMemory() {
        if let bitmapData = bitmapData {
            free(bitmapData)
        }
        else {
            fatalError("Freeing memory when image has not been instantiated")
        }
    }
}
