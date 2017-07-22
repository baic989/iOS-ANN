//
//  DrawingInterfaces.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

enum DrawingNavigationOption {
    case back
}

protocol DrawingWireframeInterface: WireframeInterface {
    func navigate(to option: DrawingNavigationOption)
}

protocol DrawingViewInterface: ViewInterface {
    var trainButton: UIButton { get set }
    var characterPickerView: UIPickerView { get set }
    
    func processImage()
    func classifyImage()
}

protocol DrawingPresenterInterface: PresenterInterface {
    
    var navigationOption: MainMenuNavigationOption { get set }
    
    func okButtonPressed()
    func didPressBackButton()
    func pixelize(image: UIImage) -> [Int]
    func updated(characterBox: CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) -> CGRect
}

protocol DrawingInteractorInterface: InteractorInterface {
}
