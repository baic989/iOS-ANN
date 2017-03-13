//
//  UIImage+Cropping.swift
//  ANN
//
//  Created by Hrvoje on 02/02/17.
//

import UIKit

extension UIImage {
    
    func cropImageWithRect(_ rect: CGRect) -> UIImage {
        let imageRef = self.cgImage!.cropping(to: rect)
        let newImage = UIImage(cgImage: imageRef!)
        return newImage
    }
}
