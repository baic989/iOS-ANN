//
//  UIImage+Scaling.swift
//  ANN
//
//  Created by Hrvoje on 02/02/17.
//

import UIKit

extension UIImage {
    
    func scaleImageToSize(_ size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        // kCGInterpolationNone - There is no smoothing of pixels after scaling (the image is not blurred)
        // which is important for pixelizing the image for neural network input
        context.interpolationQuality = .none
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let imageRef = (context.makeImage())! as CoreImage.CGImage
        
        // try
        // let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let newImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.up)
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
