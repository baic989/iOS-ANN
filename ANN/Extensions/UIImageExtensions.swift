//
//  UIImageExtensions.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

extension UIImage {
    
    func cropImageWith(rect: CGRect) -> UIImage? {
        guard let imageRef = self.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    func scaleImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
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
