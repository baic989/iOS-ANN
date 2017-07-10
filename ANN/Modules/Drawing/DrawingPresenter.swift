//
//  DrawingPresenter.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingPresenter {
    
    // MARK: - Private properties -
    
    fileprivate weak var _view: DrawingViewInterface?
    fileprivate var _interactor: DrawingInteractorInterface
    fileprivate var _wireframe: DrawingWireframeInterface
    fileprivate var _navigationOption: MainMenuNavigationOption
    
    // MARK: - Lifecycle -
    
    init (wireframe: DrawingWireframeInterface, view: DrawingViewInterface, interactor: DrawingInteractorInterface, navigationOption: MainMenuNavigationOption) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        _navigationOption = navigationOption
    }
    
    // MARK: - Helpers -
    
    fileprivate func setupUI() {
        switch _navigationOption {
        case .test:
            _view?.trainButton.isHidden = true
            _view?.characterPickerView.isHidden = true
        case .train:
            _view?.trainButton.isHidden = false
            _view?.characterPickerView.isHidden = false
        }
    }
}

// MARK: - Extensions -

extension DrawingPresenter: DrawingPresenterInterface {
    
    // CGRect is a struct and therefore passed by value,
    // so the parameter must be declared as inout and passed by reference
    // This method expands the box when drawing out of it's frame
    func updated(characterBox: CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) -> CGRect {
        let x = minX ?? characterBox.minX
        let y = minY ?? characterBox.minY
        let width = (maxX ?? characterBox.maxX) - (minX ?? characterBox.minX)
        let height = (maxY ?? characterBox.maxY) - (minY ?? characterBox.minY)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func pixelize(image: UIImage) -> [Int] {
        let pixelData = image.cgImage?.dataProvider?.data
        let dataPointer: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixelsArray = [Int]()
        let bytesPerRow = image.cgImage?.bytesPerRow
        let bytesPerPixel = ((image.cgImage?.bitsPerPixel)! / 8)
        var position = 0
        for _ in 0..<Int(image.size.height) {
            for _ in 0..<Int(image.size.width) {
                let alpha = Float(dataPointer[position + 3]) // [r,g,b,a]
                pixelsArray.append(Int(alpha / 255))
                position += Int(bytesPerPixel)
            }
            if position % Int(bytesPerRow!) != 0 {
                position += (Int(bytesPerRow!) - (position % Int(bytesPerRow!)))
            }
        }
        
        return pixelsArray
    }
    
    
    func viewDidLoad() {
        setupUI()
    }
    
    func didPressBackButton() {
        _wireframe.navigate(to: .back)
    }
    
    internal func okButtonPressed() {
        switch _navigationOption {
        case .test:
            _view?.classifyImage()
        case .train:
            _view?.processImage()
        }
    }

}
