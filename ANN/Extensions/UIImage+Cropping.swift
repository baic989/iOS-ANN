//
//  UIImage+Cropping.swift
//  ANN
//
//  Created by Hrvoje on 02/02/17.
//

import UIKit

extension UIImage {
    
    func cropImageWithRect(rect: CGRect) -> UIImage {
        let imageRef = CGImageCreateWithImageInRect(self.CGImage!, rect)
        let newImage = UIImage(CGImage: imageRef!)
        return newImage!
    }
}