//
//  UIImage+Extension.swift
//  Vankeyi-Swift
//
//  Created by SimonYHB on 2017/2/23.
//  Copyright © 2017年 yhb. All rights reserved.
//

import UIKit

extension UIImage{
    static func createImageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, w: 1.0, h: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    static func getScreenShot() -> UIImage {
        let window = UIApplication.shared.keyWindow
        UIGraphicsBeginImageContextWithOptions((window?.bounds.size)!, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        window?.layer.render(in: context!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func gradientImage(colors: [UIColor], size: CGSize) -> UIImage? {
        let cgcolors = colors.map { $0.cgColor }
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()

    }
    
    // 图片压缩
    func compressImage(maxLength: Int) -> UIImage {
        let tempMaxLength: Int = maxLength / 8
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression), data.count > tempMaxLength else { return self }
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            
            if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                min = compression
            } else if data.count > tempMaxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < tempMaxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > tempMaxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false, 1 /*UIScreen.main.scale*/);
        self.draw(in: CGRect.init(x: 0, y: 0, w: reSize.width, h: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize.init(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
