//
//  UIImage+Scaling.swift
//  ANN
//
//  Created by Hrvoje on 02/02/17.
//

import UIKit

extension UIImage {
    
    func scaleImageToSize(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        
        // kCGInterpolationNone - There is no smoothing of pixels after scaling (the image is not blurred)
        // which is important for pixelizing the image for neural network input
        CGContextSetInterpolationQuality(context, kCGInterpolationNone)
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let imageRef = CGBitmapContextCreateImage(context)! as CoreImage.CGImage
        
        // try
        // let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let newImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Up)
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}